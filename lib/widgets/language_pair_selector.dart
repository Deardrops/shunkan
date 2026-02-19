import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class LanguagePairSelector extends StatelessWidget {
  final String sourceLanguage;
  final String targetLanguage;
  final void Function(String source, String target) onChanged;
  final bool enabled;

  const LanguagePairSelector({
    super.key,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final current = LanguagePair.available.firstWhere(
      (p) => p.sourceCode == sourceLanguage && p.targetCode == targetLanguage,
      orElse: () => LanguagePair.available.first,
    );

    final chipColor =
        enabled ? cs.secondaryContainer : cs.surfaceContainerHighest;
    final textColor =
        enabled ? cs.onSecondaryContainer : cs.onSurfaceVariant;

    return PopupMenuButton<LanguagePair>(
      enabled: enabled,
      onSelected: (pair) => onChanged(pair.sourceCode, pair.targetCode),
      itemBuilder: (_) => LanguagePair.available
          .map(
            (p) => PopupMenuItem<LanguagePair>(
              value: p,
              child: Text(p.label),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current.label,
              style: tt.labelLarge?.copyWith(color: textColor),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down_rounded, size: 20, color: textColor),
          ],
        ),
      ),
    );
  }
}
