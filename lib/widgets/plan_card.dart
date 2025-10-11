import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/responsive.dart';

class PlanCard extends StatefulWidget {
  final String planName;
  final String price;
  final String dataAllowance;
  final List<String> features;
  final bool hasHotSale;
  final VoidCallback? onBuyNow;

  const PlanCard({
    Key? key,
    required this.planName,
    required this.price,
    required this.dataAllowance,
    required this.features,
    this.hasHotSale = false,
    this.onBuyNow,
  }) : super(key: key);

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> with TickerProviderStateMixin {
  bool _isExpanded = false;

  List<String> get _visibleFeatures {
    if (_isExpanded) return widget.features;
    return widget.features.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final headerPadH = Responsive.width(context, 2);
    final headerPadV = Responsive.height(context, 0.7);

    return Semantics(
      label: '${widget.planName}, ${widget.price}, ${widget.dataAllowance}',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card có viền đen nhạt + ripple
          Material(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: const BorderSide(
                color: Colors.black12, // 👈 viền đen nhạt
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: radius,
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
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
                      // Header tên gói
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: headerPadH,
                          vertical: headerPadV,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.PRIMARY_COLOR.withValues(alpha: 0.10),
                              AppColors.PRIMARY_COLOR.withValues(alpha: 0.02),
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
                                widget.planName,
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

                      // Giá
                      Text(
                        widget.price,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.PRIMARY_COLOR,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: Responsive.height(context, 0.4)),

                      // Lưu lượng / chu kỳ
                      Text(
                        widget.dataAllowance,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.TEXT_PRIMARY_COLOR,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: Responsive.height(context, 0.8)),

                      // Danh sách tính năng (animation mượt)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: _visibleFeatures
                              .map(
                                (f) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Responsive.height(context, 0.25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        width: Responsive.width(context, 1.2),
                                      ),
                                      Flexible(
                                        child: Text(
                                          f,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                AppColors.TEXT_SECONDARY_COLOR,
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

                      // Nút more/hide (chỉ hiện nếu > 3)
                      if (widget.features.length > 3)
                        _MoreLessButton(
                          isExpanded: _isExpanded,
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                        ),

                      SizedBox(height: Responsive.height(context, 0.8)),

                      // Nút Mua
                      SizedBox(
                        width: double.infinity,
                        height: Responsive.height(context, 4.2),
                        child: ElevatedButton(
                          onPressed: widget.onBuyNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppStrings.buyNow,
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

          // Badge HOT SALE
          if (widget.hasHotSale)
            Positioned(right: 12, top: -6, child: const _HotSaleBadge()),
        ],
      ),
    );
  }
}

class _MoreLessButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _MoreLessButton({
    Key? key,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

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
        isExpanded ? 'hide' : 'more',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _HotSaleBadge extends StatelessWidget {
  const _HotSaleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
              AppStrings.hotSale,
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
    );
  }
}
