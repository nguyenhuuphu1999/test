import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/storage/token_store.dart';
import 'user_service.dart';
import 'vpn_service.dart';

class AutoLogoutService {
  static final AutoLogoutService _instance = AutoLogoutService._internal();
  factory AutoLogoutService() => _instance;
  AutoLogoutService._internal();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Perform complete logout and navigate to login screen
  static Future<void> performAutoLogout({
    String? reason,
    bool showMessage = true,
  }) async {
    try {
      debugPrint('🚪 Starting auto-logout process...');
      debugPrint('📝 Reason: ${reason ?? "Unauthorized (401)"}');

      // 1. Stop VPN connection if active
      try {
        await VpnService().disconnect();
        debugPrint('✅ VPN disconnected');
      } catch (e) {
        debugPrint('⚠️ VPN disconnect failed: $e');
      }

      // 2. Clear user data
      await UserService.signOut();
      debugPrint('✅ User data cleared');

      // 3. Clear tokens
      await TokenStore.clearTokens();
      debugPrint('✅ Tokens cleared');

      // 4. Clear cached data
      await _clearCachedData();
      debugPrint('✅ Cached data cleared');

      // 5. Navigate to login screen
      await _navigateToLogin(reason, showMessage);
      debugPrint('✅ Navigation completed');

      debugPrint('🎯 Auto-logout completed successfully');
    } catch (e) {
      debugPrint('❌ Auto-logout failed: $e');
      // Even if logout fails partially, still clear tokens and navigate
      await TokenStore.clearTokens();
      await _navigateToLogin(reason, showMessage);
    }
  }

  /// Clear all cached data
  static Future<void> _clearCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear VPN related data
      await prefs.remove('connected_key_id');
      await prefs.remove('connected_key_name');
      await prefs.remove('last_ssconf_url');

      // Clear any other cached data
      await prefs.remove('user_preferences');
      await prefs.remove('last_login_time');

      debugPrint('✅ All cached data cleared');
    } catch (e) {
      debugPrint('⚠️ Failed to clear cached data: $e');
    }
  }

  /// Navigate to login screen with optional message
  static Future<void> _navigateToLogin(String? reason, bool showMessage) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('⚠️ Navigator context not available');
      return;
    }

    try {
      // Show message if requested
      if (showMessage && reason != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getLogoutMessage(reason)),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Navigate to login screen
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

      debugPrint('✅ Navigated to login screen');
    } catch (e) {
      debugPrint('❌ Navigation failed: $e');
      // Fallback: try to push login screen
      try {
        Navigator.of(context).pushReplacementNamed('/login');
      } catch (e2) {
        debugPrint('❌ Fallback navigation also failed: $e2');
      }
    }
  }

  /// Get appropriate logout message based on reason
  static String _getLogoutMessage(String reason) {
    switch (reason.toLowerCase()) {
      case 'unauthorized':
      case '401':
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case 'token_expired':
        return 'Token đã hết hạn. Vui lòng đăng nhập lại.';
      case 'invalid_token':
        return 'Token không hợp lệ. Vui lòng đăng nhập lại.';
      default:
        return 'Đã tự động đăng xuất. Vui lòng đăng nhập lại.';
    }
  }

  /// Check if user should be logged out (for periodic checks)
  static Future<bool> shouldAutoLogout() async {
    try {
      final token = await TokenStore.accessToken;
      return token == null || token.isEmpty;
    } catch (e) {
      debugPrint('⚠️ Error checking auto-logout status: $e');
      return true;
    }
  }

  /// Perform logout with UI feedback
  static Future<void> logoutWithFeedback({
    String? reason,
    BuildContext? context,
  }) async {
    if (context != null) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Đang đăng xuất...'),
            ],
          ),
        ),
      );

      // Perform logout
      await performAutoLogout(reason: reason, showMessage: true);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      // Perform logout without UI
      await performAutoLogout(reason: reason, showMessage: false);
    }
  }
}
