import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String email;
  final String username;
  final int role;
  final int money;
  // Login response fields (optional for /auth/me response)
  final String? accessToken;
  final String? refreshToken;
  final String? expiresIn;
  @JsonKey(name: '__v')
  final int? v;
  final int? cash;
  final String? createdAt;
  final String? updatedAt;
  final int? level;
  final int? purpose;
  final int? transaction;
  @JsonKey(name: '_id')
  final String? mongoId;

  const UserDto({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.money,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.v,
    this.cash,
    this.createdAt,
    this.updatedAt,
    this.level,
    this.purpose,
    this.transaction,
    this.mongoId,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      fullName: username, // Use username as fullName
      avatar: null,
      phone: null,
      money: money,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}
