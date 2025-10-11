import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final int activeIndex; // 0: home, 1: cloud, 2: user

  const MainLayout({super.key, required this.body, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            children: [
              // Header Card
              _HeaderCard(),
              const SizedBox(height: 24),
              // Body content
              Expanded(child: body),
            ],
          ),
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: _BottomNavigation(activeIndex: activeIndex),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF4894FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hi, Manhnt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'ABeeZee',
                  height: 0.05,
                ),
              ),
              Text(
                '20\$',
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
