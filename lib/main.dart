import 'package:flutter/material.dart';
import 'package:vpncn2_app/welcome/welcome_screen.dart';
import 'package:vpncn2_app/widgets/smooth_main_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPNCN2',
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
      home: const WelcomeScreen(),
      routes: {'/home': (context) => const SmoothMainLayout()},
    );
  }
}
