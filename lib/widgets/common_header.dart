import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;

  const CommonHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      elevation: 0,
      leading: showBackButton
          ? GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.TEXT_PRIMARY_COLOR,
                size: Responsive.getFontSize(context, 20),
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.getFontSize(context, 18),
          fontWeight: FontWeight.w700,
          color: AppColors.TEXT_PRIMARY_COLOR,
        ),
      ),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
