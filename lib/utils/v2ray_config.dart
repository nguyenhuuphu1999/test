import 'dart:convert';
import '../models/ss_conf.dart';

String buildXrayConfigFromSs(SsConf ss) {
  final config = {
    "log": {"loglevel": "warning"},
    // Inbound SOCKS nội bộ – plugin sẽ nối TUN → SOCKS để bật VPN mode
    "inbounds": [
      {
        "tag": "socks-in",
        "listen": "127.0.0.1",
        "port": 10808,
        "protocol": "socks",
        "settings": {"udp": true},
      },
    ],
    "outbounds": [
      {
        "tag": "ss-out",
        "protocol": "shadowsocks",
        "settings": {
          "servers": [
            {
              "address": ss.server,
              "port": ss.serverPort,
              "method": ss.method, // ví dụ: chacha20-ietf-poly1305
              "password": ss.password,
              "uot": false, // nếu server hỗ trợ UDP-over-TCP thì bật true
            },
          ],
        },
      },
      {"tag": "direct", "protocol": "freedom"},
      {"tag": "block", "protocol": "blackhole"},
    ],
    "routing": {
      "domainStrategy": "IPIfNonMatch",
      "rules": [
        {
          "type": "field",
          "ip": ["geoip:private"],
          "outboundTag": "direct",
        },
      ],
    },
    "dns": {
      "servers": ["1.1.1.1", "8.8.8.8"],
    },
  };

  // Không có chỗ để gắn "prefix" trong Xray SS outbound.
  return json.encode(config);
}
