import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';
import 'package:vpncn2_app/widgets/plan_card.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: CommonHeader(
        title: AppStrings.subscribe,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 5),
              ),
              child: Column(
                children: [
                  SizedBox(height: Responsive.height(context, 2)),

                  // Decorative image
                  // Center(
                  //   child: Image.asset(
                  //     AppAssets.ellipse757,
                  //     width: Responsive.width(context, 11.25), // 45px
                  //     height: Responsive.width(context, 11.25),
                  //   ),
                  // ),
                  // SizedBox(height: Responsive.height(context, 3)),

                  // Main title
                  // Text(
                  //   AppStrings.getPlanTitle,
                  //   style: TextStyle(
                  //     fontSize: Responsive.getFontSize(context, 28),
                  //     fontWeight: FontWeight.w400,
                  //     color: AppColors.TEXT_PRIMARY_COLOR,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: Responsive.height(context, 4)),

                  // Responsive Plan Cards Grid
                  _buildResponsivePlanGrid(context),

                  SizedBox(height: Responsive.height(context, 4)),

                  // Additional information
                  // Text(
                  //   AppStrings.afterPurchaseInfo,
                  //   style: TextStyle(
                  //     fontSize: Responsive.getFontSize(context, 14),
                  //     fontWeight: FontWeight.w400,
                  //     color: AppColors.ERROR_COLOR,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: Responsive.height(context, 3)),
                ],
              ),
            ),
          ),

          // Common Footer
          CommonFooter(
            activeIndex: -1, // No active tab on subscribe screen
            context: context,
            onTabChanged: (index) {
              // This won't be called since we're using context navigation
            },
          ),
        ],
      ),
    );
  }

  void _handleBuyNow(BuildContext context, String planName) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to buy $planName plan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to payment screen or show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Redirecting to payment for $planName...'),
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                );
              },
              child: Text('Buy Now'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponsivePlanGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    final plans = _getPlanData();

    // Calculate card width based on screen width and spacing
    final spacing = Responsive.width(context, 2);
    final availableWidth =
        screenWidth - (Responsive.width(context, 4)); // padding
    final cardWidth =
        (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

    return Wrap(
      spacing: spacing,
      runSpacing: Responsive.height(context, 2),
      alignment: WrapAlignment.center,
      children: plans.map((plan) {
        return SizedBox(
          width: cardWidth,
          child: PlanCard(
            planName: plan['name'],
            price: plan['price'],
            dataAllowance: plan['dataAllowance'],
            features: plan['features'],
            hasHotSale: plan['hasHotSale'],
            onBuyNow: () => _handleBuyNow(context, plan['name']),
          ),
        );
      }).toList(),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: 1 column
      return 1;
    } else if (screenWidth < 900) {
      // Tablet: 2 columns
      return 2;
    } else if (screenWidth < 1200) {
      // Large tablet/small desktop: 3 columns
      return 3;
    } else {
      // Large desktop: 4 columns
      return 4;
    }
  }

  List<Map<String, dynamic>> _getPlanData() {
    return [
      {
        'name': AppStrings.planY150,
        'price': AppStrings.priceY150,
        'dataAllowance': AppStrings.data150GB,
        'features': [
          AppStrings.feature365Days,
          AppStrings.saving40,
          AppStrings.featureUnlimitedDevices,
          AppStrings.featureCapacity150,
          AppStrings.featureExtendBandwidth,
          AppStrings.feature24Support,
        ],
        'hasHotSale': true,
      },
      {
        'name': AppStrings.planM150,
        'price': AppStrings.priceM150,
        'dataAllowance': AppStrings.data150GB,
        'features': [
          AppStrings.feature30Days,
          AppStrings.featureUnlimitedDevices,
          AppStrings.featureCapacity150,
          AppStrings.featureExtendBandwidth,
          AppStrings.feature24Support,
        ],
        'hasHotSale': true,
      },
      {
        'name': AppStrings.planFreeTrial,
        'price': AppStrings.priceFreeTrial,
        'dataAllowance': AppStrings.data4GB,
        'features': [
          AppStrings.featureNewUserOnly,
          AppStrings.featureFreeUse,
          AppStrings.featureHighSpeed,
          AppStrings.featureCapacity4,
          AppStrings.feature24Support,
        ],
        'hasHotSale': true,
      },
      {
        'name': AppStrings.planY250,
        'price': AppStrings.priceY250,
        'dataAllowance': AppStrings.data250GB,
        'features': [
          AppStrings.feature365Days,
          AppStrings.saving40,
          AppStrings.featureUnlimitedDevices,
          AppStrings.featureCapacity250,
          AppStrings.featureExtendBandwidth,
          AppStrings.feature24Support,
        ],
        'hasHotSale': false,
      },
      {
        'name': AppStrings.planH250,
        'price': AppStrings.priceH250,
        'dataAllowance': AppStrings.data250GB,
        'features': [
          AppStrings.feature180Days,
          AppStrings.saving20,
          AppStrings.featureUnlimitedDevices,
          AppStrings.featureCapacity250,
          AppStrings.featureExtendBandwidth,
          AppStrings.feature24Support,
        ],
        'hasHotSale': false,
      },
      {
        'name': AppStrings.planH150,
        'price': AppStrings.priceH150,
        'dataAllowance': AppStrings.data150GB,
        'features': [
          AppStrings.feature180Days,
          AppStrings.saving20,
          AppStrings.featureUnlimitedDevices,
          AppStrings.featureCapacity150,
          AppStrings.featureExtendBandwidth,
          AppStrings.feature24Support,
        ],
        'hasHotSale': false,
      },
    ];
  }
}
