class SubtitleEntry {
  final String originalText;
  final String translatedText;
  final DateTime timestamp;
  final int chunkIndex;
  final bool isPartial;

  const SubtitleEntry({
    required this.originalText,
    required this.translatedText,
    required this.timestamp,
    required this.chunkIndex,
    this.isPartial = false,
  });
}
