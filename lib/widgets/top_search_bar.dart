import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/widgets/common_search_field.dart';

class TopSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightIconPressed;
  // When provided, this widget will be shown in the center instead of the search field
  final Widget? centerChild;

  const TopSearchBar({
    super.key,
    this.onChanged,
    this.onLeftIconPressed,
    this.onRightIconPressed,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLeftIconPressed,
          child: Icon(
            Icons.apps,
            color: AppColors.PRIMARY_DARK_COLOR,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: centerChild != null
              ? Center(child: centerChild)
              : CommonSearchField(
                  hintText: AppStrings.searchYourKey,
                  onChanged: onChanged,
                  backgroundColor: AppColors.SURFACE_LIGHT_COLOR,
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.TEXT_HINT_COLOR,
                    size: 18,
                  ),
                ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onRightIconPressed,
          child: Icon(
            Icons.diamond_outlined,
            color: AppColors.PRIMARY_DARK_COLOR,
            size: 22,
          ),
        ),
      ],
    );
  }
}
