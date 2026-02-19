import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'daos/sessions_dao.dart';
import 'daos/entries_dao.dart';

part 'app_database.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  TextColumn get sourceLanguage => text()();
  TextColumn get targetLanguage => text()();
  TextColumn get title => text().nullable()();
}

class SubtitleEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionUuid => text()();
  TextColumn get originalText => text()();
  TextColumn get translatedText => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get chunkIndex => integer()();
}

@DriftDatabase(tables: [Sessions, SubtitleEntries], daos: [SessionsDao, EntriesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openDatabase() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'shunkan.db'));
      return NativeDatabase(file);
    });
  }
}
