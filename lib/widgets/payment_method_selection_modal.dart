import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/features/payment_methods/domain/entities/payment_method.dart';
import 'package:vpncn2_app/features/plans/domain/entities/plan.dart';
import 'package:vpncn2_app/services/payment_methods_service.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/utils/language_mapper.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';

class PaymentMethodSelectionModal extends StatefulWidget {
  final Plan selectedPlan;

  const PaymentMethodSelectionModal({super.key, required this.selectedPlan});

  @override
  State<PaymentMethodSelectionModal> createState() =>
      _PaymentMethodSelectionModalState();
}

class _PaymentMethodSelectionModalState
    extends State<PaymentMethodSelectionModal>
    with ErrorHandlerMixin {
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;
  PaymentMethod? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    final result = await PaymentMethodsService.getActivePaymentMethods();

    result.when(
      ok: (paymentMethods) {
        setState(() {
          _paymentMethods = paymentMethods;
          _isLoading = false;
        });
      },
      err: (failure) {
        setState(() {
          _isLoading = false;
        });
        
        // Handle different types of errors
        final statusCode = failure.when(
          network: (message, statusCode) => statusCode,
          server: (message, statusCode, errorCode) => statusCode,
          auth: (message) => null,
          validation: (message, errors) => null,
          unknown: (message, error) => null,
          cache: (message) => null,
          timeout: (message) => null,
          client: (message, statusCode) => statusCode,
        );
        
        if (statusCode != null && statusCode >= 400) {
          // Show specific error message for HTTP status errors
          showError(
            failure,
            customMessage: 'Failed to load payment methods ($statusCode): ${failure.when(
              network: (message, statusCode) => message,
              server: (message, statusCode, errorCode) => message,
              auth: (message) => message,
              validation: (message, errors) => message,
              unknown: (message, error) => message,
              cache: (message) => message,
              timeout: (message) => message,
              client: (message, statusCode) => message,
            )}',
            onRetry: () => _loadPaymentMethods(),
          );
        } else {
          // Handle network or other errors
          handleApiResult(
            result,
            onSuccess: (paymentMethods) {
              setState(() {
                _paymentMethods = paymentMethods;
                _isLoading = false;
              });
            },
            onRetry: () => _loadPaymentMethods(),
          );
        }
      },
    );
  }

  void _selectPaymentMethod(PaymentMethod paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
  }

  void _proceedToPayment() {
    if (_selectedPaymentMethod == null) {
      showWarning(
        LanguageMapper.getLocalizedText(
          'Please select a payment method first',
          context,
        ),
      );
      return;
    }

    // TODO: Implement payment processing
    Navigator.of(context).pop();
    showSuccess(
      'Proceeding to payment with ${_selectedPaymentMethod!.name} for ${widget.selectedPlan.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(Responsive.width(context, 6)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.PRIMARY_COLOR,
                    size: Responsive.getFontSize(context, 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    LanguageMapper.getLocalizedText(
                      'Select Payment Method',
                      context,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ),
                Icon(
                  Icons.payment,
                  color: AppColors.PRIMARY_COLOR,
                  size: Responsive.getFontSize(context, 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),

          // Selected Plan Summary
          Container(
            margin: EdgeInsets.all(Responsive.width(context, 6)),
            padding: EdgeInsets.all(Responsive.width(context, 4)),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.cell_tower,
                  color: AppColors.PRIMARY_COLOR,
                  size: Responsive.getFontSize(context, 20),
                ),
                SizedBox(width: Responsive.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedPlan.name,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      Text(
                        '${widget.selectedPlan.bandWidth}GB • ${widget.selectedPlan.day} days',
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          color: AppColors.TEXT_SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${widget.selectedPlan.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ],
            ),
          ),

          // Payment Methods List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _paymentMethods.isEmpty
                ? const Center(child: Text('No payment methods available'))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.width(context, 6),
                    ),
                    itemCount: _paymentMethods.length,
                    itemBuilder: (context, index) {
                      final paymentMethod = _paymentMethods[index];
                      final isSelected =
                          _selectedPaymentMethod?.id == paymentMethod.id;

                      return Container(
                        margin: EdgeInsets.only(
                          bottom: Responsive.height(context, 2),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.PRIMARY_COLOR
                                : Colors.grey[200]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _selectPaymentMethod(paymentMethod),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.all(
                              Responsive.width(context, 4),
                            ),
                            child: Row(
                              children: [
                                // Payment method logo
                                Container(
                                  width: Responsive.getFontSize(context, 48),
                                  height: Responsive.getFontSize(context, 48),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      paymentMethod.logoUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              _getPaymentMethodIcon(
                                                paymentMethod.code,
                                              ),
                                              color: AppColors.PRIMARY_COLOR,
                                              size: Responsive.getFontSize(
                                                context,
                                                24,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                SizedBox(width: Responsive.width(context, 3)),

                                // Payment method info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        paymentMethod.name,
                                        style: TextStyle(
                                          fontSize: Responsive.getFontSize(
                                            context,
                                            16,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.TEXT_PRIMARY_COLOR,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Responsive.height(context, 0.5),
                                      ),
                                      Text(
                                        paymentMethod.type.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: Responsive.getFontSize(
                                            context,
                                            12,
                                          ),
                                          color: AppColors.TEXT_SECONDARY_COLOR,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection indicator
                                Container(
                                  width: Responsive.getFontSize(context, 24),
                                  height: Responsive.getFontSize(context, 24),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.PRIMARY_COLOR
                                          : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? AppColors.PRIMARY_COLOR
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: Responsive.getFontSize(
                                            context,
                                            16,
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Proceed to Payment Button
          if (_selectedPaymentMethod != null)
            Padding(
              padding: EdgeInsets.all(Responsive.width(context, 6)),
              child: SizedBox(
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
                  ),
                  child: Text(
                    LanguageMapper.getLocalizedText(
                      'Proceed to Payment',
                      context,
                    ),
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(String code) {
    switch (code.toLowerCase()) {
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'stripe':
        return Icons.credit_card;
      case 'alipay':
        return Icons.payment;
      case 'wechat':
        return Icons.chat;
      default:
        return Icons.payment;
    }
  }
}
