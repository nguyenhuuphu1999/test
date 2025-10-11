import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/smooth_main_layout.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      body: Column(
        children: [
          // Light green header area
          Container(
            height: Responsive.height(context, 35),
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E8), // Light green background
            ),
            child: Stack(
              children: [
                // Decorative shape
                Center(
                  child: Container(
                    width: Responsive.width(context, 25),
                    height: Responsive.height(context, 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFD4F1D4), // Lighter green for shape
                      borderRadius: BorderRadius.circular(
                        Responsive.getFontSize(context, 8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon
                  Container(
                    width: Responsive.width(context, 20),
                    height: Responsive.width(context, 20),
                    decoration: BoxDecoration(
                      color: AppColors.SUCCESS_COLOR,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.SUCCESS_COLOR,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: Responsive.getFontSize(context, 30),
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Success message
                  Text(
                    AppStrings.paymentSuccessful,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 24),
                      fontWeight: FontWeight.bold,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: Responsive.height(context, 1)),

                  // Thank you message
                  Text(
                    AppStrings.thankYouForPaying,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 16),
                      fontWeight: FontWeight.w400,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 5),
              vertical: Responsive.height(context, 3),
            ),
            child: Column(
              children: [
                // View E-Receipt button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement view e-receipt functionality
                      print('View E-Receipt tapped');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.height(context, 2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.viewEReceipt,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(context, 2)),

                // Back to Home button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate back to home screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SmoothMainLayout(),
                        ),
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.TEXT_PRIMARY_COLOR,
                      side: BorderSide(color: AppColors.BORDER_COLOR),
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.height(context, 2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppStrings.backToHome,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Common Footer
          CommonFooter(
            activeIndex: 0, // Home is active on success screen
            onTabChanged: (index) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SmoothMainLayout(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
