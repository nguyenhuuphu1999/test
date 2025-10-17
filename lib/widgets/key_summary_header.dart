import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';

class KeySummaryHeader extends StatelessWidget {
  final String keyName;
  final String expireText;
  final String usageText;
  final VoidCallback? onActionPressed;

  const KeySummaryHeader({
    super.key,
    required this.keyName,
    required this.expireText,
    required this.usageText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                keyName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                expireText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                usageText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Trailing mini action / indicator column (placeholder)
        Column(
          children: [
            InkWell(
              onTap: onActionPressed,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.SURFACE_LIGHT_COLOR),
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 14,
                  color: AppColors.TEXT_SECONDARY_COLOR,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 2,
              height: 8,
              color: AppColors.SURFACE_LIGHT_COLOR,
            ),
            const SizedBox(height: 8),
            Container(
              width: 2,
              height: 8,
              color: AppColors.SURFACE_LIGHT_COLOR,
            ),
          ],
        ),
      ],
    );
  }
}
