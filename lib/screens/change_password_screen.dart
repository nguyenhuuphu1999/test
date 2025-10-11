import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _reNewPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureReNewPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _reNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: CommonHeader(
        title: AppStrings.changePassword,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.width(context, 4)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructions
                    Text(
                      'Enter your current password and choose a new password.',
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 14),
                        color: AppColors.TEXT_SECONDARY_COLOR,
                      ),
                    ),

                    SizedBox(height: Responsive.height(context, 2)),

                    // Current Password Field
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      label: AppStrings.currentPassword,
                      obscureText: _obscureCurrentPassword,
                      onToggleObscure: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: Responsive.height(context, 2)),

                    // New Password Field
                    _buildPasswordField(
                      controller: _newPasswordController,
                      label: AppStrings.newPassword,
                      obscureText: _obscureNewPassword,
                      onToggleObscure: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: Responsive.height(context, 2)),

                    // Re-enter New Password Field
                    _buildPasswordField(
                      controller: _reNewPasswordController,
                      label: AppStrings.reNewPassword,
                      obscureText: _obscureReNewPassword,
                      onToggleObscure: () {
                        setState(() {
                          _obscureReNewPassword = !_obscureReNewPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: Responsive.height(context, 4)),

                    // Update Password Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                AppStrings.updatePassword,
                                style: TextStyle(
                                  fontSize: Responsive.getFontSize(context, 16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer
          CommonFooter(
            onTabChanged: (index) {
              // This won't be called since we're using context navigation
            },
            context: context,
            activeIndex: 2, // User tab is active
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: AppColors.TEXT_PRIMARY_COLOR,
          ),
        ),
        SizedBox(height: Responsive.height(context, 1)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 16),
            color: AppColors.TEXT_PRIMARY_COLOR,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.BORDER_COLOR, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.BORDER_COLOR, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.PRIMARY_COLOR, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.ERROR_COLOR, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.ERROR_COLOR, width: 2),
            ),
            filled: true,
            fillColor: AppColors.SURFACE_COLOR,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 4),
              vertical: Responsive.height(context, 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.TEXT_SECONDARY_COLOR,
                size: 20,
              ),
              onPressed: onToggleObscure,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success dialog
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      // Show error dialog
      if (mounted) {
        _showErrorDialog('Failed to update password. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: Responsive.width(context, 2)),
              Text(
                AppStrings.passwordChanged,
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.TEXT_PRIMARY_COLOR,
                ),
              ),
            ],
          ),
          content: Text(
            AppStrings.passwordChangedSuccessfully,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to profile screen
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: AppColors.ERROR_COLOR, size: 24),
              SizedBox(width: Responsive.width(context, 2)),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.TEXT_PRIMARY_COLOR,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
