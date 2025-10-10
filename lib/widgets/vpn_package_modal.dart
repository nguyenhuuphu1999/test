import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class VpnPackageModal extends StatelessWidget {
  final String currentPackage;
  final Function(String) onPackageSelected;

  const VpnPackageModal({
    super.key,
    required this.currentPackage,
    required this.onPackageSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Mock VPN packages data (purchased packages)
    final List<Map<String, dynamic>> packages = [
      {
        'name': 'R500-manhnguyen-250420',
        'quota': '500GB',
        'duration': '30 days',
        'isActive': true,
        'status': 'Active',
      },
      {
        'name': 'R1000-premium-250420',
        'quota': '1000GB',
        'duration': '30 days',
        'isActive': false,
        'status': 'Available',
      },
      {
        'name': 'R2000-unlimited-250420',
        'quota': 'Unlimited',
        'duration': '30 days',
        'isActive': false,
        'status': 'Available',
      },
    ];

    return Container(
      height: Responsive.height(context, 70),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: Responsive.height(context, 1)),
            width: Responsive.width(context, 15),
            height: Responsive.height(context, 0.5),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(Responsive.width(context, 4)),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.primary,
                  size: Responsive.getFontSize(context, 24),
                ),
                SizedBox(width: Responsive.width(context, 3)),
                Text(
                  AppStrings.selectVpnPackage,
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                // Buy Key Icon
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to buy key page
                    print('Buy Key tapped');
                  },
                  child: Container(
                    padding: EdgeInsets.all(Responsive.width(context, 2)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.primary,
                      size: Responsive.getFontSize(context, 20),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 2)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: Responsive.getFontSize(context, 24),
                  ),
                ),
              ],
            ),
          ),

          // Current Package Info
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 4),
            ),
            padding: EdgeInsets.all(Responsive.width(context, 3)),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: Responsive.getFontSize(context, 20),
                ),
                SizedBox(width: Responsive.width(context, 2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Package',
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 12),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        currentPackage,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Responsive.height(context, 2)),

          // Packages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 4),
              ),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                final isCurrentPackage = package['name'] == currentPackage;

                return Container(
                  margin: EdgeInsets.only(
                    bottom: Responsive.height(context, 1.5),
                  ),
                  child: GestureDetector(
                    onTap: isCurrentPackage
                        ? null
                        : () {
                            onPackageSelected(package['name']);
                            Navigator.pop(context);
                          },
                    child: Container(
                      padding: EdgeInsets.all(Responsive.width(context, 4)),
                      decoration: BoxDecoration(
                        color: isCurrentPackage
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrentPackage
                              ? AppColors.primary
                              : AppColors.border,
                          width: isCurrentPackage ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Package Icon
                          Container(
                            width: Responsive.getFontSize(context, 40),
                            height: Responsive.getFontSize(context, 40),
                            decoration: BoxDecoration(
                              color: isCurrentPackage
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.vpn_lock,
                              color: isCurrentPackage
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              size: Responsive.getFontSize(context, 20),
                            ),
                          ),

                          SizedBox(width: Responsive.width(context, 3)),

                          // Package Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  package['name'],
                                  style: TextStyle(
                                    fontSize: Responsive.getFontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    color: isCurrentPackage
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(
                                  height: Responsive.height(context, 0.5),
                                ),
                                Row(
                                  children: [
                                    _buildPackageInfo(
                                      Icons.storage,
                                      package['quota'],
                                      context,
                                    ),
                                    SizedBox(
                                      width: Responsive.width(context, 3),
                                    ),
                                    _buildPackageInfo(
                                      Icons.access_time,
                                      package['duration'],
                                      context,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Status Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.width(context, 3),
                              vertical: Responsive.height(context, 0.8),
                            ),
                            decoration: BoxDecoration(
                              color: isCurrentPackage
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: isCurrentPackage
                                  ? null
                                  : Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              package['status'],
                              style: TextStyle(
                                fontSize: Responsive.getFontSize(context, 12),
                                fontWeight: FontWeight.w600,
                                color: isCurrentPackage
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Padding
          SizedBox(height: Responsive.height(context, 2)),
        ],
      ),
    );
  }

  Widget _buildPackageInfo(IconData icon, String text, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Responsive.getFontSize(context, 12),
          color: AppColors.textSecondary,
        ),
        SizedBox(width: Responsive.width(context, 1)),
        Text(
          text,
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 12),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
