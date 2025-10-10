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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 12),
                        // Top auth actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {},
                              child: Text(AppLocalizations.of(context)!.createAccount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {},
                              child: Text(AppLocalizations.of(context)!.signIn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Builder(builder: (context) {
                                final double logoWidth = MediaQuery.of(context).size.width * 0.5;
                                return Center(
                                  child: Image.asset(
                                    'asset/images/logo-vpncn2.png',
                                    width: logoWidth,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.welcomeTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    height: 1.3,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1B2430),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.welcomeSubtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF394452),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Small pager dots mimic
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  _Dot(active: true),
                                  SizedBox(width: 6),
                                  _Dot(active: false),
                                  SizedBox(width: 6),
                                  _Dot(active: false),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // CTA button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4894FE),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.createAccount),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.signIn, style: const TextStyle(color: Color(0xFF4894FE), fontSize: 14, fontWeight: FontWeight.w500)),
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


