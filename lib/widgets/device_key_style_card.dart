import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class DeviceKeyStyleCard extends StatelessWidget {
  final String deviceName;
  final String ssidName;
  final String location;
  final bool isOnline;
  final bool isVpnConnected;
  final VoidCallback? onConnect;
  final VoidCallback? onExpand;

  const DeviceKeyStyleCard({
    super.key,
    required this.deviceName,
    required this.ssidName,
    required this.location,
    required this.isOnline,
    required this.isVpnConnected,
    this.onConnect,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.height(context, 1.5)),
      padding: EdgeInsets.all(Responsive.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Device icon (similar to key icon)
          Container(
            width: Responsive.getFontSize(context, 48),
            height: Responsive.getFontSize(context, 48),
            decoration: BoxDecoration(
              color: isOnline ? AppColors.PRIMARY_COLOR : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.flash_on,
              color: Colors.white,
              size: Responsive.getFontSize(context, 24),
            ),
          ),
          SizedBox(width: Responsive.width(context, 4)),

          // Middle: Device info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.TEXT_PRIMARY_COLOR,
                  ),
                ),
                SizedBox(height: Responsive.height(context, 0.5)),
                Text(
                  ssidName,
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 14),
                    color: AppColors.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(height: Responsive.height(context, 0.3)),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 12),
                    color: AppColors.TEXT_HINT_COLOR,
                  ),
                ),
              ],
            ),
          ),

          // Right: Connect button and expand
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isVpnConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 12),
                  color: isVpnConnected
                      ? AppColors.SUCCESS_COLOR
                      : AppColors.TEXT_HINT_COLOR,
                ),
              ),
              SizedBox(height: Responsive.height(context, 1)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onConnect,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 3),
                        vertical: Responsive.height(context, 0.8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Connect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.getFontSize(context, 12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.width(context, 2)),
                  GestureDetector(
                    onTap: onExpand,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.PRIMARY_COLOR,
                      size: Responsive.getFontSize(context, 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
