import 'package:flutter/material.dart';
import 'package:vpncn2_app/services/user_service.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Username'),
                      subtitle: Text(UserService.displayName),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(UserService.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: const Text('Balance'),
                      subtitle: Text(UserService.moneyDisplay),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Menu Items
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change Password tapped')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Transaction History'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction History tapped'),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Basic Account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Basic Account tapped')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSignOutDialog(),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.contact_support),
                    title: const Text('Contact VPNCN2'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact VPNCN2 tapped')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Extra space for pull-to-refresh
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Refresh user data
    await UserService.getCurrentUser();

    // Simulate refreshing profile data
    await Future.delayed(const Duration(seconds: 1));

    // You can add API calls here to refresh profile data
    // For now, we'll just show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile screen refreshed!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleSignOut();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignOut() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Sign out user
      await UserService.signOut();

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Navigate to login screen
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
