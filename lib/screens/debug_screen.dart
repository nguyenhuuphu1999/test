import 'package:flutter/material.dart';
import 'package:vpncn2_app/core/storage/token_store.dart';
import 'package:vpncn2_app/services/user_service.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _debugInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    final accessToken = await TokenStore.accessToken;
    final refreshToken = await TokenStore.refreshToken;
    final hasValidToken = await TokenStore.hasValidToken;

    setState(() {
      _debugInfo =
          '''
Token Debug Info:
================
Access Token: ${accessToken != null ? '${accessToken.substring(0, 20)}...' : 'null'}
Refresh Token: ${refreshToken != null ? '${refreshToken.substring(0, 20)}...' : 'null'}
Has Valid Token: $hasValidToken

Current User: ${UserService.currentUser?.fullName ?? 'null'}
Is Logged In: ${UserService.isLoggedIn}
Display Name: ${UserService.displayName}
Money Display: ${UserService.moneyDisplay}
''';
    });
  }

  Future<void> _testGetCurrentUser() async {
    setState(() {
      _debugInfo = 'Testing getCurrentUser...';
    });

    try {
      final result = await UserService.getCurrentUser();
      result.when(
        ok: (user) {
          setState(() {
            _debugInfo =
                '✅ getCurrentUser Success:\n${user.fullName}\n${user.email}';
          });
        },
        err: (failure) {
          setState(() {
            _debugInfo = '❌ getCurrentUser Failed:\n${failure.message}';
          });
        },
      );
    } catch (e) {
      setState(() {
        _debugInfo = '❌ Exception:\n$e';
      });
    }
  }

  Future<void> _clearTokens() async {
    await TokenStore.clearTokens();
    _loadDebugInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Screen'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_debugInfo, style: const TextStyle(fontFamily: 'monospace')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadDebugInfo,
              child: const Text('Refresh Debug Info'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testGetCurrentUser,
              child: const Text('Test getCurrentUser'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearTokens,
              child: const Text('Clear Tokens'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
