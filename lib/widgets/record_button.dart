import 'package:flutter/material.dart';
import '../providers/recording_provider.dart';

class RecordButton extends StatefulWidget {
  final RecordingStatus status;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const RecordButton({
    super.key,
    required this.status,
    required this.onStart,
    required this.onStop,
  });

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.75).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.45, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(RecordButton old) {
    super.didUpdateWidget(old);
    if (old.status != widget.status) _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.status == RecordingStatus.recording) {
      _pulseController.repeat();
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isRecording = widget.status == RecordingStatus.recording;
    final isStopping = widget.status == RecordingStatus.stopping;
    final isDisabled = isStopping;

    final buttonColor = isDisabled
        ? cs.surfaceContainerHighest
        : isRecording
            ? cs.error
            : cs.primary;

    final iconColor = isDisabled
        ? cs.onSurfaceVariant
        : isRecording
            ? cs.onError
            : cs.onPrimary;

    return GestureDetector(
      onTap: isDisabled ? null : (isRecording ? widget.onStop : widget.onStart),
      child: SizedBox(
        width: 88,
        height: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing ring (visible only while recording)
            if (isRecording)
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) => Transform.scale(
                  scale: _pulseScale.value,
                  child: Opacity(
                    opacity: _pulseOpacity.value,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.error,
                      ),
                    ),
                  ),
                ),
              ),
            // Button body — shrinks slightly while recording
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isRecording ? 64 : 72,
              height: isRecording ? 64 : 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
                boxShadow: isDisabled
                    ? []
                    : [
                        BoxShadow(
                          color: buttonColor.withValues(alpha: 0.35),
                          blurRadius: isRecording ? 20 : 10,
                          spreadRadius: isRecording ? 4 : 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isStopping
                      ? Icons.hourglass_bottom_rounded
                      : isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_rounded,
                  key: ValueKey(widget.status),
                  color: iconColor,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
