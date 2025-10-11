import 'package:flutter/foundation.dart';
import '../core/di/simple_injector.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../core/error/result.dart';
import '../core/storage/token_store.dart';

class UserService {
  static User? _currentUser;
  static bool _isInitialized = false;
  static final ValueNotifier<User?> _userNotifier = ValueNotifier<User?>(null);

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      _isInitialized = true;
    }
  }

  // Get current user from cache
  static User? get currentUser => _currentUser;

  // Get user notifier for listening to changes
  static ValueNotifier<User?> get userNotifier => _userNotifier;

  // Get fresh user info from API
  static Future<Result<User>> getCurrentUser() async {
    await initialize();
    final authRepository = sl<AuthRepository>();
    final result = await authRepository.getCurrentUser();

    result.when(
      ok: (user) {
        print('✅ UserService: Setting user: ${user.username}');
        print('✅ UserService: User fullName: ${user.fullName}');
        print('✅ UserService: User money: ${user.money}');
        _currentUser = user;
        _userNotifier.value = user; // Notify listeners
        print('✅ UserService: Notifier value set');
      },
      err: (_) {}, // Keep existing user if API fails
    );

    return result;
  }

  // Update current user (after login)
  static void setCurrentUser(User user) {
    _currentUser = user;
    _userNotifier.value = user; // Notify listeners
  }

  // Clear current user (after logout)
  static void clearCurrentUser() {
    _currentUser = null;
    _userNotifier.value = null; // Notify listeners
  }

  // Sign out - clear all user data and tokens
  static Future<void> signOut() async {
    // Clear tokens from secure storage
    await TokenStore.clearTokens();
    
    // Clear current user data
    clearCurrentUser();
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
