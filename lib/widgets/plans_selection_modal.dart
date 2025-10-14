import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/features/plans/domain/entities/plan.dart';
import 'package:vpncn2_app/services/plans_service.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/utils/language_mapper.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';
import 'package:vpncn2_app/widgets/payment_method_selection_modal.dart';

class PlansSelectionModal extends StatefulWidget {
  const PlansSelectionModal({super.key});

  @override
  State<PlansSelectionModal> createState() => _PlansSelectionModalState();
}

class _PlansSelectionModalState extends State<PlansSelectionModal>
    with ErrorHandlerMixin, TickerProviderStateMixin {
  List<Plan> _plans = [];
  bool _isLoading = true;
  Plan? _selectedPlan;
  Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
    });

    final result = await PlansService.getPlans(status: 1, enable: 1);

    handleApiResult(
      result,
      onSuccess: (plansResponse) {
        setState(() {
          _plans = plansResponse.plans;
          _isLoading = false;
        });
      },
      onRetry: () => _loadPlans(),
    );
  }

  void _selectPlan(Plan plan) {
    setState(() {
      _selectedPlan = plan;
    });
  }

  void _purchasePlan() {
    if (_selectedPlan == null) {
      showWarning(
        LanguageMapper.getLocalizedText('Please select a plan first', context),
      );
      return;
    }

    // Show payment method selection modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          PaymentMethodSelectionModal(selectedPlan: _selectedPlan!),
    );
  }

  List<String> _getVisibleFeatures(Plan plan) {
    final isExpanded = _expandedStates[plan.id] ?? false;
    if (isExpanded) return plan.description;
    return plan.description.take(3).toList();
  }

  void _toggleExpansion(String planId) {
    setState(() {
      _expandedStates[planId] = !(_expandedStates[planId] ?? false);
    });
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
                      'Choose Your Plan',
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
                Image.asset(
                  'asset/images/shopping-cart.png',
                  width: Responsive.getFontSize(context, 20),
                  height: Responsive.getFontSize(context, 20),
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _plans.isEmpty
                ? const Center(child: Text('No plans available'))
                : _buildPlansList(),
          ),

          // Purchase Button
          if (_selectedPlan != null)
            Padding(
              padding: EdgeInsets.all(Responsive.width(context, 6)),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _purchasePlan,
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
                    'Purchase \$${_selectedPlan!.price.toStringAsFixed(2)}',
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

  Widget _buildPlansList() {
    return ListView.builder(
      padding: EdgeInsets.all(Responsive.width(context, 6)),
      itemCount: _plans.length,
      itemBuilder: (context, index) {
        final plan = _plans[index];
        final isSelected = _selectedPlan?.id == plan.id;

        return Container(
          margin: EdgeInsets.only(bottom: Responsive.height(context, 2)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Card following PlanCard design pattern
              Material(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.PRIMARY_COLOR
                        : Colors.black12,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _selectPlan(plan),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with gradient background (like PlanCard)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.width(context, 2),
                              vertical: Responsive.height(context, 0.7),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.PRIMARY_COLOR.withValues(
                                    alpha: 0.10,
                                  ),
                                  AppColors.PRIMARY_COLOR.withValues(
                                    alpha: 0.02,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.PRIMARY_COLOR.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cell_tower,
                                  size: Responsive.getFontSize(context, 14),
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                                SizedBox(width: Responsive.width(context, 1)),
                                Flexible(
                                  child: Text(
                                    plan.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.PRIMARY_COLOR,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: Responsive.height(context, 0.9)),

                          // Price (like PlanCard)
                          Text(
                            '\$${plan.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.PRIMARY_COLOR,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: Responsive.height(context, 0.4)),

                          // Data allowance (like PlanCard)
                          Text(
                            '${plan.bandWidth}GB • ${plan.day} days',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.TEXT_PRIMARY_COLOR,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: Responsive.height(context, 0.8)),

                          // Features list with expandable functionality (like PlanCard)
                          AnimatedSize(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: _getVisibleFeatures(plan)
                                  .map(
                                    (feature) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: Responsive.height(
                                          context,
                                          0.25,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: Responsive.getFontSize(
                                              context,
                                              12,
                                            ),
                                            color: AppColors.PRIMARY_COLOR,
                                          ),
                                          SizedBox(
                                            width: Responsive.width(
                                              context,
                                              1.2,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              LanguageMapper.getLocalizedFeature(
                                                feature,
                                                context,
                                              ),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors
                                                    .TEXT_SECONDARY_COLOR,
                                                height: 1.25,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                          // More/Less button (like PlanCard)
                          if (plan.description.length > 3)
                            _MoreLessButton(
                              isExpanded: _expandedStates[plan.id] ?? false,
                              onTap: () => _toggleExpansion(plan.id),
                            ),

                          SizedBox(height: Responsive.height(context, 0.8)),

                          // Purchase count
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people,
                                color: AppColors.TEXT_SECONDARY_COLOR,
                                size: Responsive.getFontSize(context, 12),
                              ),
                              SizedBox(width: Responsive.width(context, 1)),
                              Text(
                                '${plan.numberPurchase} ${LanguageMapper.getLocalizedText('people purchased', context)}',
                                style: TextStyle(
                                  fontSize: Responsive.getFontSize(context, 12),
                                  color: AppColors.TEXT_SECONDARY_COLOR,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: Responsive.height(context, 0.8)),

                          // Buy Now button (like PlanCard)
                          SizedBox(
                            width: double.infinity,
                            height: Responsive.height(context, 4.2),
                            child: ElevatedButton(
                              onPressed: () => _selectPlan(plan),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? AppColors.SUCCESS_COLOR
                                    : AppColors.PRIMARY_COLOR,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isSelected
                                    ? LanguageMapper.getLocalizedText(
                                        'Selected',
                                        context,
                                      )
                                    : LanguageMapper.getLocalizedText(
                                        'Select Plan',
                                        context,
                                      ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Hot Sale Badge (like PlanCard) - Show only if status = 1
              if (plan.status == 1)
                Positioned(
                  right: 12,
                  top: -6,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF7A00),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.20),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 2.2),
                        vertical: Responsive.height(context, 0.55),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: Responsive.getFontSize(context, 11),
                            color: Colors.white,
                          ),
                          SizedBox(width: Responsive.width(context, 0.6)),
                          Text(
                            'HOT',
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 10),
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MoreLessButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _MoreLessButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = Responsive.getFontSize(context, 12);
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(0, Responsive.height(context, 2.8)),
        padding: EdgeInsets.symmetric(horizontal: Responsive.width(context, 1)),
      ),
      icon: AnimatedRotation(
        turns: isExpanded ? 0.5 : 0.0,
        duration: const Duration(milliseconds: 180),
        child: Icon(Icons.expand_more, size: fontSize + 2),
      ),
      label: Text(
        isExpanded
            ? LanguageMapper.getLocalizedText('hide', context)
            : LanguageMapper.getLocalizedText('more', context),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
