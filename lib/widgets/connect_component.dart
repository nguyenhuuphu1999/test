import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive.dart';

/// Connect component similar to the image with lightning bolt icon
class ConnectComponent extends StatefulWidget {
  final bool isConnected;
  final String? serverLocation;
  final String? serverCountry;
  final String? availability;
  final String? connectedTime;
  final String? downloadSpeed;
  final String? uploadSpeed;
  final VoidCallback? onConnect;
  final VoidCallback? onChangeServer;
  final VoidCallback? onSwitchKey;

  const ConnectComponent({
    super.key,
    this.isConnected = false,
    this.serverLocation,
    this.serverCountry,
    this.availability,
    this.connectedTime,
    this.downloadSpeed,
    this.uploadSpeed,
    this.onConnect,
    this.onChangeServer,
    this.onSwitchKey,
  });

  @override
  State<ConnectComponent> createState() => _ConnectComponentState();
}

class _ConnectComponentState extends State<ConnectComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F6F8),
      child: Column(
        children: [
          // Top Key Information Card
          _buildKeyInfoCard(),
          const SizedBox(height: 12),
          
          // Server Location Card
          _buildServerLocationCard(),
          const SizedBox(height: 12),
          
          // Data Transfer Stats
          _buildDataTransferStats(),
          const SizedBox(height: 20),
          
          // Globe with Connection Status
          _buildGlobeSection(),
          const SizedBox(height: 16),
          
          // Connected Time
          _buildConnectedTime(),
          const SizedBox(height: 16),
          
          // Change Server Button
          _buildChangeServerButton(),
          const SizedBox(height: 20),
          
          // Connect Button (Bottom Navigation Style)
          _buildConnectButton(),
        ],
      ),
    );
  }

  Widget _buildKeyInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Y150-Manhnguyen-250101-1',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.TEXT_PRIMARY_COLOR,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Expire In: 360 Days',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 12),
                    color: AppColors.TEXT_SECONDARY_COLOR,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Used: 125GB Today: 2.5GB Limit: 150GB',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 12),
                    color: AppColors.TEXT_HINT_COLOR,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: AppColors.PRIMARY_COLOR,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Switch The Key',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 10),
                  color: AppColors.PRIMARY_COLOR,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServerLocationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Netherlands Flag (simplified)
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.white, Colors.blue],
                stops: [0.33, 0.66, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serverCountry ?? 'Netherlands',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.TEXT_PRIMARY_COLOR,
                  ),
                ),
                Text(
                  widget.serverLocation ?? 'Amsterdam',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 14),
                    color: AppColors.TEXT_SECONDARY_COLOR,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Available',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 14),
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.availability ?? '99.9%',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 12),
                  color: AppColors.TEXT_SECONDARY_COLOR,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTransferStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Download Stats
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Download:',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 12),
                      color: AppColors.TEXT_SECONDARY_COLOR,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.downloadSpeed ?? '527 MB',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Upload Stats
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload:',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 12),
                      color: AppColors.TEXT_SECONDARY_COLOR,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.uploadSpeed ?? '49 MB',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobeSection() {
    return Column(
      children: [
        // Globe Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.PRIMARY_COLOR.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.public,
            color: Colors.white,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),
        // Server Info Bubble
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.serverLocation ?? 'Amsterdam',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.TEXT_PRIMARY_COLOR,
                ),
              ),
              Text(
                '185.107.57.5',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 12),
                  color: AppColors.TEXT_SECONDARY_COLOR,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedTime() {
    return Column(
      children: [
        Text(
          'Connected Time',
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 14),
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.connectedTime ?? '02 : 41 : 52',
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 24),
            fontWeight: FontWeight.bold,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }

  Widget _buildChangeServerButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: widget.onChangeServer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.TEXT_PRIMARY_COLOR,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.public,
              color: AppColors.PRIMARY_COLOR,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Change Server',
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 16),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: AppColors.PRIMARY_COLOR,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Security Icon
          Icon(
            Icons.security,
            color: AppColors.PRIMARY_COLOR,
            size: 24,
          ),
          
          // Connect Button (Main Action)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: widget.onConnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isConnected 
                      ? AppColors.ERROR_COLOR 
                      : AppColors.PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flash_on,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isConnected ? 'Disconnect' : 'Connect',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Profile Icon
          Icon(
            Icons.person_outline,
            color: AppColors.PRIMARY_COLOR,
            size: 24,
          ),
        ],
      ),
    );
  }
}
