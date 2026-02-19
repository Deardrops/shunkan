import 'package:drift/drift.dart';
import '../app_database.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase> with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Future<List<Session>> getAllSessions() =>
      (select(sessions)..orderBy([(s) => OrderingTerm.desc(s.createdAt)])).get();

  Future<Session?> getSessionByUuid(String uuid) =>
      (select(sessions)..where((s) => s.uuid.equals(uuid))).getSingleOrNull();

  Future<int> insertSession(SessionsCompanion companion) =>
      into(sessions).insert(companion);

  Future<bool> updateSessionDuration(String uuid, int durationSeconds) async {
    final rows = await (update(sessions)..where((s) => s.uuid.equals(uuid)))
        .write(SessionsCompanion(durationSeconds: Value(durationSeconds)));
    return rows > 0;
  }

  Future<int> deleteSession(String uuid) =>
      (delete(sessions)..where((s) => s.uuid.equals(uuid))).go();
}
