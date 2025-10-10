import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/key_item_tile.dart';
import 'package:vpncn2_app/widgets/common_search_field.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Field
        CommonSearchField.home(onChanged: (value) {}),

        const SizedBox(height: 24),

        // Key Items
        Expanded(
          child: ListView.builder(
            itemCount: _keyItems.length,
            itemBuilder: (context, index) {
              final keyItem = _keyItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
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

final List<_KeyItem> _keyItems = [
  _KeyItem(name: 'Key-name-01', quota: '50GB', remainDays: 30),
  _KeyItem(name: 'Key-name-02', quota: '100GB', remainDays: 15),
  _KeyItem(name: 'Key-name-03', quota: '200GB', remainDays: 7),
];
