import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/auth_wrapper.dart';
import 'package:vpncn2_app/auth/login_screen.dart';
import 'package:vpncn2_app/screens/connect_screen.dart';
import 'package:vpncn2_app/screens/demo_screen.dart';
import 'package:vpncn2_app/screens/test_icons_screen.dart';
import 'package:vpncn2_app/home/home_screen.dart';
import 'package:vpncn2_app/screens/devices_screen.dart';
import 'package:vpncn2_app/screens/profile_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/services/auto_logout_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPNCN2',
      navigatorKey:
          AutoLogoutService.navigatorKey, // Add navigator key for auto-logout
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4894FE)),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi'), Locale('zh')],
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/connect': (context) => const ConnectScreen(),
        '/demo': (context) => const DemoScreen(),
        '/test-icons': (context) => const TestIconsScreen(),
        '/home': (context) => const HomeScreen(),
        '/devices': (context) => const DevicesScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
