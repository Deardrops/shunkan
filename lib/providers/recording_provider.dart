import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/subtitle_entry.dart';
import '../models/recording_session.dart';
import 'service_providers.dart';
import 'settings_provider.dart';
import 'history_provider.dart';

enum RecordingStatus { idle, recording, stopping, error }

class RecordingState {
  final RecordingStatus status;
  final List<SubtitleEntry> entries;
  final SubtitleEntry? partialEntry;
  final String? currentSessionUuid;
  final DateTime? sessionStartTime;
  final String? errorMessage;

  const RecordingState({
    required this.status,
    required this.entries,
    this.partialEntry,
    this.currentSessionUuid,
    this.sessionStartTime,
    this.errorMessage,
  });

  RecordingState copyWith({
    RecordingStatus? status,
    List<SubtitleEntry>? entries,
    SubtitleEntry? partialEntry,
    bool clearPartialEntry = false,
    String? currentSessionUuid,
    DateTime? sessionStartTime,
    String? errorMessage,
  }) {
    return RecordingState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      partialEntry: clearPartialEntry ? null : (partialEntry ?? this.partialEntry),
      currentSessionUuid: currentSessionUuid ?? this.currentSessionUuid,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      errorMessage: errorMessage,
    );
  }
}

class RecordingNotifier extends StateNotifier<RecordingState> {
  final Ref _ref;
  StreamSubscription<SubtitleEntry>? _subtitleSubscription;

  RecordingNotifier(this._ref)
      : super(const RecordingState(
          status: RecordingStatus.idle,
          entries: [],
        ));

  Future<void> startRecording() async {
    final settings = _ref.read(settingsNotifierProvider);

    if (settings.apiKey.isEmpty) {
      state = state.copyWith(
        status: RecordingStatus.error,
        errorMessage: '请先在设置中配置 API Key',
      );
      return;
    }

    final recorder = _ref.read(audioRecorderServiceProvider);
    final hasPermission = await recorder.requestPermission();
    if (!hasPermission) {
      state = state.copyWith(
        status: RecordingStatus.error,
        errorMessage: '未获得麦克风权限，请在系统设置中允许访问麦克风',
      );
      return;
    }

    final uuid = const Uuid().v4();
    state = RecordingState(
      status: RecordingStatus.recording,
      entries: [],
      currentSessionUuid: uuid,
      sessionStartTime: DateTime.now(),
    );

    final pipeline = _ref.read(audioPipelineServiceProvider);
    _subtitleSubscription = pipeline.subtitleStream.listen((entry) {
      if (mounted) {
        if (entry.isPartial) {
          state = state.copyWith(partialEntry: entry);
        } else {
          state = state.copyWith(
            entries: [...state.entries, entry],
            clearPartialEntry: true,
          );
        }
      }
    });

    await pipeline.start(
      apiKey: settings.apiKey,
      sourceLanguage: settings.sourceLanguage,
      targetLanguage: settings.targetLanguage,
      audioSource: settings.audioSource,
    );
  }

  Future<void> stopRecording() async {
    if (state.status != RecordingStatus.recording) return;
    state = state.copyWith(status: RecordingStatus.stopping);

    final pipeline = _ref.read(audioPipelineServiceProvider);
    await pipeline.stop();

    await _subtitleSubscription?.cancel();
    _subtitleSubscription = null;

    if (state.entries.isNotEmpty && state.currentSessionUuid != null) {
      final settings = _ref.read(settingsNotifierProvider);
      final storage = _ref.read(storageServiceProvider);
      final duration =
          DateTime.now().difference(state.sessionStartTime!).inSeconds;

      await storage.saveSession(RecordingSession(
        uuid: state.currentSessionUuid!,
        createdAt: state.sessionStartTime!,
        durationSeconds: duration,
        sourceLanguage: settings.sourceLanguage,
        targetLanguage: settings.targetLanguage,
        entries: state.entries,
      ));

      _ref.invalidate(historyNotifierProvider);
    }

    state = state.copyWith(
      status: RecordingStatus.idle,
      clearPartialEntry: true,
    );
  }

  void clearError() {
    if (state.status == RecordingStatus.error) {
      state = state.copyWith(status: RecordingStatus.idle);
    }
  }

  @override
  void dispose() {
    _subtitleSubscription?.cancel();
    super.dispose();
  }
}

final recordingNotifierProvider =
    StateNotifierProvider<RecordingNotifier, RecordingState>((ref) {
  return RecordingNotifier(ref);
});
