import 'package:flutter/material.dart';
import '../models/subtitle_entry.dart';

class SubtitleTile extends StatelessWidget {
  final SubtitleEntry entry;

  const SubtitleTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: cs.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.originalText.isNotEmpty)
              Text(
                entry.originalText,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (entry.originalText.isNotEmpty && entry.translatedText.isNotEmpty)
              const SizedBox(height: 6),
            if (entry.translatedText.isNotEmpty)
              Text(
                entry.translatedText,
                style: tt.bodyLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
