import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../services/settings_service.dart';
import '../services/audio_recorder_service.dart';
import '../services/translation_service.dart';
import '../services/audio_pipeline_service.dart';
import '../services/storage_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

final audioRecorderServiceProvider = Provider<AudioRecorderService>((ref) {
  final service = AudioRecorderService();
  ref.onDispose(() => service.dispose());
  return service;
});

final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StorageService(db);
});

final audioPipelineServiceProvider = Provider<AudioPipelineService>((ref) {
  final recorder = ref.watch(audioRecorderServiceProvider);
  final translation = ref.watch(translationServiceProvider);
  final service = AudioPipelineService(recorder, translation);
  ref.onDispose(() => service.dispose());
  return service;
});
