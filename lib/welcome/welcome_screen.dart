import 'package:flutter/material.dart';
import 'package:vpncn2_app/auth/login_screen.dart';
import 'package:vpncn2_app/auth/register_screen.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Main content - centered
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Logo and branding
                              Column(
                                children: [
                                  Image.asset(
                                    'asset/images/logo-vpncn2.png',
                                    width: 198,
                                    height: 231,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Bring You To Freedom Internet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1B2430),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "With Our Encrypted VPN Tunnel, Your Data Stay Safe, Even Over Public Or Untrusted Internet Connections.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF394452),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  // Pagination dots
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _Dot(active: true),
                                      SizedBox(width: 8),
                                      _Dot(active: false),
                                      SizedBox(width: 8),
                                      _Dot(active: false),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Bottom buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4894FE),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text("Create An Account"),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFF4894FE),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;

  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 22 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF9BA7B4) : const Color(0xFFCBD3DA),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
