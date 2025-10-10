import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/widgets/auth_header.dart';
import 'package:vpncn2_app/widgets/auth_text_field.dart';
import 'package:vpncn2_app/widgets/primary_button.dart';
import 'package:vpncn2_app/auth/register_screen.dart';
import 'package:vpncn2_app/auth/forgot_password_screen.dart';
import 'package:vpncn2_app/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              const SizedBox(height: 12),
              AuthHeader(title: AppLocalizations.of(context)!.helloAgain, subtitle: AppLocalizations.of(context)!.welcomeBack),
              const SizedBox(height: 24),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _LabeledField(label: AppLocalizations.of(context)!.usernameOrEmail, child: AuthTextField(controller: emailController, hintText: AppLocalizations.of(context)!.usernameOrEmail, keyboardType: TextInputType.emailAddress, validator: (value) { if (value == null || value.trim().isEmpty) return 'Please enter email or username'; return null; })),
                    const SizedBox(height: 12),
                    _LabeledField(label: AppLocalizations.of(context)!.password, child: AuthTextField(controller: passwordController, hintText: AppLocalizations.of(context)!.password, obscureText: obscurePassword, suffixIcon: IconButton(icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscurePassword = !obscurePassword)), validator: (value) { if (value == null || value.isEmpty) return 'Please enter password'; if (value.length < 6) return 'Password too short'; return null; })),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.forgetPassword, style: const TextStyle(color: Color(0xFF394452))),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: AppLocalizations.of(context)!.signIn,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  }
                },
                height: 52,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${AppLocalizations.of(context)!.dontHaveAccount} '),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.signUp, style: const TextStyle(color: Color(0xFF4894FE))),
                  ),
                ],
              ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD8E0E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4894FE)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        child,
      ],
    );
  }
}


