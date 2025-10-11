import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/screens/payment_success_screen.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';

class MbBankPaymentScreen extends StatefulWidget {
  final String amount;

  const MbBankPaymentScreen({super.key, required this.amount});

  @override
  State<MbBankPaymentScreen> createState() => _MbBankPaymentScreenState();
}

class _MbBankPaymentScreenState extends State<MbBankPaymentScreen> {
  void _proceedToPayment() {
    // Simulate payment processing and navigate to success screen
    print('Proceeding to payment with amount: ${widget.amount}');

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing payment...'),
              ],
            ),
          ),
        );
      },
    );

    // Simulate payment processing delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
      );
    });
  }

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

                  // Contact to admin link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement contact admin functionality
                        print('Contact admin tapped');
                      },
                      child: Text(
                        AppStrings.contactToAdmin,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Payment instructions
                  Text(
                    AppStrings.pleaseFinishPayment,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Amount display section
                  Container(
                    padding: EdgeInsets.all(Responsive.width(context, 4)),
                    decoration: BoxDecoration(
                      color: AppColors.SURFACE_COLOR,
                      borderRadius: BorderRadius.circular(
                        Responsive.getFontSize(context, 12),
                      ),
                      border: Border.all(
                        color: AppColors.BORDER_COLOR,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.amount,
                          style: TextStyle(
                            fontSize: Responsive.getFontSize(context, 16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.TEXT_PRIMARY_COLOR,
                          ),
                        ),
                        SizedBox(height: Responsive.height(context, 2)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${widget.amount} ${AppStrings.vnd}',
                                style: TextStyle(
                                  fontSize: Responsive.getFontSize(context, 20),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 3)),

                  // Proceed to payment button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _proceedToPayment,
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
                        AppStrings.proceedToPayment,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.height(context, 4)),
                ],
              ),
            ),
          ),

          // Common Footer
          CommonFooter(
            activeIndex: -1, // No active tab on MB Bank payment screen
            onTabChanged: (index) {
              switch (index) {
                case 0:
                  Navigator.pop(context);
                  break;
                case 1:
                case 2:
                  // TODO: Navigate to respective screens
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}

// Custom number formatter to add commas
class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Add commas for thousands
    String formatted = _addCommas(digitsOnly);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addCommas(String value) {
    if (value.isEmpty) return '';

    // Reverse the string, add commas every 3 digits, then reverse back
    String reversed = value.split('').reversed.join('');
    String withCommas = reversed.replaceAllMapped(
      RegExp(r'.{3}'),
      (match) => '${match.group(0)},',
    );

    // Remove trailing comma if exists
    if (withCommas.endsWith(',')) {
      withCommas = withCommas.substring(0, withCommas.length - 1);
    }

    return withCommas.split('').reversed.join('');
  }
}
