import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class ExpandablePlanCard extends StatefulWidget {
  final String planName;
  final String price;
  final String dataAllowance;
  final List<String> features;
  final bool hasHotSale;
  final VoidCallback? onBuyNow;
  final bool isExpanded;
  final VoidCallback? onExpansionChanged;
  final int rowIndex;

  const ExpandablePlanCard({
    super.key,
    required this.planName,
    required this.price,
    required this.dataAllowance,
    required this.features,
    this.hasHotSale = false,
    this.onBuyNow,
    this.isExpanded = false,
    this.onExpansionChanged,
    this.rowIndex = 0,
  });

  @override
  State<ExpandablePlanCard> createState() => _ExpandablePlanCardState();
}

class _ExpandablePlanCardState extends State<ExpandablePlanCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 341, // Fixed height for all cards (310 + 10% = 341)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.width(context, 2.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan name header with optional HOT SALE badge
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.width(context, 3),
                    vertical: Responsive.height(context, 1),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.planName,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ),
                if (widget.hasHotSale)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 1.5),
                        vertical: Responsive.height(context, 0.3),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C00),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: Responsive.getFontSize(context, 12),
                            color: Colors.red,
                          ),
                          SizedBox(width: Responsive.width(context, 1)),
                          Text(
                            AppStrings.hotSale,
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 10),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: Responsive.height(context, 1)),

            // Price and duration
            Text(
              widget.price,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 14),
                fontWeight: FontWeight.w600,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),

            SizedBox(height: Responsive.height(context, 0.3)),

            // Data allowance
            Text(
              widget.dataAllowance,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 16),
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),

            SizedBox(height: Responsive.height(context, 0.2)),

            // Features (always show first 3, show more when expanded)
            ...widget.features
                .take(widget.isExpanded ? widget.features.length : 3)
                .map(
                  (feature) => Padding(
                    padding: EdgeInsets.only(
                      bottom: Responsive.height(context, 0.2),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: Responsive.getFontSize(context, 10),
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        SizedBox(width: Responsive.width(context, 1.5)),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 10),
                              fontWeight: FontWeight.w400,
                              color: AppColors.TEXT_PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            SizedBox(height: Responsive.height(context, 0.2)),

            // More/Hide button
            if (widget.features.length > 3)
              GestureDetector(
                onTap: () {
                  widget.onExpansionChanged?.call();
                },
                child: Text(
                  widget.isExpanded ? AppStrings.hide : AppStrings.more,
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 10),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8B5CF6),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

            SizedBox(height: Responsive.height(context, 0.5)),

            // Buy Now button
            SizedBox(
              width: double.infinity,
              height: Responsive.height(context, 3.5),
              child: ElevatedButton(
                onPressed: widget.onBuyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.buyNow,
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
