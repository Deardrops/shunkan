import 'package:drift/drift.dart';
import '../app_database.dart';

part 'entries_dao.g.dart';

@DriftAccessor(tables: [SubtitleEntries])
class EntriesDao extends DatabaseAccessor<AppDatabase> with _$EntriesDaoMixin {
  EntriesDao(super.db);

  Future<List<SubtitleEntry>> getEntriesForSession(String sessionUuid) =>
      (select(subtitleEntries)
            ..where((e) => e.sessionUuid.equals(sessionUuid))
            ..orderBy([(e) => OrderingTerm.asc(e.chunkIndex)]))
          .get();

  Future<int> insertEntry(SubtitleEntriesCompanion companion) =>
      into(subtitleEntries).insert(companion);

  Future<int> deleteEntriesForSession(String sessionUuid) =>
      (delete(subtitleEntries)
            ..where((e) => e.sessionUuid.equals(sessionUuid)))
          .go();
}
