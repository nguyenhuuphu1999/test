import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_dto.dart';

class AuthApi {
  final DioClient _dioClient;

  AuthApi(this._dioClient);

  Future<UserDto> login(LoginRequest request) async {
    final response = await _dioClient.post(
      Endpoints.login,
      data: request.toJson(),
    );

    // Handle the wrapped response format
    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;

    return UserDto.fromJson(data);
  }

  Future<UserDto> register(RegisterRequest request) async {
    final response = await _dioClient.post(
      Endpoints.register,
      data: request.toJson(),
    );
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserDto> getCurrentUser() async {
    final response = await _dioClient.get(Endpoints.me);

    // Handle the wrapped response format
    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;

    return UserDto.fromJson(data);
  }

  Future<void> forgotPassword(String email) async {
    await _dioClient.post(Endpoints.forgotPassword, data: {'email': email});
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _dioClient.post(
      Endpoints.resetPassword,
      data: {'token': token, 'password': password},
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dioClient.post(
      Endpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }
}
