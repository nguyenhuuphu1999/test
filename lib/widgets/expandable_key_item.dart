import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/models/key_details.dart';
import 'package:vpncn2_app/widgets/key_details_expansion.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;
import 'package:vpncn2_app/services/outline_brigde.dart';

class ExpandableKeyItem extends StatefulWidget {
  final String name;
  final String quotaText;
  final int? remainDays;
  final bool expired;
  final VoidCallback? onConnect;
  final Function(String code, String country)? onServerLocationChanged;
  final KeyEntity.Key? keyData; // Key để hiển thị thông tin; KHÔNG dùng VPN SDK

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
  static const _vpnCh = MethodChannel('vpncn2/vpn_service');

  // Trạng thái kết nối qua proxy nội bộ (MobileProxy)
  bool _isConnecting = false;
  bool _connected = false;
  String? _proxyAddress; // "127.0.0.1:<port>"
  IOClient? _ioClientViaProxy; // để test traffic qua proxy

  late KeyDetails _keyDetails;

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

  // ============== CONNECT ==============
  Future<void> _handleConnect() async {
    if (_connected || _isConnecting) return;
    setState(() => _isConnecting = true);

    try {
      final ok = await OutlineBridge.ensureVpnPermission();
      debugPrint("Ensure VPN permission ok: $ok");
      if (!ok) {
        _toast('Vui lòng cấp quyền VPN để kết nối', isError: true);
        return;
      }

      final res = await OutlineBridge.startSsProxy();
      debugPrint("Start SS proxy res:");
      debugPrint(jsonEncode(res));

      if (res == null || res['success'] != true) {
        throw Exception('Start local proxy failed: ${res?['error']}');
      }

      _proxyAddress = res['address']?.toString();
      debugPrint('✅ Local proxy via SS at $_proxyAddress');

      // Start VPN service with the proxy address
      debugPrint("Starting VPN service...");
      final responseStartVPN = await _vpnCh.invokeMethod('startVpn', {
        'config': '', // Empty config since we're using local proxy
        'port': '1080', // Default port
        'socks_upstream': _proxyAddress, // Proxy address from local proxy
        'per_app': false, // Route all traffic through VPN
      });

      debugPrint("Response start VPN: $responseStartVPN");

      if (responseStartVPN == true) {
        _connected = true;
        _toast('✅ VPN đã kết nối thành công!');
      } else {
        throw Exception('Failed to start VPN service');
      }
    } catch (e) {
      debugPrint('❌ Error connecting to proxy: $e');
      _toast('Lỗi kết nối: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  // ============== DISCONNECT ==============
  Future<void> _handleDisconnect() async {
    if (!_connected) return;
    setState(() => _isConnecting = true);

    try {
      await OutlineBridge.clearWebViewProxy();
      await OutlineBridge.stopLocalProxy();

      _ioClientViaProxy?.close();
      _ioClientViaProxy = null;
      _proxyAddress = null;

      setState(() => _connected = false);
      _toast('Đã ngắt kết nối');
    } catch (e) {
      _toast('Lỗi ngắt kết nối: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  // ============== TEST TRAFFIC ==============
  Future<void> _testProxyTraffic() async {
    if (!_connected || _proxyAddress == null) {
      _toast('Chưa kết nối proxy', isError: true);
      return;
    }

    // Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Đang kiểm tra traffic qua proxy...'),
          ],
        ),
      ),
    );

    try {
      final client =
          _ioClientViaProxy ??
          await OutlineBridge.createHttpClientViaProxy(_proxyAddress!);
      final resp = await client.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );

      if (mounted) Navigator.of(context).pop();

      if (resp.statusCode == 200) {
        final ip = json.decode(resp.body)['ip'];
        _showResultDialog(
          title: '✅ Proxy hoạt động',
          content: 'Public IP qua proxy: $ip',
        );
      } else {
        _showResultDialog(
          title: '❌ Proxy lỗi',
          content: 'HTTP ${resp.statusCode}: ${resp.body}',
          error: true,
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _showResultDialog(
        title: '❌ Proxy lỗi',
        content: e.toString(),
        error: true,
      );
    }
  }

  void _showResultDialog({
    required String title,
    required String content,
    bool error = false,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    OutlineBridge.clearWebViewProxy();
    OutlineBridge.stopLocalProxy();
    _ioClientViaProxy?.close();
    super.dispose();
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
          // Header row (tap to expand)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  // icon
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

                  // info
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

                  // quota
                  Text(
                    widget.quotaText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF394452),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nút Connect/Disconnect (không dùng VpnService nữa)
                  Column(
                    children: [
                      TextButton(
                        onPressed: _isConnecting
                            ? null
                            : (_connected ? _handleDisconnect : _handleConnect),
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
                                _connected ? 'Disconnect' : t.connect,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: _connected
                                      ? Colors.red
                                      : const Color(0xFF4894FE),
                                ),
                              ),
                      ),
                      if (_connected)
                        TextButton(
                          onPressed: _testProxyTraffic,
                          child: const Text(
                            '🔍 Test Proxy Traffic',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 8),
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

          // Expand content
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
                widget.onServerLocationChanged?.call(code, country);
              },
            ),
        ],
      ),
    );
  }
}
