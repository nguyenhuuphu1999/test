import 'package:flutter/material.dart';
import 'package:vpncn2_app/services/user_service.dart';

class PersistentMainLayout extends StatefulWidget {
  final Widget body;
  final int activeIndex; // 0: home, 1: cloud, 2: user

  const PersistentMainLayout({
    super.key,
    required this.body,
    required this.activeIndex,
  });

  @override
  State<PersistentMainLayout> createState() => _PersistentMainLayoutState();
}

class _PersistentMainLayoutState extends State<PersistentMainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            children: [
              // Persistent Header Card - không bao giờ rebuild
              _PersistentHeaderCard(),
              const SizedBox(height: 24),
              // Body content - chỉ phần này thay đổi
              Expanded(child: widget.body),
            ],
          ),
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: _BottomNavigation(activeIndex: widget.activeIndex),
    );
  }
}

class _PersistentHeaderCard extends StatefulWidget {
  const _PersistentHeaderCard();

  @override
  State<_PersistentHeaderCard> createState() => _PersistentHeaderCardState();
}

class _PersistentHeaderCardState extends State<_PersistentHeaderCard> {
  @override
  void initState() {
    super.initState();
    print('🏗️ Header: initState called');
    print('🏗️ Header: Current user: ${UserService.currentUser?.username}');
    
    // Load user data when header is created
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Get fresh user data from API
    await UserService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 Header: build() called');
    print('🎨 Header: displayName: ${UserService.displayName}');
    print('🎨 Header: moneyDisplay: ${UserService.moneyDisplay}');
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF4894FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<User?>(
        valueListenable: UserService.userNotifier,
        builder: (context, user, child) {
          print('🔄 ValueListenableBuilder: user: ${user?.username}');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, ${UserService.displayName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'ABeeZee',
                      height: 0.05,
                    ),
                  ),
                  Text(
                    UserService.moneyDisplay,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'ABeeZee',
                      height: 0.05,
                    ),
                  ),
                ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _HeaderAction(icon: Icons.attach_money, label: 'Payment'),
                    _HeaderAction(icon: Icons.help_outline, label: 'FAQ'),
                    _HeaderAction(icon: Icons.business, label: 'Buy'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: CircleBorder(),
          ),
          child: Icon(icon, color: const Color(0xFF4894FE), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Poppins',
            height: 0,
          ),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int activeIndex;

  const _BottomNavigation({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 39, right: 24, bottom: 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BottomItem(
            imageAsset: 'asset/images/home.png',
            label: '',
            active: activeIndex == 0,
            onTap: () {
              // Navigate to home
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
          ),
          _BottomItem(
            imageAsset: 'asset/images/cloud.png',
            label: '',
            active: activeIndex == 1,
            onTap: () {
              // Navigate to devices
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/devices',
                (route) => false,
              );
            },
          ),
          _BottomItem(
            imageAsset: 'asset/images/user.png',
            label: '',
            active: activeIndex == 2,
            onTap: () {
              // Navigate to user profile
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/profile',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _BottomItem({
    this.icon,
    this.imageAsset,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = active
        ? const Color(0xFF4894FE)
        : const Color(0xFF9AA6B2);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (imageAsset != null)
          Image.asset(imageAsset!, width: 34, height: 34, color: color)
        else if (icon != null)
          Icon(icon, color: color, size: 34),
        if (label.isNotEmpty) Text(label, style: TextStyle(color: color)),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
