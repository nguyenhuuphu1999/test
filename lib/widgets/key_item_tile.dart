import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';

class KeyItemTile extends StatelessWidget {
  final String name;
  final String quotaText;
  final int? remainDays;
  final bool expired;
  final VoidCallback? onConnect;

  const KeyItemTile({
    super.key,
    required this.name,
    required this.quotaText,
    this.remainDays,
    this.expired = false,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final Color dotColor = expired ? const Color(0xFFFA3D3D) : const Color(0xFF2F6BFF);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Row(
        children: <Widget>[
          Container(width: 12, height: 12, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                    Text(quotaText, style: const TextStyle(fontSize: 12, color: Color(0xFF394452)))
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  expired ? t.expired : t.remainDays(remainDays?.toString() ?? '0'),
                  style: TextStyle(fontSize: 11, color: expired ? const Color(0xFFFA3D3D) : const Color(0xFF9AA6B2)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(onPressed: onConnect, child: Text(t.connect)),
        ],
      ),
    );
  }
}



