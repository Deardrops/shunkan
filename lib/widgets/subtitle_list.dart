import 'package:flutter/material.dart';
import '../models/subtitle_entry.dart';
import 'subtitle_tile.dart';

class SubtitleList extends StatefulWidget {
  final List<SubtitleEntry> entries;
  final SubtitleEntry? partialEntry;

  const SubtitleList({super.key, required this.entries, this.partialEntry});

  @override
  State<SubtitleList> createState() => _SubtitleListState();
}

class _SubtitleListState extends State<SubtitleList> {
  final _scrollController = ScrollController();
  bool _userScrolledUp = false;

  @override
  void didUpdateWidget(SubtitleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final entryCountChanged = widget.entries.length != oldWidget.entries.length;
    final partialChanged = widget.partialEntry != oldWidget.partialEntry;
    if ((entryCountChanged || partialChanged) && !_userScrolledUp) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty && widget.partialEntry == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic_none, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              '点击麦克风按钮开始录音',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final itemCount =
        widget.entries.length + (widget.partialEntry != null ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (_scrollController.hasClients) {
            final atBottom = _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 40;
            setState(() => _userScrolledUp = !atBottom);
          }
        }
        return false;
      },
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index < widget.entries.length) {
                return SubtitleTile(entry: widget.entries[index]);
              }
              // Partial entry: dimmed to indicate it's still being spoken
              return Opacity(
                opacity: 0.5,
                child: SubtitleTile(entry: widget.partialEntry!),
              );
            },
          ),
          if (_userScrolledUp)
            Positioned(
              bottom: 8,
              right: 16,
              child: FloatingActionButton.small(
                onPressed: () {
                  setState(() => _userScrolledUp = false);
                  _scrollToBottom();
                },
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.arrow_downward),
              ),
            ),
        ],
      ),
    );
  }
}
