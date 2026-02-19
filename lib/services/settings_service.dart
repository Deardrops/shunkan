import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class SettingsService {
  static const _keyApiKey = 'api_key';
  static const _keySourceLang = 'source_lang';
  static const _keyTargetLang = 'target_lang';
  static const _keyChunkDuration = 'chunk_duration';
  static const _keyAudioSource = 'audio_source';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final audioSourceIndex = prefs.getInt(_keyAudioSource) ?? 0;
    return AppSettings(
      apiKey: prefs.getString(_keyApiKey) ?? '',
      sourceLanguage: prefs.getString(_keySourceLang) ?? 'ja',
      targetLanguage: prefs.getString(_keyTargetLang) ?? 'zh',
      chunkDurationSeconds: prefs.getInt(_keyChunkDuration) ?? 4,
      audioSource: AudioSourceType.values[
          audioSourceIndex.clamp(0, AudioSourceType.values.length - 1)],
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, settings.apiKey);
    await prefs.setString(_keySourceLang, settings.sourceLanguage);
    await prefs.setString(_keyTargetLang, settings.targetLanguage);
    await prefs.setInt(_keyChunkDuration, settings.chunkDurationSeconds);
    await prefs.setInt(_keyAudioSource, settings.audioSource.index);
  }
}
