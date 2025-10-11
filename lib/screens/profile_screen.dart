import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/constants/app_assets.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/common_header.dart';
import 'package:vpncn2_app/screens/change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: CommonHeader(
        title: AppStrings.myAccount,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Responsive.width(context, 4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User information section
                  _buildInfoSection(),

                  SizedBox(height: Responsive.height(context, 4)),

                  // Basic Account section
                  _buildBasicAccountSection(),

                  SizedBox(height: Responsive.height(context, 4)),

                  // Sign out section
                  _buildSignOutSection(),

                  SizedBox(height: Responsive.height(context, 4)),

                  // Contact section
                  _buildContactSection(),
                ],
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

  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildInfoRow(
          AppStrings.email,
          AppStrings.sampleEmail,
          showArrow: false,
        ),
        _buildInfoRow(
          AppStrings.phone,
          "", // Empty phone number
          showArrow: false,
        ),
        _buildInfoRow(
          AppStrings.username,
          AppStrings.sampleUsername,
          showArrow: false,
        ),
        _buildInfoRow(
          AppStrings.changePassword,
          "",
          showArrow: true,
          onTap: () => _navigateToChangePassword(context),
        ),
        _buildInfoRow(
          AppStrings.transactionHistory,
          "",
          showArrow: true,
          onTap: () => _showComingSoon(context, AppStrings.transactionHistory),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    required bool showArrow,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: Responsive.height(context, 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.getFontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.TEXT_PRIMARY_COLOR,
                ),
              ),
              SizedBox(height: Responsive.height(context, 0.5)),
              Row(
                children: [
                  if (value.isNotEmpty)
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.TEXT_SECONDARY_COLOR,
                        ),
                      ),
                    ),
                  if (showArrow)
                    Image.asset(
                      AppAssets.faqArrow,
                      width: 8,
                      height: 16,
                      color: AppColors.TEXT_SECONDARY_COLOR,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicAccountSection() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.basicAccount,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: AppColors.TEXT_PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: Responsive.height(context, 2)),
          Row(
            children: [
              Image.asset(
                AppAssets.cloudIcon,
                width: 24.94,
                height: 24.94,
                color: AppColors.PRIMARY_COLOR,
              ),
              SizedBox(width: Responsive.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.myAccount,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.TEXT_PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                AppAssets.userIcon,
                width: 20.34,
                height: 20.0,
                color: AppColors.PRIMARY_COLOR,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutSection() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Handle sign out logic
          _showSignOutDialog(context);
        },
        child: Row(
          children: [
            Icon(Icons.logout, size: 20, color: AppColors.ERROR_COLOR),
            SizedBox(width: Responsive.width(context, 3)),
            Text(
              AppStrings.signOut,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 14),
                fontWeight: FontWeight.w400,
                color: AppColors.ERROR_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Builder(
      builder: (context) => Text(
        AppStrings.contactVpncn2,
        style: TextStyle(
          fontSize: Responsive.getFontSize(context, 14),
          fontWeight: FontWeight.w600,
          color: AppColors.TEXT_PRIMARY_COLOR,
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColors.TEXT_PRIMARY_COLOR,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.TEXT_SECONDARY_COLOR),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login screen or clear user session
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: AppColors.ERROR_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            feature,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: AppColors.TEXT_PRIMARY_COLOR,
            ),
          ),
          content: Text(
            AppStrings.comingSoon,
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
