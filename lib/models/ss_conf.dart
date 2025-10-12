import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/url_utils.dart';

class SsConf {
  final String server;
  final int serverPort;
  final String password;
  final String method;
  final String? prefix; // salt prefix (nếu có)

  SsConf({
    required this.server,
    required this.serverPort,
    required this.password,
    required this.method,
    this.prefix,
  });

  factory SsConf.fromJson(Map<String, dynamic> j) => SsConf(
    server: j['server'],
    serverPort: j['server_port'],
    password: j['password'],
    method: j['method'],
    prefix: j['prefix'],
  );
}

Future<SsConf> loadSsConfFromUserInput(String urlInput) async {
  final uri = normalizeSsconfUri(urlInput);
  final resp = await http.get(uri).timeout(const Duration(seconds: 12));
  if (resp.statusCode != 200) {
    throw Exception('Tải cấu hình thất bại: HTTP ${resp.statusCode}');
  }
  final data = json.decode(resp.body);
  if (data is! Map<String, dynamic>) {
    throw Exception('Định dạng JSON không hợp lệ');
  }
  for (final k in ['server', 'server_port', 'password', 'method']) {
    if (!data.containsKey(k) || data[k] == null) {
      throw Exception('Thiếu trường bắt buộc: $k');
    }
  }
  return SsConf.fromJson(data);
}
