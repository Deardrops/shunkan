import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../models/app_settings.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  /// Returns available input devices. Useful for letting the user pick a
  /// loopback / system-audio device on desktop platforms.
  Future<List<InputDevice>> listInputDevices() async {
    return _recorder.listInputDevices();
  }

  /// Starts streaming 16-bit LE mono PCM at 16 kHz.
  ///
  /// [source] controls whether microphone or system audio is captured:
  /// - [AudioSourceType.microphone]: default mic (all platforms).
  /// - [AudioSourceType.system]:
  ///   - Android: uses `AndroidAudioSource.remote_submix` (captures
  ///     internally routed audio without extra permissions on API 29+).
  ///   - Other platforms: enumerates audio input devices and selects the
  ///     first loopback / monitor / stereo-mix device found (e.g. "Stereo
  ///     Mix" on Windows, "BlackHole" on macOS). Falls back to the default
  ///     device if none is detected.
  Future<Stream<Uint8List>> startStream({
    AudioSourceType source = AudioSourceType.microphone,
  }) async {
    InputDevice? device;
    AndroidRecordConfig androidConfig = const AndroidRecordConfig();

    if (source == AudioSourceType.system) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        androidConfig = const AndroidRecordConfig(
          audioSource: AndroidAudioSource.remoteSubMix,
        );
      } else {
        device = await _findLoopbackDevice();
      }
    }

    final config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 16000,
      numChannels: 1,
      device: device,
      androidConfig: androidConfig,
    );
    return _recorder.startStream(config);
  }

  /// Stops an active stream recording.
  Future<void> stopStream() async {
    await _recorder.stop();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  /// Scans available input devices for a system-audio loopback device.
  /// Returns `null` if none is found (recorder will use the default device).
  Future<InputDevice?> _findLoopbackDevice() async {
    try {
      final devices = await _recorder.listInputDevices();
      const keywords = [
        'loopback',
        'stereo mix',
        'what u hear',
        'wave out mix',
        'monitor',
        'blackhole',
        'soundflower',
        'system audio',
      ];
      for (final d in devices) {
        final label = d.label.toLowerCase();
        if (keywords.any((k) => label.contains(k))) return d;
      }
    } catch (_) {}
    return null;
  }
}
