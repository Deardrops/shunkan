import 'dart:async';
import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/translation_result.dart';

/// WebSocket-based live translation service using the DashScope Realtime API.
///
/// Protocol (OpenAI Realtime API compatible):
///   1. Connect to wss://dashscope.aliyuncs.com/api-ws/v1/realtime?model=...
///      with Authorization: Bearer {key}
///   2. Send session.update (configure target language + source transcription)
///   3. Wait for session.updated
///   4. Stream audio as input_audio_buffer.append (base64-encoded PCM in JSON)
///   5. Receive result events:
///      - conversation.item.input_audio_transcription.text  → partial original
///      - conversation.item.input_audio_transcription.completed → final original
///      - response.text.delta / response.audio_transcript.text → partial translation
///      - response.text.done / response.audio_transcript.done  → final translation
///   6. Close the WebSocket to end the session
class TranslationService {
  static const _wsUrl =
      'wss://dashscope.aliyuncs.com/api-ws/v1/realtime'
      '?model=qwen3-livetranslate-flash-realtime';

  String _apiKey = '';

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _channelSub;

  /// Completes when `session.updated` is received, signalling the session is
  /// ready to accept audio.
  Completer<void>? _sessionReadyCompleter;

  // Accumulated state for the sentence currently being spoken
  String _partialOriginal = '';
  String _partialTranslation = '';
  String _finalOriginal = '';

  final _resultController =
      StreamController<TranslationResult>.broadcast();

  Stream<TranslationResult> get resultStream => _resultController.stream;

  bool get isConnected => _channel != null;

  void configure({required String apiKey}) {
    _apiKey = apiKey;
    OpenAI.apiKey = apiKey;
    OpenAI.baseUrl = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  }

  /// Opens the WebSocket and configures a translation session.
  /// Returns only after `session.updated` is received (i.e. the server is
  /// ready to accept audio).
  Future<void> startSession({
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (_apiKey.isEmpty) {
      _resultController.add(TranslationResult.error('API Key 未配置'));
      return;
    }

    _sessionReadyCompleter = Completer<void>();
    _partialOriginal = '';
    _partialTranslation = '';
    _finalOriginal = '';

    _channel = IOWebSocketChannel.connect(
      Uri.parse(_wsUrl),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    _channelSub = _channel!.stream.listen(
      _onMessage,
      onError: (e) {
        debugPrint('[TranslationService] WS error: $e');
        _resultController.add(TranslationResult.error('WebSocket 连接错误: $e'));
        _sessionReadyCompleter?.completeError(e);
      },
      onDone: () => debugPrint('[TranslationService] WS closed'),
      cancelOnError: false,
    );

    // Send session.update immediately after connecting (before session.created).
    // The server queues and applies it once the session is initialised.
    _sendJson({
      'event_id': _eventId(),
      'type': 'session.update',
      'session': {
        // text-only mode: no audio synthesis, lower latency
        'modalities': ['text'],
        'input_audio_format': 'pcm',
        'output_audio_format': 'pcm',
        // Enable source-language transcription so we can display original text
        'input_audio_transcription': {
          'model': 'qwen3-asr-flash-realtime',
          'language': sourceLanguage,
        },
        'translation': {
          'language': targetLanguage,
        },
      },
    });

    // Wait until the server acknowledges the configuration (session.updated).
    // Time out after 10 s and proceed anyway to avoid blocking the UI.
    try {
      await _sessionReadyCompleter!.future
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      debugPrint('[TranslationService] session.updated timed out, proceeding');
    } catch (_) {
      // Error already forwarded to resultStream; proceed anyway
    }
  }

  /// Encodes [pcmData] as Base64 and sends it as an `input_audio_buffer.append`
  /// JSON event. This is the Realtime API wire format (not raw binary frames).
  void sendAudio(Uint8List pcmData) {
    if (_channel == null || pcmData.isEmpty) return;
    _sendJson({
      'event_id': _eventId(),
      'type': 'input_audio_buffer.append',
      'audio': base64.encode(pcmData),
    });
  }

  /// Closes the WebSocket connection, ending the session.
  Future<void> stopSession() async {
    if (_channel == null) return;
    try {
      await _channelSub?.cancel();
      _channelSub = null;
      await _channel?.sink.close();
    } catch (e) {
      debugPrint('[TranslationService] stopSession error: $e');
    } finally {
      _channel = null;
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  void _sendJson(Map<String, dynamic> payload) {
    try {
      _channel?.sink.add(jsonEncode(payload));
    } catch (e) {
      debugPrint('[TranslationService] send error: $e');
    }
  }

  /// Monotonically increasing event ID (millisecond timestamp).
  String _eventId() => 'event_${DateTime.now().millisecondsSinceEpoch}';

  void _onMessage(dynamic message) {
    if (message is! String) return;

    Map<String, dynamic> event;
    try {
      event = jsonDecode(message) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[TranslationService] JSON parse error: $e');
      return;
    }

    final type = event['type'] as String?;
    debugPrint('[TranslationService] ← $type');

    switch (type) {
      // ── Session lifecycle ────────────────────────────────────────────────
      case 'session.created':
        debugPrint('[TranslationService] session created, waiting for updated');

      case 'session.updated':
        debugPrint('[TranslationService] session ready, streaming audio');
        if (!(_sessionReadyCompleter?.isCompleted ?? true)) {
          _sessionReadyCompleter!.complete();
        }

      // ── Source-language transcription ─────────────────────────────────
      case 'conversation.item.input_audio_transcription.text':
        // Incremental original-text recognition (field: "stash")
        final stash = (event['stash'] as String?)?.trim() ?? '';
        if (stash.isNotEmpty) {
          _partialOriginal = stash;
          _resultController.add(TranslationResult(
            originalText: stash,
            translationText: _partialTranslation,
            isError: false,
            isPartial: true,
          ));
        }

      case 'conversation.item.input_audio_transcription.completed':
        // Final original text (field: "transcript")
        _finalOriginal =
            (event['transcript'] as String?)?.trim() ?? _partialOriginal;

      // ── Translation output (incremental) ──────────────────────────────
      case 'response.text.delta':
        // Text-only mode incremental translation (field: "delta")
        final delta = (event['delta'] as String?) ?? '';
        if (delta.isNotEmpty) {
          _partialTranslation += delta;
          _resultController.add(TranslationResult(
            originalText: _partialOriginal,
            translationText: _partialTranslation,
            isError: false,
            isPartial: true,
          ));
        }

      case 'response.audio_transcript.text':
        // Audio-mode incremental translation transcript (field: "delta")
        final delta = (event['delta'] as String?) ?? '';
        if (delta.isNotEmpty) {
          _partialTranslation += delta;
          _resultController.add(TranslationResult(
            originalText: _partialOriginal,
            translationText: _partialTranslation,
            isError: false,
            isPartial: true,
          ));
        }

      // ── Translation output (final) ────────────────────────────────────
      case 'response.text.done':
        // Text-only mode final translation (field: "text")
        _emitFinalResult(event['text'] as String?);

      case 'response.audio_transcript.done':
        // Audio-mode final translation (field: "transcript")
        _emitFinalResult(event['transcript'] as String?);

      // ── Response complete ─────────────────────────────────────────────
      case 'response.done':
        debugPrint('[TranslationService] response done');

      // ── Error ─────────────────────────────────────────────────────────
      case 'error':
        final err = event['error'] as Map<String, dynamic>?;
        final code = err?['code'] ?? '';
        final msg = err?['message'] ?? '未知错误';
        debugPrint('[TranslationService] API error $code: $msg');
        _resultController
            .add(TranslationResult.error('API 错误 $code: $msg'));

      default:
        // Ignore: session.created handled above; other lifecycle events ignored
        break;
    }
  }

  /// Emits a final (non-partial) [TranslationResult] and resets per-sentence
  /// accumulators.
  void _emitFinalResult(String? rawText) {
    final text = rawText?.trim() ?? '';
    if (text.isEmpty) return;

    final original =
        _finalOriginal.isNotEmpty ? _finalOriginal : _partialOriginal;

    _resultController.add(TranslationResult(
      originalText: original,
      translationText: text,
      isError: false,
      isPartial: false,
    ));

    // Reset accumulators for the next sentence
    _partialOriginal = '';
    _partialTranslation = '';
    _finalOriginal = '';
  }

  void dispose() {
    _channelSub?.cancel();
    _channel?.sink.close();
    _resultController.close();
  }
}
