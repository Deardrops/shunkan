import 'dart:async';
import 'dart:typed_data';
import '../models/app_settings.dart';
import '../models/subtitle_entry.dart';
import '../models/translation_result.dart';
import 'audio_recorder_service.dart';
import 'translation_service.dart';

/// Orchestrates microphone/system PCM streaming → WebSocket translation session.
class AudioPipelineService {
  final AudioRecorderService _recorder;
  final TranslationService _translation;

  final _subtitleController = StreamController<SubtitleEntry>.broadcast();
  Stream<SubtitleEntry> get subtitleStream => _subtitleController.stream;

  StreamSubscription<TranslationResult>? _resultSub;
  StreamSubscription<Uint8List>? _audioSub;
  int _sentenceIndex = 0;

  AudioPipelineService(this._recorder, this._translation);

  Future<void> start({
    required String apiKey,
    required String sourceLanguage,
    required String targetLanguage,
    AudioSourceType audioSource = AudioSourceType.microphone,
  }) async {
    _sentenceIndex = 0;
    _translation.configure(apiKey: apiKey);

    // Open WebSocket session first
    await _translation.startSession(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    // Subscribe to translation results
    _resultSub = _translation.resultStream.listen((result) {
      if (result.isError) return;
      if (result.originalText.isEmpty && result.translationText.isEmpty) return;

      _subtitleController.add(SubtitleEntry(
        originalText: result.originalText,
        translatedText: result.translationText,
        timestamp: DateTime.now(),
        chunkIndex: result.isPartial ? _sentenceIndex : _sentenceIndex++,
        isPartial: result.isPartial,
      ));
    });

    // Start PCM audio stream and pipe to WebSocket
    final audioStream = await _recorder.startStream(source: audioSource);
    _audioSub = audioStream.listen(
      (pcmData) => _translation.sendAudio(pcmData),
      onError: (_) {},
    );
  }

  Future<void> stop() async {
    // Stop microphone first, then close WebSocket
    await _audioSub?.cancel();
    _audioSub = null;

    await _recorder.stopStream();
    await _translation.stopSession();

    await _resultSub?.cancel();
    _resultSub = null;
  }

  void dispose() {
    _subtitleController.close();
  }
}
