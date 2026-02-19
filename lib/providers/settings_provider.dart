import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import 'service_providers.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(AppSettings.defaults());

  Future<void> load() async {
    final service = _ref.read(settingsServiceProvider);
    state = await service.load();
  }

  Future<void> save(AppSettings settings) async {
    final service = _ref.read(settingsServiceProvider);
    await service.save(settings);
    state = settings;
  }

  void update({
    String? apiKey,
    String? sourceLanguage,
    String? targetLanguage,
    int? chunkDurationSeconds,
  }) {
    state = state.copyWith(
      apiKey: apiKey,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      chunkDurationSeconds: chunkDurationSeconds,
    );
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref);
});
