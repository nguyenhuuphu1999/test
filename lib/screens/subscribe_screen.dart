import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';
import 'package:vpncn2_app/widgets/expandable_plan_card.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  // Track expansion state for each row
  final Map<int, bool> _rowExpansionStates = {};

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

  void _toggleRowExpansion(int rowIndex) {
    setState(() {
      _rowExpansionStates[rowIndex] = !(_rowExpansionStates[rowIndex] ?? false);
    });
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
    final childAspectRatio = _getChildAspectRatio(context, crossAxisCount);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Responsive.width(context, 2),
        mainAxisSpacing: Responsive.height(context, 2),
        childAspectRatio: childAspectRatio,
      ),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        final rowIndex = index ~/ crossAxisCount;
        final isExpanded = _rowExpansionStates[rowIndex] ?? false;

        return ExpandablePlanCard(
          planName: plan['name'],
          price: plan['price'],
          dataAllowance: plan['dataAllowance'],
          features: plan['features'],
          hasHotSale: plan['hasHotSale'],
          onBuyNow: () => _handleBuyNow(context, plan['name']),
          isExpanded: isExpanded,
          rowIndex: rowIndex,
          onExpansionChanged: () => _toggleRowExpansion(rowIndex),
        );
      },
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

  double _getChildAspectRatio(BuildContext context, int crossAxisCount) {
    // Calculate aspect ratio based on screen width and fixed height (341px)
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = Responsive.width(context, 2); // 2% spacing between cards
    final totalSpacing = spacing * (crossAxisCount - 1);
    final cardWidth = (screenWidth - totalSpacing) / crossAxisCount;
    return cardWidth / 341; // 341px is our fixed height
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
