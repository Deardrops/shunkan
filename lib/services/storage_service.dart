import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/recording_session.dart' as model;
import '../models/subtitle_entry.dart' as model;

class StorageService {
  final AppDatabase _db;

  StorageService(this._db);

  Future<List<model.RecordingSession>> getAllSessions() async {
    final rows = await _db.sessionsDao.getAllSessions();
    final sessions = <model.RecordingSession>[];

    for (final row in rows) {
      final entries = await _getEntries(row.uuid);
      sessions.add(model.RecordingSession(
        uuid: row.uuid,
        createdAt: row.createdAt,
        durationSeconds: row.durationSeconds,
        sourceLanguage: row.sourceLanguage,
        targetLanguage: row.targetLanguage,
        title: row.title,
        entries: entries,
      ));
    }

    return sessions;
  }

  Future<model.RecordingSession?> getSession(String uuid) async {
    final row = await _db.sessionsDao.getSessionByUuid(uuid);
    if (row == null) return null;
    final entries = await _getEntries(uuid);
    return model.RecordingSession(
      uuid: row.uuid,
      createdAt: row.createdAt,
      durationSeconds: row.durationSeconds,
      sourceLanguage: row.sourceLanguage,
      targetLanguage: row.targetLanguage,
      title: row.title,
      entries: entries,
    );
  }

  Future<void> saveSession(model.RecordingSession session) async {
    await _db.sessionsDao.insertSession(SessionsCompanion(
      uuid: Value(session.uuid),
      createdAt: Value(session.createdAt),
      durationSeconds: Value(session.durationSeconds),
      sourceLanguage: Value(session.sourceLanguage),
      targetLanguage: Value(session.targetLanguage),
      title: Value(session.title),
    ));

    for (final entry in session.entries) {
      await _db.entriesDao.insertEntry(SubtitleEntriesCompanion(
        sessionUuid: Value(session.uuid),
        originalText: Value(entry.originalText),
        translatedText: Value(entry.translatedText),
        timestamp: Value(entry.timestamp),
        chunkIndex: Value(entry.chunkIndex),
      ));
    }
  }

  Future<void> deleteSession(String uuid) async {
    await _db.entriesDao.deleteEntriesForSession(uuid);
    await _db.sessionsDao.deleteSession(uuid);
  }

  Future<List<model.SubtitleEntry>> _getEntries(String sessionUuid) async {
    final rows = await _db.entriesDao.getEntriesForSession(sessionUuid);
    return rows
        .map((r) => model.SubtitleEntry(
              originalText: r.originalText,
              translatedText: r.translatedText,
              timestamp: r.timestamp,
              chunkIndex: r.chunkIndex,
            ))
        .toList();
  }
}
