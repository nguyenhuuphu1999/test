import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/key_item_tile.dart';
import 'package:vpncn2_app/widgets/common_search_field.dart';
import 'package:vpncn2_app/services/user_service.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<_KeyItem> _keyItems = [
    _KeyItem(name: 'Key-name-01', quota: '50GB', remainDays: 30),
    _KeyItem(name: 'Key-name-02', quota: '100GB', remainDays: 15),
    _KeyItem(name: 'Key-name-03', quota: '200GB', remainDays: 7),
  ];

  Future<void> _onRefresh() async {
    // Refresh user data
    await UserService.getCurrentUser();

    // Simulate refreshing key items data
    await Future.delayed(const Duration(seconds: 1));

    // You can add API calls here to refresh key items
    // For now, we'll just show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home screen refreshed!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Field
        CommonSearchField.home(onChanged: (value) {}),

        const SizedBox(height: 24),

        // Key Items with Pull-to-Refresh
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
              itemCount: _keyItems.length,
              itemBuilder: (context, index) {
                final keyItem = _keyItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: KeyItemTile(
                    name: keyItem.name,
                    quotaText: keyItem.quota,
                    remainDays: keyItem.remainDays,
                    onServerLocationChanged: (code, country) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Server location changed to $country'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _KeyItem {
  final String name;
  final String quota;
  final int remainDays;

  _KeyItem({required this.name, required this.quota, required this.remainDays});
}
