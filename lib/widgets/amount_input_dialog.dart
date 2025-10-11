import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class AmountInputDialog extends StatefulWidget {
  const AmountInputDialog({super.key});

  @override
  State<AmountInputDialog> createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<AmountInputDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isAmountEntered = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {
      _isAmountEntered = _amountController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.SURFACE_COLOR,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        AppStrings.enterAmount,
        style: TextStyle(
          fontSize: Responsive.getFontSize(context, 18),
          fontWeight: FontWeight.w600,
          color: AppColors.TEXT_PRIMARY_COLOR,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberInputFormatter(),
            ],
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 16),
              fontWeight: FontWeight.w500,
              color: AppColors.TEXT_PRIMARY_COLOR,
            ),
            decoration: InputDecoration(
              hintText: '0 ${AppStrings.vnd}',
              hintStyle: TextStyle(
                fontSize: Responsive.getFontSize(context, 16),
                color: AppColors.TEXT_SECONDARY_COLOR,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.BORDER_COLOR),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.BORDER_COLOR),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 4),
                vertical: Responsive.height(context, 2),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel ?? 'Cancel',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 16),
              fontWeight: FontWeight.w500,
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isAmountEntered
              ? () {
                  final amount = _amountController.text;
                  Navigator.pop(context, amount);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAmountEntered
                ? AppColors.PRIMARY_COLOR
                : AppColors.DISABLED_COLOR,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 6),
              vertical: Responsive.height(context, 1.5),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            AppStrings.proceedToPayment,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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


