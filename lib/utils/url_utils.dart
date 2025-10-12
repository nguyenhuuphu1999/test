Uri normalizeSsconfUri(String input) {
  final raw = input.trim();
  if (raw.isEmpty) {
    throw FormatException('URL rỗng');
  }
  Uri u = Uri.parse(raw);

  // Hỗ trợ ssconf://... hoặc https://... (http cũng tạm cho test cục bộ)
  if (u.scheme == 'ssconf') {
    u = u.replace(scheme: 'https');
  } else if (u.scheme != 'https' && u.scheme != 'http') {
    throw FormatException('Scheme không hợp lệ: ${u.scheme}');
  }

  // Nhiều server thêm #tag để hiển thị – bỏ fragment đi
  u = u.replace(fragment: '');

  // Khuyến nghị: URL nên trỏ tới tệp .json
  if (!u.path.endsWith('.json')) {
    throw FormatException('URL nên trỏ tới tệp .json');
  }

  return u;
}
