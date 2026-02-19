import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../providers/recording_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/record_button.dart';
import '../widgets/subtitle_list.dart';
import '../widgets/language_pair_selector.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(recordingNotifierProvider.notifier);

    ref.listen<RecordingState>(recordingNotifierProvider, (_, s) {
      if (s.status == RecordingStatus.error && s.errorMessage != null) {
        final cs = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.errorMessage!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: cs.errorContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: '知道了',
              textColor: cs.onErrorContainer,
              onPressed: notifier.clearError,
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('瞬間'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: '历史记录',
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: '设置',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SubtitleList(
              entries: state.entries,
              partialEntry: state.partialEntry,
            ),
          ),
          _BottomPanel(
            state: state,
            settings: settings,
            onStart: notifier.startRecording,
            onStop: notifier.stopRecording,
            onLanguageChanged: (src, tgt) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .save(settings.copyWith(sourceLanguage: src, targetLanguage: tgt));
            },
            onSourceChanged: (source) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .save(settings.copyWith(audioSource: source));
            },
          ),
        ],
      ),
    );
  }
}

// ── Bottom panel ──────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  final RecordingState state;
  final AppSettings settings;
  final Future<void> Function() onStart;
  final Future<void> Function() onStop;
  final void Function(String, String) onLanguageChanged;
  final void Function(AudioSourceType) onSourceChanged;

  const _BottomPanel({
    required this.state,
    required this.settings,
    required this.onStart,
    required this.onStop,
    required this.onLanguageChanged,
    required this.onSourceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isRecording = state.status == RecordingStatus.recording;
    final isStopping = state.status == RecordingStatus.stopping;
    final controlsEnabled = !isRecording && !isStopping;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer chip - slides in when recording starts
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isRecording
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _RecordingTimer(isRecording: isRecording),
                  )
                : const SizedBox.shrink(),
          ),
          // Language + audio source controls
          Row(
            children: [
              Expanded(
                child: LanguagePairSelector(
                  sourceLanguage: settings.sourceLanguage,
                  targetLanguage: settings.targetLanguage,
                  onChanged: onLanguageChanged,
                  enabled: controlsEnabled,
                ),
              ),
              const SizedBox(width: 10),
              _AudioSourceToggle(
                value: settings.audioSource,
                enabled: controlsEnabled,
                onChanged: onSourceChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Record button
          RecordButton(
            status: state.status,
            onStart: onStart,
            onStop: onStop,
          ),
        ],
      ),
    );
  }
}

// ── Recording timer chip ──────────────────────────────────────────────────────

class _RecordingTimer extends StatefulWidget {
  final bool isRecording;

  const _RecordingTimer({required this.isRecording});

  @override
  State<_RecordingTimer> createState() => _RecordingTimerState();
}

class _RecordingTimerState extends State<_RecordingTimer> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isRecording) _startTimer();
  }

  @override
  void didUpdateWidget(_RecordingTimer old) {
    super.didUpdateWidget(old);
    if (widget.isRecording && !old.isRecording) {
      _seconds = 0;
      _startTimer();
    } else if (!widget.isRecording && old.isRecording) {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _format() {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.fiber_manual_record_rounded, color: cs.error, size: 12),
      label: Text(
        _format(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: cs.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
      backgroundColor: cs.errorContainer,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ── Audio source toggle ───────────────────────────────────────────────────────

class _AudioSourceToggle extends StatelessWidget {
  final AudioSourceType value;
  final bool enabled;
  final ValueChanged<AudioSourceType> onChanged;

  const _AudioSourceToggle({
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AudioSourceType>(
      showSelectedIcon: false,
      selected: {value},
      onSelectionChanged: enabled ? (set) => onChanged(set.first) : null,
      style: SegmentedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        minimumSize: const Size(0, 40),
      ),
      segments: const [
        ButtonSegment(
          value: AudioSourceType.microphone,
          icon: Icon(Icons.mic_rounded, size: 18),
          tooltip: '麦克风',
        ),
        ButtonSegment(
          value: AudioSourceType.system,
          icon: Icon(Icons.speaker_rounded, size: 18),
          tooltip: '系统音频',
        ),
      ],
    );
  }
}
