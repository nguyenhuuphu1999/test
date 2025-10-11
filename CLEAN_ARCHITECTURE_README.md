# Clean Architecture Implementation

Đây là implementation Clean Architecture cho Flutter app với Dio, get_it và các dependencies cần thiết.

## 🏗️ Cấu trúc thư mục

```
lib/
├─ app/
│  ├─ app.dart                         // MaterialApp, theme, router
│  └─ di/injector.dart                 // get_it: đăng ký dependencies
│
├─ core/
│  ├─ config/
│  │  ├─ env.dart                      // DEV/STG/PROD
│  │  └─ flavor.dart                   // baseUrl theo môi trường
│  ├─ constants/endpoints.dart         // path endpoint
│  ├─ error/
│  │  ├─ failures.dart                 // Failure (Network/Server/Auth…)
│  │  └─ result.dart                   // Result<T> (Ok/Err)
│  ├─ network/
│  │  ├─ dio_client.dart               // tạo Dio + attach interceptors
│  │  ├─ interceptors/
│  │  │  ├─ auth_interceptor.dart      // Bearer token + refresh
│  │  │  ├─ correlation_interceptor.dart // x-correlation-id (uuid)
│  │  │  ├─ device_interceptor.dart    // OS/Version/Model vào header
│  │  │  └─ logging_interceptor.dart   // Log requests/responses
│  │  └─ api_error_mapper.dart         // map DioError -> Failure
│  ├─ storage/
│  │  ├─ secure_storage.dart           // flutter_secure_storage
│  │  └─ token_store.dart              // read/write token
│  └─ utils/platform_info.dart         // đọc OS info
│
├─ features/
│  └─ auth/
│     ├─ data/
│     │  ├─ datasources/auth_api.dart  // gọi Dio
│     │  ├─ models/
│     │  │  ├─ login_request.dart
│     │  │  ├─ register_request.dart
│     │  │  └─ user_dto.dart
│     │  └─ repositories/auth_repository_impl.dart
│     ├─ domain/
│     │  ├─ entities/user.dart
│     │  ├─ repositories/auth_repository.dart
│     │  └─ usecases/
│     │     ├─ login_usecase.dart
│     │     └─ register_usecase.dart
│     └─ presentation/
│        ├─ cubit/auth_cubit.dart
│        └─ cubit/auth_state.dart
│
└─ main.dart
```

## 🚀 Cách sử dụng

### 1. Khởi tạo app

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment
  Env.setEnvironment(Environment.development);
  
  // Initialize dependency injection
  await initDI();
  
  runApp(const App());
}
```

### 2. Sử dụng Auth trong UI

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => const CircularProgressIndicator(),
            authenticated: (user) => Text('Welcome ${user.fullName}'),
            unauthenticated: () => const LoginForm(),
            error: (message) => Text('Error: $message'),
          );
        },
      ),
    );
  }
}
```

### 3. Gọi API từ Repository

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  @override
  Future<Result<User>> login(String username, String password) async {
    try {
      final request = LoginRequest(username: username, password: password);
      final userDto = await _authApi.login(request);
      
      // Save tokens
      if (userDto.accessToken != null) {
        await TokenStore.saveTokens(accessToken: userDto.accessToken!);
      }
      
      return Result.ok(userDto.toEntity());
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString()));
    }
  }
}
```

## 🔧 Features

### ✅ Đã implement:

- **Environment Management**: DEV/STG/PROD configs
- **Network Layer**: Dio với interceptors
- **Error Handling**: Result<T> pattern với Failure types
- **Storage**: Secure storage cho tokens
- **Platform Info**: Device info trong headers
- **Auth Feature**: Complete auth flow
- **Dependency Injection**: get_it setup
- **Code Generation**: Freezed + JSON serialization

### 🔄 Interceptors:

1. **CorrelationInterceptor**: Tự động thêm `x-correlation-id` (UUID)
2. **DeviceInterceptor**: Thêm OS, version, device model vào headers
3. **AuthInterceptor**: Thêm Bearer token, handle 401 errors
4. **LoggingInterceptor**: Log requests/responses (chỉ trong dev)

### 📱 Platform Headers:

```
x-os: android/ios/windows/macos/linux
x-os-version: 13.0
x-device-model: iPhone 14 Pro
x-device-id: unique-device-id
x-correlation-id: uuid-v4
Authorization: Bearer token
```

## 🛠️ Commands

```bash
# Install dependencies
flutter pub get

# Generate code (Freezed, JSON serialization)
flutter packages pub run build_runner build

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes (development)
flutter packages pub run build_runner watch
```

## 🎯 Thêm feature mới

1. **Tạo feature folder** trong `lib/features/`
2. **Implement 3 layers**: data, domain, presentation
3. **Register dependencies** trong `lib/app/di/injector.dart`
4. **Add endpoints** trong `lib/core/constants/endpoints.dart`

## 🔐 Security

- **Secure Storage**: Tokens được lưu trong secure storage
- **Token Management**: Auto refresh và clear expired tokens
- **HTTPS Only**: Tất cả API calls đều qua HTTPS
- **Device Info**: Tracking device để security audit

## 📊 Error Handling

```dart
// Network errors
Result.err(Failure.network(message: 'No internet'))

// Server errors  
Result.err(Failure.server(message: 'Server error', statusCode: 500))

// Auth errors
Result.err(Failure.auth(message: 'Unauthorized'))

// Validation errors
Result.err(Failure.validation(message: 'Invalid email', errors: {...}))
```

## 🚀 Ready to Scale

Architecture này đã sẵn sàng để scale với:
- Multiple environments
- Complex error handling
- Security best practices
- Clean separation of concerns
- Easy testing
- Type safety với Freezed
