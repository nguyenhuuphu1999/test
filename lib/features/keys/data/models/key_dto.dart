import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/key.dart';

part 'key_dto.freezed.dart';
part 'key_dto.g.dart';

@freezed
class KeyDto with _$KeyDto {
  const factory KeyDto({
    @JsonKey(name: '_id') required String id,
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
    required ServerInfo serverId,
    required UserInfo userId,
    required String account,
    required String startDate,
    required String endDate,
    required int status,
    required String createdAt,
    required String updatedAt,
  }) = _KeyDto;

  factory KeyDto.fromJson(Map<String, dynamic> json) => _$KeyDtoFromJson(json);
}

extension KeyDtoX on KeyDto {
  Key toEntity() {
    return Key(
      id: id,
      keyId: keyId,
      name: name,
      password: password,
      port: port,
      method: method,
      accessUrl: accessUrl,
      enable: enable,
      enableByAdmin: enableByAdmin,
      dataLimit: dataLimit,
      dataUsage: dataUsage,
      dataExpand: dataExpand,
      serverLocation: serverId.location,
      serverName: serverId.name,
      account: account,
      startDate: DateTime.tryParse(startDate) ?? DateTime.now(),
      endDate: DateTime.tryParse(endDate) ?? DateTime.now(),
      status: status,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}

@freezed
class ServerInfo with _$ServerInfo {
  const factory ServerInfo({
    @JsonKey(name: '_id') required String id,
    required String location,
    required String name,
  }) = _ServerInfo;

  factory ServerInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerInfoFromJson(json);
}

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    @JsonKey(name: '_id') required String id,
    required String email,
    required String username,
    required int role,
    int? money,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
