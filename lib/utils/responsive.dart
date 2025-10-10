import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 &&
        MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static double getFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.9;
    } else if (screenWidth > 414) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  static EdgeInsets getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    } else if (screenWidth > 414) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 6);
    }
    return const EdgeInsets.symmetric(horizontal: 24, vertical: 5);
  }

  // Specific padding for main layout to avoid status bar overlap
  static EdgeInsets getMainLayoutPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.fromLTRB(16, 4, 16, 8);
    } else if (screenWidth > 414) {
      return const EdgeInsets.fromLTRB(32, 6, 32, 12);
    }
    return const EdgeInsets.fromLTRB(24, 5, 24, 10);
  }
}
