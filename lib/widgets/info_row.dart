import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_assets.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool hasCopyButton;
  final bool hasChangeButton;
  final VoidCallback? onCopy;
  final VoidCallback? onChange;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.hasCopyButton = false,
    this.hasChangeButton = false,
    this.onCopy,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF394452),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1B2430),
              ),
            ),
          ),
          if (hasChangeButton && onChange != null)
            GestureDetector(
              onTap: onChange,
              child: Image.asset(
                AppAssets.arrowsIcon,
                width: 16,
                height: 16,
                color: const Color(0xFF4894FE),
              ),
            ),
          if (hasCopyButton && onCopy != null)
            GestureDetector(
              onTap: onCopy,
              child: const Icon(Icons.copy, size: 16, color: Color(0xFF4894FE)),
            ),
        ],
      ),
    );
  }
}
