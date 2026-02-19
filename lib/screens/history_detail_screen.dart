import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recording_session.dart';
import '../models/app_settings.dart';
import '../widgets/subtitle_tile.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '$m分$s秒' : '$s秒';
  }

  String _buildFullText(RecordingSession session) {
    return session.entries.map((e) {
      final lines = <String>[];
      if (e.originalText.isNotEmpty) lines.add(e.originalText);
      if (e.translatedText.isNotEmpty) lines.add(e.translatedText);
      return lines.join('\n');
    }).join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    final session =
        ModalRoute.of(context)!.settings.arguments as RecordingSession;

    final langPair = LanguagePair.available.firstWhere(
      (p) =>
          p.sourceCode == session.sourceLanguage &&
          p.targetCode == session.targetLanguage,
      orElse: () => LanguagePair(
        sourceCode: session.sourceLanguage,
        targetCode: session.targetLanguage,
        label:
            '${session.sourceLanguage.toUpperCase()} → ${session.targetLanguage.toUpperCase()}',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(langPair.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: '复制全文',
            onPressed: () {
              Clipboard.setData(
                  ClipboardData(text: _buildFullText(session)));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制到剪贴板')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(session.durationSeconds),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.record_voice_over_outlined,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${session.entries.length} 条记录',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: session.entries.isEmpty
                ? const Center(
                    child: Text('无内容',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: session.entries.length,
                    itemBuilder: (context, index) =>
                        SubtitleTile(entry: session.entries[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
