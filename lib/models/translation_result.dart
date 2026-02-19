class TranslationResult {
  final String originalText;
  final String translationText;
  final bool isError;
  final String? errorMessage;
  final bool isPartial;

  const TranslationResult({
    required this.originalText,
    required this.translationText,
    required this.isError,
    this.errorMessage,
    this.isPartial = false,
  });

  factory TranslationResult.error(String message) => TranslationResult(
        originalText: '',
        translationText: '',
        isError: true,
        errorMessage: message,
      );
}
