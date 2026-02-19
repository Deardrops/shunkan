import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recording_session.dart';

class SessionCard extends StatelessWidget {
  final RecordingSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '$m分$s秒' : '$s秒';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('yyyy年MM月dd日 HH:mm').format(session.createdAt);
    final langLabel =
        '${session.sourceLanguage.toUpperCase()} → ${session.targetLanguage.toUpperCase()}';
    final preview = session.entries.isNotEmpty
        ? session.entries.first.translatedText
        : '（无内容）';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          dateStr,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(langLabel,
                      style: const TextStyle(fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(session.durationSeconds),
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: onDelete,
          tooltip: '删除',
        ),
      ),
    );
  }
}
