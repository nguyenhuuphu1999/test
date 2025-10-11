import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String email,
    required String fullName,
    String? avatar,
    String? phone,
    int? money,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;
}
