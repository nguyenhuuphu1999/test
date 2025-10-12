import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ss_conf.dart';
import '../services/outline_sdk_service.dart';
import '../features/keys/domain/entities/key.dart' as KeyEntity;

const _kLastUrlKey = 'last_ssconf_url';

class VpnScreen extends StatefulWidget {
  const VpnScreen({super.key});

  @override
  State<VpnScreen> createState() => _VpnScreenState();
}

class _VpnScreenState extends State<VpnScreen> {
  final OutlineSdkService _outlineService = OutlineSdkService();
  final _urlCtrl = TextEditingController();
  bool _running = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _outlineService.initialize();
    final sp = await SharedPreferences.getInstance();
    _urlCtrl.text = sp.getString(_kLastUrlKey) ?? '';
    setState(() {});
  }

  Future<void> _start() async {
    setState(() {
      _error = null;
    });
    try {
      final url = _urlCtrl.text.trim();
      if (url.isEmpty) throw Exception('Vui lòng nhập URL ssconf trước');

      final sp = await SharedPreferences.getInstance();
      await sp.setString(_kLastUrlKey, url);

      // 1) Tải & parse JSON SS từ URL người dùng nhập
      final ss = await loadSsConfFromUserInput(url);

      // 2) Tạo Key entity từ SS config
      final key = KeyEntity.Key(
        id: 'manual-${DateTime.now().millisecondsSinceEpoch}',
        keyId: 'manual-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Manual Connection',
        serverName: ss.server,
        port: ss.serverPort,
        method: ss.method,
        password: ss.password,
        accessUrl: url,
        fileName: url,
        prefix: ss.prefix,
        ossId: null,
        enable: true,
        enableByAdmin: true,
        dataLimit: 0,
        dataUsage: 0,
        dataExpand: 0,
        serverLocation: 'manual',
        account: 'manual',
        status: 1,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 3) Test connectivity using Outline SDK
      debugPrint('🔍 Testing connectivity with Outline SDK...');
      final connectivityResult = await _outlineService.testConnectivity(key);

      if (connectivityResult.success) {
        debugPrint('✅ Connectivity test passed! Starting connection...');

        // Start local proxy server
        final proxyResult = await _outlineService.startLocalProxy(key);

        if (proxyResult.success) {
          setState(() => _running = true);
          debugPrint(
            '✅ Outline SDK: Connection successful on port ${proxyResult.localPort}',
          );
        } else {
          throw Exception(
            'Không thể khởi động proxy server: ${proxyResult.error}',
          );
        }
      } else {
        throw Exception(
          'Kiểm tra kết nối thất bại: TCP=${connectivityResult.tcpResult.error}, UDP=${connectivityResult.udpResult.error}',
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _running = false;
      });
    }
  }

  Future<void> _stop() async {
    await _outlineService.stopLocalProxy();
    setState(() => _running = false);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    // OutlineSdkService doesn't need explicit disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN Connection'),
        backgroundColor: const Color(0xFF4894FE),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // URL Input
            TextField(
              controller: _urlCtrl,
              decoration: const InputDecoration(
                labelText: 'Nhập URL ssconf',
                hintText:
                    'ssconf://oss.vpncn2.net/.../config.json#optional-tag',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              autofillHints: const [AutofillHints.url],
            ),

            const SizedBox(height: 20),

            // Connection Button
            ElevatedButton(
              onPressed: _running ? _stop : _start,
              style: ElevatedButton.styleFrom(
                backgroundColor: _running
                    ? Colors.red
                    : const Color(0xFF4894FE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _running ? 'Ngắt kết nối' : 'Kết nối VPN',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Status Card
            Card(
              color: _running ? Colors.green.shade50 : Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _running ? Icons.vpn_key : Icons.vpn_key_outlined,
                      color: _running ? Colors.green : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _running ? 'Đang kết nối VPN' : 'Chưa kết nối',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _running ? Colors.green : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _running
                                ? 'Traffic đang được định tuyến qua VPN'
                                : 'Nhập URL ssconf và nhấn kết nối',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Error Message
            if (_error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Lưu ý quan trọng',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Sử dụng Outline SDK cho kết nối Shadowsocks\n'
                      '• Hỗ trợ TCP/UDP và DNS resolution\n'
                      '• URL sẽ được lưu tự động cho lần sử dụng sau\n'
                      '• Kết nối qua local proxy server',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
