import '../core/di/simple_injector.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../core/error/result.dart';

class UserService {
  static User? _currentUser;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      _isInitialized = true;
    }
  }

  // Get current user from cache
  static User? get currentUser => _currentUser;

  // Get fresh user info from API
  static Future<Result<User>> getCurrentUser() async {
    await initialize();
    final authRepository = sl<AuthRepository>();
    final result = await authRepository.getCurrentUser();

    result.when(
      ok: (user) => _currentUser = user,
      err: (_) {}, // Keep existing user if API fails
    );

    return result;
  }

  // Update current user (after login)
  static void setCurrentUser(User user) {
    _currentUser = user;
  }

  // Clear current user (after logout)
  static void clearCurrentUser() {
    _currentUser = null;
  }

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // Get user display name
  static String get displayName =>
      _currentUser?.fullName ?? _currentUser?.username ?? 'User';

  // Get user email
  static String get email => _currentUser?.email ?? '';

  // Get user money (if available from API)
  static String get moneyDisplay {
    if (_currentUser == null) return '\$0';
    return '\$${_currentUser!.money ?? 0}';
  }
}
