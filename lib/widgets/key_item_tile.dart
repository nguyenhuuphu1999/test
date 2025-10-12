import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/expandable_key_item.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;

class KeyItemTile extends StatelessWidget {
  final String name;
  final String quotaText;
  final int? remainDays;
  final bool expired;
  final VoidCallback? onConnect;
  final Function(String code, String country)? onServerLocationChanged;
  final KeyEntity.Key? keyData; // Add key data for VPN connection

  const KeyItemTile({
    super.key,
    required this.name,
    required this.quotaText,
    this.remainDays,
    this.expired = false,
    this.onConnect,
    this.onServerLocationChanged,
    this.keyData,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableKeyItem(
      name: name,
      quotaText: quotaText,
      remainDays: remainDays,
      expired: expired,
      onConnect: onConnect,
      onServerLocationChanged: onServerLocationChanged,
      keyData: keyData,
    );
  }
}
