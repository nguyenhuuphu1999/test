import 'package:flutter/material.dart';
import 'package:vpncn2_app/core/storage/token_store.dart';
import 'package:vpncn2_app/services/user_service.dart';
import 'package:vpncn2_app/services/auth_service.dart';
import 'package:vpncn2_app/welcome/welcome_screen.dart';
import 'package:vpncn2_app/widgets/smooth_main_layout.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Simple approach: just check if we have a token
      // If we do, assume user is authenticated and let them in
      // If API calls fail later, we can handle it in the app
      final accessToken = await TokenStore.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        // We have a token, load user data first
        print('✅ Token found, loading user data...');
        await _loadUserDataInBackground();

        // Then let user in
        setState(() {
          _isAuthenticated = true;
          _isLoading = false;
        });
      } else {
        // No token, try auto login with default credentials
        print('🔑 No token found, attempting auto login...');
        await _attemptAutoLogin();
      }
    } catch (e) {
      // Error occurred, try auto login as fallback
      print('❌ Error checking auth status, attempting auto login: $e');
      await _attemptAutoLogin();
    }
  }

  Future<void> _attemptAutoLogin() async {
    try {
      print('🔑 Attempting auto login with phunguyen10/12345678...');
      
      final result = await AuthService.login('phunguyen10', '12345678');
      
      result.when(
        ok: (user) async {
          print('✅ Auto login successful! Welcome ${user.fullName}');
          
          // Load user data
          await _loadUserDataInBackground();
          
          // Navigate to home
          setState(() {
            _isAuthenticated = true;
            _isLoading = false;
          });
        },
        err: (failure) {
          print('❌ Auto login failed: ${failure.message}');
          // Auto login failed, show welcome screen
          setState(() {
            _isAuthenticated = false;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      print('❌ Auto login error: $e');
      // Auto login failed, show welcome screen
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserDataInBackground() async {
    // Load user data before navigating to home
    final result = await UserService.getCurrentUser();
    result.when(
      ok: (user) {
        // User data loaded successfully
        print('✅ User data loaded: ${user.fullName}');
      },
      err: (failure) {
        // API failed, but user is still authenticated
        // We'll handle this in the app UI
        print('❌ Failed to load user data: ${failure.message}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ AuthWrapper: build() called');
    print('🏗️ AuthWrapper: _isLoading: $_isLoading');
    print('🏗️ AuthWrapper: _isAuthenticated: $_isAuthenticated');

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking authentication...'),
            ],
          ),
        ),
      );
    }

    if (_isAuthenticated) {
      print('🏗️ AuthWrapper: Navigating to SmoothMainLayout');
      return const SmoothMainLayout();
    } else {
      print('🏗️ AuthWrapper: Navigating to WelcomeScreen');
      return const WelcomeScreen();
    }
  }
}
