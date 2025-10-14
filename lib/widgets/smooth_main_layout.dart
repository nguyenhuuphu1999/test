import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/home_content.dart';
import 'package:vpncn2_app/widgets/devices_content.dart';
import 'package:vpncn2_app/widgets/profile_content.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';

class SmoothMainLayout extends StatefulWidget {
  final int initialIndex;
  final int homeInitialTabIndex;

  const SmoothMainLayout({
    super.key,
    this.initialIndex = 0,
    this.homeInitialTabIndex = 0,
  });

  @override
  State<SmoothMainLayout> createState() => _SmoothMainLayoutState();
}

class _SmoothMainLayoutState extends State<SmoothMainLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      body: Container(
        padding: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              16, // Status bar + extra padding
          left: Responsive.width(context, 6),
          right: Responsive.width(context, 6),
          bottom: Responsive.height(context, 1.2),
        ),
        child: Column(
          children: [
            // Body content - sử dụng IndexedStack để chuyển mượt mà
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  HomeContent(initialTabIndex: widget.homeInitialTabIndex),
                  const DevicesContent(),
                  const ProfileContent(), // Profile content with pull-to-refresh
                ],
              ),
            ),
          ],
        ),
      ),
      // Common Footer
      bottomNavigationBar: CommonFooter(
        activeIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Removed persistent header and its related widgets at user's request.
