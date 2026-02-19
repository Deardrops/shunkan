import 'subtitle_entry.dart';

class RecordingSession {
  final String uuid;
  final DateTime createdAt;
  final int durationSeconds;
  final String sourceLanguage;
  final String targetLanguage;
  final String? title;
  final List<SubtitleEntry> entries;

  const RecordingSession({
    required this.uuid,
    required this.createdAt,
    required this.durationSeconds,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.title,
    required this.entries,
  });
}
