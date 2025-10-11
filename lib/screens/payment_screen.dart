import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/screens/mb_bank_payment_screen.dart';
import 'package:vpncn2_app/screens/other_payment_methods_screen.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';
import 'package:vpncn2_app/widgets/amount_input_dialog.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: CommonHeader(
        title: AppStrings.payment,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.height(context, 2)),

                  // Manual Payment Methods Section
                  Text(
                    AppStrings.manualPaymentMethods,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 2)),

                  _buildPaymentMethodGroup(context, [
                    _PaymentMethodItem(
                      name: AppStrings.wechatPay,
                      logoAsset: AppAssets.wechatPay,
                      onTap: () => _handlePaymentMethodTap(
                        context,
                        AppStrings.wechatPay,
                      ),
                    ),
                    _PaymentMethodItem(
                      name: AppStrings.alipay,
                      logoAsset: AppAssets.alipay,
                      onTap: () =>
                          _handlePaymentMethodTap(context, AppStrings.alipay),
                    ),
                  ]),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Online Payment Methods Section
                  Text(
                    AppStrings.onlinePaymentMethods,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 2)),

                  _buildPaymentMethodGroup(context, [
                    _PaymentMethodItem(
                      name: AppStrings.applePay,
                      logoAsset: AppAssets.applePay,
                      onTap: () =>
                          _handlePaymentMethodTap(context, AppStrings.applePay),
                    ),
                    _PaymentMethodItem(
                      name: AppStrings.mbBank,
                      logoAsset: AppAssets.mbBank,
                      onTap: () =>
                          _handlePaymentMethodTap(context, AppStrings.mbBank),
                    ),
                    _PaymentMethodItem(
                      name: AppStrings.paypal,
                      logoAsset: AppAssets.paypal,
                      onTap: () =>
                          _handlePaymentMethodTap(context, AppStrings.paypal),
                    ),
                  ]),

                  SizedBox(height: Responsive.height(context, 3)),
                ],
              ),
            ),
          ),

          // Common Footer
          CommonFooter(
            activeIndex: -1, // No active tab on payment screen
            context: context,
            onTabChanged: (index) {
              // This won't be called since we're using context navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodGroup(
    BuildContext context,
    List<_PaymentMethodItem> items,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.SURFACE_COLOR,
        borderRadius: BorderRadius.circular(
          Responsive.getFontSize(context, 12),
        ),
        border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1
                  ? 0
                  : Responsive.height(context, 1.5),
            ),
            child: item,
          );
        }).toList(),
      ),
    );
  }

  void _handlePaymentMethodTap(BuildContext context, String methodName) async {
    print('Selected payment method: $methodName');

    if (methodName == AppStrings.mbBank) {
      // Show amount input dialog first
      final amount = await showDialog<String>(
        context: context,
        builder: (context) => const AmountInputDialog(),
      );

      if (amount != null && amount.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MbBankPaymentScreen(amount: amount),
          ),
        );
      }
    } else if (methodName == AppStrings.wechatPay ||
        methodName == AppStrings.alipay) {
      // Navigate to other payment methods screen for WeChat Pay and Alipay
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OtherPaymentMethodsScreen(),
        ),
      );
    } else {
      // Show a simple dialog for other payment methods
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Method Selected'),
            content: Text('You selected: $methodName'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class _PaymentMethodItem extends StatelessWidget {
  final String name;
  final String logoAsset;
  final VoidCallback onTap;

  const _PaymentMethodItem({
    required this.name,
    required this.logoAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.height(context, 1.5),
          horizontal: Responsive.width(context, 2),
        ),
        decoration: BoxDecoration(
          color: AppColors.SURFACE_COLOR,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Payment method logo
            Container(
              width: Responsive.width(context, 12),
              height: Responsive.width(context, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(logoAsset, fit: BoxFit.contain),
              ),
            ),

            SizedBox(width: Responsive.width(context, 4)),

            // Payment method name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 15),
                  fontWeight: FontWeight.w500,
                  color: AppColors.TEXT_PRIMARY_COLOR,
                ),
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.TEXT_SECONDARY_COLOR,
              size: Responsive.getFontSize(context, 16),
            ),
          ],
        ),
      ),
    );
  }
}
