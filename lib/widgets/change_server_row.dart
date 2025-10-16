import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';

class ChangeServerRow extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChangeServerRow({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // Globe-like composed icon using simple shapes (as per design)
              SizedBox(
                width: 24,
                height: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.TEXT_SECONDARY_COLOR,
                          width: 1.2,
                        ),
                      ),
                    ),
                    // vertical meridians
                    Container(
                      width: 1.5,
                      height: 18,
                      color: AppColors.TEXT_SECONDARY_COLOR,
                    ),
                    Positioned(
                      right: 4,
                      child: Container(
                        width: 1.5,
                        height: 18,
                        color: AppColors.TEXT_SECONDARY_COLOR,
                      ),
                    ),
                    // horizontal parallels
                    Positioned(
                      top: 6,
                      child: Container(
                        width: 18,
                        height: 1.5,
                        color: AppColors.TEXT_SECONDARY_COLOR,
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      child: Container(
                        width: 18,
                        height: 1.5,
                        color: AppColors.TEXT_SECONDARY_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Change Server',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              // Chevron icon built from strokes (as per design)
              Icon(Icons.chevron_right, color: AppColors.TEXT_SECONDARY_COLOR),
            ],
          ),
        ),
      ),
    );
  }
}
