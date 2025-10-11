import 'package:flutter/material.dart';
import 'package:vpncn2_app/auth/reset_password_screen.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/widgets/auth_text_field.dart';
import 'package:vpncn2_app/widgets/primary_button.dart';
import 'package:vpncn2_app/widgets/auth_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      // cho phép body đẩy lên khi bàn phím mở
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              // có thể cuộn khi màn hình ngắn / bàn phím mở
              padding: EdgeInsets.only(bottom: bottomInset),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                // giúp nội dung tối thiểu bằng chiều cao viewport để dễ căn
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Header
                      AuthHeader(
                        title: t.forgotTitle,
                        subtitle: t.forgotSubtitle,
                      ),
                      const SizedBox(height: 16),

                      // Form
                      Form(
                        key: formKey,
                        child: AuthTextField(
                          controller: emailController,
                          hintText: t.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Đẩy nút xuống đáy khi đủ cao, vẫn cuộn được khi thiếu chỗ
                      const Spacer(),

                      PrimaryButton(
                        label: t.sendResetLink,
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ResetPasswordScreen(),
                              ),
                            );
                          }
                        },
                        height: 52,
                      ),

                      const SizedBox(height: 12),
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
