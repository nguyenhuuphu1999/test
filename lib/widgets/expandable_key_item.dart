import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/models/key_details.dart';
import 'package:vpncn2_app/widgets/key_details_expansion.dart';
import 'package:vpncn2_app/services/vpn_service.dart';
import 'package:vpncn2_app/services/outline_sdk_service.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;
import 'package:vpncn2_app/services/outline_brigde.dart';

class ExpandableKeyItem extends StatefulWidget {
  final String name;
  final String quotaText;
  final int? remainDays;
  final bool expired;
  final VoidCallback? onConnect;
  final Function(String code, String country)? onServerLocationChanged;
  final KeyEntity.Key? keyData; // Add key data for VPN connection

  const ExpandableKeyItem({
    super.key,
    required this.name,
    required this.quotaText,
    this.remainDays,
    this.expired = false,
    this.onConnect,
    this.onServerLocationChanged,
    this.keyData,
  });

  @override
  State<ExpandableKeyItem> createState() => _ExpandableKeyItemState();
}

class _ExpandableKeyItemState extends State<ExpandableKeyItem> {
  bool _isExpanded = false;
  late KeyDetails _keyDetails;
  final VpnService _vpnService = VpnService();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _keyDetails = KeyDetails.fromKeyItem(
      widget.name,
      widget.quotaText,
      widget.remainDays ?? 0,
      expired: widget.expired,
    );
  }

  Future<void> _handleConnect() async {
    if (widget.keyData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể kết nối: Thiếu thông tin key'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isConnecting = true;
    });

    try {
      final vpnPermissionOk = await OutlineBridge.ensureVpnPermission();
      if (!vpnPermissionOk) {
        debugPrint(
          'ℹ️ VPN permission dialog opened. Please grant permission and try connecting again.',
        );
        throw Exception(
          'ℹ️ VPN permission dialog opened. Please grant permission and try connecting again.',
        );
      }
      // final success = await _vpnService.connectWithKey(widget.keyData!);
      final ok = await OutlineBridge.start(
        serverHost: widget.keyData!.serverName,
        serverPort: widget.keyData!.port,
        method: widget.keyData!.method,
        password: widget.keyData!.password,
        remarks: widget.keyData!.name,
      );
      debugPrint('🔍 Outline Bridge start: $ok');
      if (ok) {
        if (mounted) {
          // Test VPN connection with Outline SDK
          // _testVpnConnectionWithOutline();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể kết nối VPN'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('🔍 Outline Bridge start error: $e');
      if (mounted) {
        String errorMessage = 'Lỗi kết nối VPN';

        // Provide more specific error messages
        if (e.toString().contains('MissingPluginException')) {
          errorMessage =
              'VPN plugin chưa được cài đặt đúng cách.\nVui lòng khởi động lại ứng dụng.';
        } else if (e.toString().contains('không khả dụng')) {
          errorMessage =
              'VPN service không khả dụng.\nPlugin có thể chưa được cài đặt đúng cách.';
        } else if (e.toString().contains('quyền VPN') ||
            e.toString().contains('VPN permission')) {
          // _showVpnPermissionDialog();
          return; // Don't show snackbar, show dialog instead
        } else {
          errorMessage = 'Lỗi kết nối VPN: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Đóng',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  Future<void> _handleDisconnect() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      await _vpnService.disconnect();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã ngắt kết nối VPN'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi ngắt kết nối: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  void _showVpnPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('VPN Permission Required'),
          content: const Text(
            'This app needs VPN permission to create secure connections.\n\n'
            'Tap OK to grant VPN permission.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Auto grant VPN permission
                _requestVpnPermissionDirectly();
              },
              child: const Text('Grant Permission'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestVpnPermissionDirectly() async {
    try {
      // Request VPN permission through OutlineSdkService
      final outlineSdkService = OutlineSdkService();
      final granted = await outlineSdkService.requestVpnPermission();

      if (granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ VPN permission granted! You can now connect.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Auto retry connection after permission granted
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _handleConnect();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '🚀 VPN permission dialog opened. Please grant permission and try connecting again.',
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting VPN permission: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _openVpnSettings() {
    // This will open the VPN settings page
    // Note: This might not work on all devices
    try {
      // You can implement platform-specific code here to open VPN settings
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please go to Settings > VPN Apps to grant permission'),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please manually go to Android Settings > VPN Apps'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  bool get _isThisKeyConnected {
    return widget.keyData != null &&
        _vpnService.isKeyConnected(widget.keyData!);
  }

  /// Test VPN connection with Outline SDK
  Future<void> _testVpnConnectionWithOutline() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Đang kiểm tra kết nối VPN với Outline SDK...'),
            ],
          ),
        ),
      );

      final outlineService = OutlineSdkService();
      await outlineService.initialize();

      // Test connectivity with Outline SDK
      final connectivityResult = await outlineService.testConnectivity(
        widget.keyData!,
      );

      // Test download speed
      final speedResult = await outlineService.testDownloadSpeed(
        'https://httpbin.org/bytes/1024',
        widget.keyData!,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show detailed result
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              connectivityResult.success
                  ? '✅ VPN Hoạt Động (Outline SDK)'
                  : '❌ VPN Không Hoạt Động',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Connectivity Test:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• TCP: ${connectivityResult.tcpResult.duration}ms'),
                Text('• UDP: ${connectivityResult.udpResult.duration}ms'),
                const SizedBox(height: 8),

                if (speedResult.success) ...[
                  Text(
                    '⚡ Speed Test:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '• Speed: ${speedResult.speedMbps.toStringAsFixed(2)} Mbps',
                  ),
                  Text('• Duration: ${speedResult.duration}ms'),
                  const SizedBox(height: 8),
                ],

                Text(
                  '🔗 Transport: ${connectivityResult.transport.substring(0, 20)}...',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),
              if (connectivityResult.success)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showOutlineFeatures();
                  },
                  child: const Text('Tính năng Outline'),
                ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kiểm tra Outline SDK: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show Outline SDK features
  Future<void> _showOutlineFeatures() async {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🚀 Outline SDK Features'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✨ Available Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• ✅ Shadowsocks Protocol'),
              const Text('• ✅ TCP/UDP Connectivity'),
              const Text('• ✅ DNS Resolution'),
              const Text('• ✅ Local Proxy Server'),
              const Text('• ✅ Speed Testing'),
              const Text('• ✅ URL Fetching'),
              const SizedBox(height: 8),
              const Text(
                '🔧 Powered by Jigsaw-Code/outline-sdk',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final Color dotColor = widget.expired
        ? const Color(0xFFFA3D3D)
        : const Color(0xFF2F6BFF);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main key item row
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  // Key icon with status
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.key,
                            color: Color(0xFF4894FE),
                            size: 24,
                          ),
                        ),
                        if (!widget.expired)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Key info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B2430),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.expired
                              ? t.expired
                              : t.remainDays(
                                  widget.remainDays?.toString() ?? '0',
                                ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: widget.expired
                                ? const Color(0xFFFA3D3D)
                                : const Color(0xFF9AA6B2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quota info
                  Text(
                    widget.quotaText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF394452),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Connect/Disconnect button with VPN integration
                  ValueListenableBuilder<String>(
                    valueListenable: _vpnService.statusNotifier,
                    builder: (context, vpnStatus, child) {
                      final isConnected = _isThisKeyConnected;
                      final isOtherKeyConnected =
                          _vpnService.isConnected && !isConnected;

                      return Column(
                        children: [
                          TextButton(
                            onPressed: _isConnecting
                                ? null
                                : (isConnected
                                      ? _handleDisconnect
                                      : _handleConnect),
                            child: _isConnecting
                                ? const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF4894FE),
                                      ),
                                    ),
                                  )
                                : Text(
                                    isConnected
                                        ? 'Disconnect'
                                        : (isOtherKeyConnected
                                              ? 'Switch'
                                              : t.connect),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: isConnected
                                          ? Colors.red
                                          : (isOtherKeyConnected
                                                ? Colors.orange
                                                : const Color(0xFF4894FE)),
                                    ),
                                  ),
                          ),
                          // Test VPN Traffic Verification Button (only show when connected)
                          if (isConnected)
                            TextButton(
                              onPressed: _testVpnTrafficVerification,
                              child: const Text(
                                '🔍 Test VPN Traffic',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  // Dropdown arrow
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF4894FE),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded)
            KeyDetailsExpansion(
              keyDetails: _keyDetails,
              onServerLocationChanged: (code, country) {
                setState(() {
                  _keyDetails = KeyDetails(
                    name: _keyDetails.name,
                    packageName: _keyDetails.packageName,
                    startDate: _keyDetails.startDate,
                    endDate: _keyDetails.endDate,
                    serverLocation: code,
                    outlineLink: _keyDetails.outlineLink,
                    alternateLink: _keyDetails.alternateLink,
                    quotaText: _keyDetails.quotaText,
                    remainDays: _keyDetails.remainDays,
                    expired: _keyDetails.expired,
                  );
                });
                if (widget.onServerLocationChanged != null) {
                  widget.onServerLocationChanged!(code, country);
                }
              },
            ),
        ],
      ),
    );
  }

  /// Test VPN traffic verification manually
  Future<void> _testVpnTrafficVerification() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Đang kiểm tra VPN traffic...'),
            ],
          ),
        ),
      );

      debugPrint('🔍 Testing VPN traffic verification...');
      final success = await _vpnService.testVpnTrafficVerification();

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show result
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              success ? '✅ VPN Traffic Verified' : '❌ VPN Traffic Failed',
            ),
            content: Text(
              success
                  ? 'All traffic is going through VPN server successfully!'
                  : 'Traffic is NOT going through VPN server. Please check connection.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      debugPrint('❌ VPN traffic verification test error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ VPN verification test error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
