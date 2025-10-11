import 'package:flutter/material.dart';
import 'package:vpncn2_app/services/user_service.dart';
import 'package:vpncn2_app/features/auth/domain/entities/user.dart';

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
      body: Column(
        children: [
          _PersistentHeaderCard(),
          Expanded(child: widget.body),
        ],
      ),
    );
  }
}

class _PersistentHeaderCard extends StatefulWidget {
  @override
  State<_PersistentHeaderCard> createState() => _PersistentHeaderCardState();
}

class _PersistentHeaderCardState extends State<_PersistentHeaderCard> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await UserService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
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
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
