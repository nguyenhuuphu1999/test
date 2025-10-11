import 'package:freezed_annotation/freezed_annotation.dart';

part 'key.freezed.dart';

@freezed
class Key with _$Key {
  const factory Key({
    required String id,
    required String keyId,
    required String name,
    required String password,
    required int port,
    required String method,
    required String accessUrl,
    required bool enable,
    required bool enableByAdmin,
    required int dataLimit,
    required int dataUsage,
    required int dataExpand,
    required String serverLocation,
    required String serverName,
    required String account,
    required DateTime startDate,
    required DateTime endDate,
    required int status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Key;
}
