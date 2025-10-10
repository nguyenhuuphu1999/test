import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/widgets/auth_header.dart';
import 'package:vpncn2_app/widgets/auth_text_field.dart';
import 'package:vpncn2_app/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          t.registerTitle,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1B2430)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const AuthHeader(title: '', subtitle: ''),
                      const SizedBox(height: 16),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _LabeledField(label: t.userName, child: AuthTextField(controller: userNameController, hintText: t.userName, validator: (v) => (v==null||v.isEmpty) ? 'Required' : null)),
                            const SizedBox(height: 12),
                            _LabeledField(label: t.fullName, child: AuthTextField(controller: fullNameController, hintText: t.fullName, validator: (v) => (v==null||v.isEmpty) ? 'Required' : null)),
                            const SizedBox(height: 12),
                            _LabeledField(label: t.email, child: AuthTextField(controller: emailController, hintText: t.email, keyboardType: TextInputType.emailAddress, validator: (v) => (v==null||v.isEmpty) ? 'Required' : null)),
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: t.password,
                              child: AuthTextField(
                                controller: passwordController,
                                hintText: t.password,
                                obscureText: obscurePassword,
                                suffixIcon: IconButton(icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscurePassword = !obscurePassword)),
                                validator: (v) { if (v==null||v.isEmpty) return 'Required'; if (v.length<6) return 'Password too short'; return null; },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: t.confirmPassword,
                              child: AuthTextField(
                                controller: confirmPasswordController,
                                hintText: t.confirmPassword,
                                obscureText: obscureConfirm,
                                suffixIcon: IconButton(icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => obscureConfirm = !obscureConfirm)),
                                validator: (v) { if (v==null||v.isEmpty) return 'Required'; if (v != passwordController.text) return 'Passwords do not match'; return null; },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(onPressed: () {}, child: Text(t.forgetPassword, style: const TextStyle(color: Color(0xFF394452)))),
                      ),
                      const SizedBox(height: 8),
                      PrimaryButton(label: t.register, onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registering...')));
                        }
                      }),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${t.haveAccount} '),
                          TextButton(onPressed: () { Navigator.of(context).pop(); }, child: Text(t.signIn, style: const TextStyle(color: Color(0xFF4894FE)))),
                        ],
                      ),
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



