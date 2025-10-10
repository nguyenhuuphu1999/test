import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class CommonSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CommonSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.hintStyle,
  });

  // Factory constructor for home search
  factory CommonSearchField.home({
    Key? key,
    ValueChanged<String>? onChanged,
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return CommonSearchField(
      key: key,
      hintText: AppStrings.searchYourKey,
      onChanged: onChanged,
      controller: controller,
      enabled: enabled,
      backgroundColor: AppColors.surface,
    );
  }

  // Factory constructor for devices search
  factory CommonSearchField.devices({
    Key? key,
    ValueChanged<String>? onChanged,
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return CommonSearchField(
      key: key,
      hintText: AppStrings.searchYourDevice,
      onChanged: onChanged,
      controller: controller,
      enabled: enabled,
      backgroundColor: AppColors.surfaceLight,
      width: 87, // 87% of screen width
    );
  }

  // Factory constructor for general search with custom hint
  factory CommonSearchField.custom({
    Key? key,
    required String hintText,
    ValueChanged<String>? onChanged,
    TextEditingController? controller,
    bool enabled = true,
    Color? backgroundColor,
    double? width,
  }) {
    return CommonSearchField(
      key: key,
      hintText: hintText,
      onChanged: onChanged,
      controller: controller,
      enabled: enabled,
      backgroundColor: backgroundColor ?? AppColors.surface,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? Responsive.width(context, width!) : null,
      padding: padding ?? EdgeInsets.all(Responsive.width(context, 4)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          // Prefix Icon (default: search icon)
          prefixIcon ??
              Icon(
                Icons.search,
                color: AppColors.textHint,
                size: Responsive.getFontSize(context, 20),
              ),

          SizedBox(width: Responsive.width(context, 3)),

          // Text Field
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              enabled: enabled,
              style:
                  textStyle ??
                  TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: Responsive.getFontSize(context, 15),
                    fontFamily: 'Poppins',
                  ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    hintStyle ??
                    TextStyle(
                      color: AppColors.textHint,
                      fontSize: Responsive.getFontSize(context, 15),
                      fontFamily: 'Poppins',
                    ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),

          // Suffix Icon (optional)
          if (suffixIcon != null) ...[
            SizedBox(width: Responsive.width(context, 2)),
            suffixIcon!,
          ],
        ],
      ),
    );
  }
}
