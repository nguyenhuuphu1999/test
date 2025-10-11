import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // Track expansion state for each FAQ item
  final Map<int, bool> _expansionStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: CommonHeader(
        title: AppStrings.faq,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Responsive.width(context, 4)),
              child: Column(
                children: [
                  // Search field
                  _buildSearchField(),

                  SizedBox(height: Responsive.height(context, 3)),

                  // FAQ items
                  Expanded(
                    child: ListView(
                      children: [
                        _buildFaqItem(
                          0,
                          AppStrings.faqInstallIos,
                          "To install Outline on iOS:\n\n1. Open App Store\n2. Search for 'Outline'\n3. Tap 'Get' to download\n4. Open the app and follow setup instructions\n5. Enter your server details when prompted",
                        ),
                        _buildFaqItem(
                          1,
                          AppStrings.faqInstallAndroid,
                          "To install Outline for Android:\n\n1. Open Google Play Store\n2. Search for 'Outline'\n3. Tap 'Install' to download\n4. Launch the app after installation\n5. Configure your connection settings\n6. Connect to your VPN server",
                        ),
                        _buildFaqItem(
                          2,
                          AppStrings.faqCannotAccessWindows,
                          "If you can't access on Windows:\n\n1. Check your internet connection\n2. Verify server credentials\n3. Disable Windows Firewall temporarily\n4. Run as Administrator\n5. Update Outline client to latest version\n6. Contact support if issues persist",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer
          CommonFooter(
            onTabChanged: (index) {
              // This won't be called since we're using context navigation
            },
            context: context,
            activeIndex: -1, // No active tab for FAQ screen
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(context, 4),
        vertical: Responsive.height(context, 1.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.SURFACE_COLOR,
        borderRadius: BorderRadius.circular(Responsive.width(context, 3)),
        border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 16, color: AppColors.SURFACE_COLOR),
          ),
          SizedBox(width: Responsive.width(context, 3)),
          Expanded(
            child: Text(
              AppStrings.faqEnterKeyword,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 15),
                fontWeight: FontWeight.w400,
                color: AppColors.TEXT_SECONDARY_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index, String question, String answer) {
    final isExpanded = _expansionStates[index] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: Responsive.height(context, 1.5)),
      decoration: BoxDecoration(
        color: AppColors.SURFACE_COLOR,
        borderRadius: BorderRadius.circular(Responsive.width(context, 2)),
        border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
      ),
      child: Column(
        children: [
          // Question header
          InkWell(
            onTap: () => _toggleExpansion(index),
            borderRadius: BorderRadius.circular(Responsive.width(context, 2)),
            child: Padding(
              padding: EdgeInsets.all(Responsive.width(context, 4)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.TEXT_PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.width(context, 2)),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Image.asset(
                      AppAssets.faqArrow,
                      width: 8,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Answer content (expandable)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      Responsive.width(context, 4),
                      0,
                      Responsive.width(context, 4),
                      Responsive.width(context, 4),
                    ),
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.TEXT_SECONDARY_COLOR,
                        height: 1.5,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expansionStates[index] = !(_expansionStates[index] ?? false);
    });
  }
}
