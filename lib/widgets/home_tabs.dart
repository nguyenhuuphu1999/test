import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';

class HomeTabs extends StatelessWidget {
  final int selectedIndex; // 0: Key, 1: Device, 2: History
  final int keyCount;
  final ValueChanged<int> onChanged;

  const HomeTabs({
    super.key,
    required this.selectedIndex,
    required this.keyCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: _TabItem(
              icon: Icons.person,
              label: 'Key($keyCount)',
              isActive: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: _TabItem(
              icon: Icons.work_outline,
              label: 'Device',
              isActive: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: _TabItem(
              icon: Icons.receipt_long_outlined,
              label: 'History',
              isActive: selectedIndex == 2,
              onTap: () => onChanged(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.PRIMARY_COLOR : Colors.black,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.PRIMARY_COLOR : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isActive ? AppColors.PRIMARY_COLOR : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
