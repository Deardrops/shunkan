enum AudioSourceType { microphone, system }

class AppSettings {
  final String apiKey;
  final String sourceLanguage;
  final String targetLanguage;
  final AudioSourceType audioSource;
  // kept for shared-prefs compat; not surfaced in UI
  final int chunkDurationSeconds;

  const AppSettings({
    required this.apiKey,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.audioSource = AudioSourceType.microphone,
    this.chunkDurationSeconds = 4,
  });

  static AppSettings defaults() => const AppSettings(
        apiKey: '',
        sourceLanguage: 'ja',
        targetLanguage: 'zh',
      );

  AppSettings copyWith({
    String? apiKey,
    String? sourceLanguage,
    String? targetLanguage,
    AudioSourceType? audioSource,
    int? chunkDurationSeconds,
  }) {
    return AppSettings(
      apiKey: apiKey ?? this.apiKey,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      audioSource: audioSource ?? this.audioSource,
      chunkDurationSeconds: chunkDurationSeconds ?? this.chunkDurationSeconds,
    );
  }
}

class LanguagePair {
  final String sourceCode;
  final String targetCode;
  final String label;

  const LanguagePair({
    required this.sourceCode,
    required this.targetCode,
    required this.label,
  });

  static const List<LanguagePair> available = [
    LanguagePair(sourceCode: 'ja', targetCode: 'zh', label: '日語 → 中文'),
    LanguagePair(sourceCode: 'en', targetCode: 'zh', label: 'English → 中文'),
    LanguagePair(sourceCode: 'ko', targetCode: 'zh', label: '한국어 → 中文'),
    LanguagePair(sourceCode: 'zh', targetCode: 'en', label: '中文 → English'),
    LanguagePair(sourceCode: 'ja', targetCode: 'en', label: '日語 → English'),
  ];
}
