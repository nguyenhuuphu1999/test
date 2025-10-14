import 'package:flutter/material.dart';

class ActivityFeedList extends StatelessWidget {
  const ActivityFeedList({super.key});

  List<_ActivityFeedItem> _seedItems() {
    return [
      _ActivityFeedItem(
        time: DateTime(2025, 10, 1, 19, 0, 35),
        message: 'Buy New key 150-manhnguyen-01',
      ),
      _ActivityFeedItem(
        time: DateTime(2025, 10, 1, 19, 0, 35),
        message: 'key 150-manhnguyen-01 has expired',
      ),
      _ActivityFeedItem(
        time: DateTime(2025, 10, 1, 19, 0, 35),
        message: 'key 150-manhnguyen-01 has over limit bandwidth 150GB',
      ),
      _ActivityFeedItem(
        time: DateTime(2025, 10, 1, 19, 0, 35),
        message: 'Router VN_manh 01 has added/removed successful',
      ),
      _ActivityFeedItem(
        time: DateTime(2025, 10, 1, 19, 0, 35),
        message: 'Router VN_manh 01 has Online/Offline',
      ),
      _ActivityFeedItem(
        time: DateTime(2025, 10, 1, 19, 0, 35),
        message: 'You have deposited 16 RMB via WeChat successfully',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _seedItems();
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final e = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDateTime(e.time),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9AA6B2),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                e.message,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1B2430),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }
}

class _ActivityFeedItem {
  final DateTime time;
  final String message;

  const _ActivityFeedItem({required this.time, required this.message});
}
