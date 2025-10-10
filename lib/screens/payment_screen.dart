import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: Responsive.getFontSize(context, 20),
          ),
        ),
        title: Text(
          AppStrings.payment,
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 18),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Responsive.width(context, 5)),
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
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Responsive.height(context, 2)),

            _buildPaymentMethodGroup(context, [
              _PaymentMethodItem(
                name: AppStrings.wechatPay,
                logoAsset: 'asset/images/wechat-pay.png',
                onTap: () =>
                    _handlePaymentMethodTap(context, AppStrings.wechatPay),
              ),
              _PaymentMethodItem(
                name: AppStrings.alipay,
                logoAsset: 'asset/images/alipay.png',
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
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Responsive.height(context, 2)),

            _buildPaymentMethodGroup(context, [
              _PaymentMethodItem(
                name: AppStrings.applePay,
                logoAsset: 'asset/images/apple-pay.png',
                onTap: () =>
                    _handlePaymentMethodTap(context, AppStrings.applePay),
              ),
              _PaymentMethodItem(
                name: AppStrings.mbBank,
                logoAsset: 'asset/images/Logo_MB.png',
                onTap: () =>
                    _handlePaymentMethodTap(context, AppStrings.mbBank),
              ),
              _PaymentMethodItem(
                name: AppStrings.paypal,
                logoAsset: 'asset/images/paypal-logo.png',
                onTap: () =>
                    _handlePaymentMethodTap(context, AppStrings.paypal),
              ),
            ]),

            SizedBox(height: Responsive.height(context, 3)),

            // Process Payment Section
            Text(
              AppStrings.processPayment,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Responsive.height(context, 1)),

            Text(
              AppStrings.paymentMethodDescription,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 14),
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: Responsive.height(context, 4)),
          ],
        ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          Responsive.getFontSize(context, 12),
        ),
        border: Border.all(color: AppColors.border, width: 1),
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

  void _handlePaymentMethodTap(BuildContext context, String methodName) {
    // TODO: Implement payment method selection logic
    print('Selected payment method: $methodName');

    // Show a simple dialog for now
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
          color: AppColors.surface,
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
                border: Border.all(color: AppColors.border, width: 1),
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
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: Responsive.getFontSize(context, 16),
            ),
          ],
        ),
      ),
    );
  }
}
