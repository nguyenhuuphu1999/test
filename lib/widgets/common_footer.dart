import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/smooth_main_layout.dart';
import 'package:vpncn2_app/screens/profile_screen.dart';

class CommonFooter extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTabChanged;
  final BuildContext? context;

  const CommonFooter({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Responsive.height(context, 2),
        left: Responsive.width(context, 10),
        right: Responsive.width(context, 6),
        bottom: Responsive.height(context, 2),
      ),
      decoration: BoxDecoration(color: AppColors.SURFACE_COLOR),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _FooterItem(
            imageAsset: AppAssets.homeIcon,
            label: AppStrings.home,
            isActive: activeIndex == 0,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context!,
                MaterialPageRoute(
                  builder: (context) => SmoothMainLayout(initialIndex: 0),
                ),
                (route) => false,
              );
            },
          ),
          _FooterItem(
            imageAsset: AppAssets.cloudIcon,
            label: '',
            isActive: activeIndex == 1,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context!,
                MaterialPageRoute(
                  builder: (context) => SmoothMainLayout(initialIndex: 1),
                ),
                (route) => false,
              );
            },
          ),
          _FooterItem(
            imageAsset: AppAssets.userIcon,
            label: '',
            isActive: activeIndex == 2,
            onTap: () {
              Navigator.push(
                context!,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  final String? imageAsset;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FooterItem({
    this.imageAsset,
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
          if (imageAsset != null)
            Image.asset(
              imageAsset!,
              width: Responsive.getFontSize(context, 34),
              height: Responsive.getFontSize(context, 34),
              color: isActive
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.TEXT_SECONDARY_COLOR,
            ),

          if (label.isNotEmpty) ...[
            SizedBox(height: Responsive.height(context, 0.5)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 10),
                  fontWeight: FontWeight.w400,
                  color: isActive
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.TEXT_SECONDARY_COLOR,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
