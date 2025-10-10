import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class DeviceCard extends StatefulWidget {
  final String deviceName;
  final String ssidName;
  final bool isOnline;
  final bool isVpnConnected;
  final VoidCallback? onToggle;
  final VoidCallback? onExpand;
  final VoidCallback? onChangeLocation;
  final VoidCallback? onSelectVpnPackage;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.ssidName,
    this.isOnline = true,
    this.isVpnConnected = false,
    this.onToggle,
    this.onExpand,
    this.onChangeLocation,
    this.onSelectVpnPackage,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.height(context, 2)),
      padding: EdgeInsets.all(Responsive.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              // WiFi Icon
              Container(
                width: Responsive.getFontSize(context, 43),
                height: Responsive.getFontSize(context, 43),
                decoration: BoxDecoration(
                  color: widget.isOnline ? AppColors.primary : AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi,
                  color: Colors.white,
                  size: Responsive.getFontSize(context, 24),
                ),
              ),

              SizedBox(width: Responsive.width(context, 3)),

              // Device Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.deviceName,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Responsive.height(context, 0.5)),
                    Text(
                      widget.ssidName,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 10),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: Responsive.height(context, 0.5)),
                    Text(
                      AppStrings.locationInfo,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 10),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // VPN Toggle Switch
              GestureDetector(
                onTap: widget.isOnline ? widget.onToggle : null,
                child: Container(
                  width: Responsive.getFontSize(context, 45),
                  height: Responsive.getFontSize(context, 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.isVpnConnected
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        left: widget.isVpnConnected
                            ? Responsive.getFontSize(context, 23)
                            : Responsive.getFontSize(context, 2),
                        top: Responsive.getFontSize(context, 2),
                        child: Container(
                          width: Responsive.getFontSize(context, 21),
                          height: Responsive.getFontSize(context, 21),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.border.withValues(alpha: 0.3),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: Responsive.width(context, 2)),

              // Expand/Collapse Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  width: Responsive.getFontSize(context, 24),
                  height: Responsive.getFontSize(context, 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                      size: Responsive.getFontSize(context, 16),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: Responsive.height(context, 2)),

          // Collapsible Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    children: [
                      // Device Information
                      Row(
                        children: [
                          // Labels Column
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(AppStrings.wanIp),
                                _buildInfoRow(AppStrings.lanIp),
                                _buildInfoRow(AppStrings.firmware),
                                _buildInfoRow(AppStrings.packageName),
                                _buildInfoRow(AppStrings.startDate),
                                _buildInfoRow(AppStrings.expiredDate),
                                _buildInfoRow(AppStrings.usageTotal),
                                _buildInfoRow(AppStrings.last30Days),
                              ],
                            ),
                          ),

                          SizedBox(width: Responsive.width(context, 4)),

                          // Values Column
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildInfoValue(AppStrings.wanIpValue),
                                _buildInfoValue(AppStrings.lanIpValue),
                                _buildInfoValue(AppStrings.firmwareValue),
                                _buildInfoValue(AppStrings.packageNameValue),
                                _buildInfoValue(AppStrings.startDateValue),
                                _buildInfoValue(AppStrings.expiredDateValue),
                                _buildInfoValue(AppStrings.usageTotalValue),
                                _buildInfoValue(''), // Empty for last 30 days
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Responsive.height(context, 3)),

                      // Action Buttons
                      Row(
                        children: [
                          // Change Location Button
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.isOnline
                                  ? widget.onChangeLocation
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: Responsive.height(context, 1.5),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  AppStrings.changeLocation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.getFontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    color: widget.isOnline
                                        ? AppColors.textPrimary
                                        : AppColors.disabled,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: Responsive.width(context, 3)),

                          // Select VPN Package Button
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.isOnline
                                  ? widget.onSelectVpnPackage
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: Responsive.height(context, 1.5),
                                ),
                                decoration: BoxDecoration(
                                  color: widget.isOnline
                                      ? AppColors.primary
                                      : AppColors.disabled,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppStrings.selectVpnPackage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.getFontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    color: widget.isOnline
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.height(context, 0.8)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: Responsive.getFontSize(context, 12),
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoValue(String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.height(context, 0.8)),
      child: Text(
        value,
        style: TextStyle(
          fontSize: Responsive.getFontSize(context, 12),
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
