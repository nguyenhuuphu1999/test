import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/models/key_details.dart';
import 'package:vpncn2_app/widgets/key_details_expansion.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;
import 'package:vpncn2_app/services/outline_brigde.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ExpandableKeyItem extends StatefulWidget {
  final String name;
  final String quotaText;
  final int? remainDays;
  final bool expired;
  final VoidCallback? onConnect;
  final Function(String code, String country)? onServerLocationChanged;
  final KeyEntity.Key? keyData;

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

  // Trạng thái “đã kết nối qua proxy nội bộ”
  bool _connected = false;
  bool _isConnecting = false;
  String? _proxyAddress; // ví dụ "127.0.0.1:54321"
  IOClient? _ioClientForProxy; // HTTP client đi qua proxy

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
      _toast('Không thể kết nối: Thiếu thông tin key', isError: true);
      return;
    }
    if (_connected) return;

    setState(() => _isConnecting = true);

    try {
      // 1) Start local proxy (không VPN)
      // - preferSmart=false: dùng config tĩnh (ví dụ "split:3")
      // - bạn có thể chuyển sang preferSmart=true và truyền strategiesYaml nếu muốn
      // TODO: Fix OutlineBridge.startLocalProxy method
      // final res = await OutlineBridge.startLocalProxy(
      //   preferSmart: false,
      //   config: 'split:3',
      //   bindHost: '127.0.0.1',
      //   port: 0, // hệ thống tự cấp cổng rảnh
      // );

      // TODO: Fix when OutlineBridge.startLocalProxy is implemented
      // if (!res.ok || res.address == null) {
      //   throw Exception('Start local proxy failed: ${res.error}');
      // }

      // TODO: Fix when OutlineBridge.startLocalProxy is implemented
      // _proxyAddress = res.address; // "127.0.0.1:<port>"
      _proxyAddress = "127.0.0.1:8080"; // Temporary placeholder

      // 2) Tạo IOClient đi qua proxy để mọi request HTTP của app đi “đúng như hình”
      _ioClientForProxy = await OutlineBridge.createHttpClientViaProxy(
        _proxyAddress!,
      );

      // 3) (Android) Áp dụng proxy cho tất cả WebView trong app
      await OutlineBridge.applyWebViewProxy(_proxyAddress!);

      setState(() {
        _connected = true;
      });

      // Optional callback
      widget.onConnect?.call();
      _toast('Đã kết nối qua proxy nội bộ: $_proxyAddress');
    } catch (e) {
      _toast('Lỗi kết nối: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  Future<void> _handleDisconnect() async {
    if (!_connected) return;
    setState(() => _isConnecting = true);

    try {
      // Clear WebView proxy và stop proxy nội bộ
      await OutlineBridge.clearWebViewProxy();
      await OutlineBridge.stopLocalProxy();

      _ioClientForProxy?.close();
      _ioClientForProxy = null;
      _proxyAddress = null;

      setState(() {
        _connected = false;
      });
      _toast('Đã ngắt kết nối');
    } catch (e) {
      _toast('Lỗi ngắt kết nối: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  /// Kiểm tra traffic đi qua proxy bằng cách gọi IP echo service qua IOClient
  Future<void> _testProxyTraffic() async {
    if (!_connected || _proxyAddress == null) {
      _toast('Chưa kết nối proxy', isError: true);
      return;
    }

    // Hiển thị loading nhỏ
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
          _ioClientForProxy ??
          await OutlineBridge.createHttpClientViaProxy(_proxyAddress!);
      final resp = await client.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );
      if (mounted) Navigator.of(context).pop();

      if (resp.statusCode == 200) {
        final ip = json.decode(resp.body)['ip'];
        _showResultDialog(
          title: '✅ Proxy đang hoạt động',
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
    // dọn tài nguyên
    OutlineBridge.clearWebViewProxy();
    OutlineBridge.stopLocalProxy();
    _ioClientForProxy?.close();
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
          // Header row
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

                  // Nút Connect/Disconnect (không còn phụ thuộc VpnService)
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
