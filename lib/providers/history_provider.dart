import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recording_session.dart';
import 'service_providers.dart';

class HistoryNotifier extends StateNotifier<AsyncValue<List<RecordingSession>>> {
  final Ref _ref;

  HistoryNotifier(this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final storage = _ref.read(storageServiceProvider);
      final sessions = await storage.getAllSessions();
      if (!mounted) return;
      state = AsyncValue.data(sessions);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _load();

  Future<void> deleteSession(String uuid) async {
    final storage = _ref.read(storageServiceProvider);
    await storage.deleteSession(uuid);
    await _load();
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<RecordingSession>>>(
  (ref) => HistoryNotifier(ref),
);
