import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/home_content.dart';
import 'package:vpncn2_app/widgets/devices_content.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/screens/payment_screen.dart';

class SmoothMainLayout extends StatefulWidget {
  const SmoothMainLayout({super.key});

  @override
  State<SmoothMainLayout> createState() => _SmoothMainLayoutState();
}

class _SmoothMainLayoutState extends State<SmoothMainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              16, // Status bar + extra padding
          left: Responsive.width(context, 6),
          right: Responsive.width(context, 6),
          bottom: Responsive.height(context, 1.2),
        ),
        child: Column(
          children: [
            // Persistent Header Card - không bao giờ rebuild
            _PersistentHeaderCard(),
            SizedBox(height: Responsive.height(context, 3)),
            // Body content - sử dụng IndexedStack để chuyển mượt mà
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  HomeContent(),
                  DevicesContent(),
                  _PlaceholderContent(), // Placeholder for profile
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: _BottomNavigation(
        activeIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _PersistentHeaderCard extends StatelessWidget {
  const _PersistentHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.width(context, 6)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  AppStrings.greeting,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.getFontSize(context, 20),
                    fontFamily: 'ABeeZee',
                    height: 0.05,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  AppStrings.balance,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.getFontSize(context, 20),
                    fontFamily: 'ABeeZee',
                    height: 0.05,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _HeaderAction(
                icon: Icons.attach_money,
                label: AppStrings.payment,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                ),
              ),
              _HeaderAction(icon: Icons.help_outline, label: AppStrings.faq),
              _HeaderAction(icon: Icons.business, label: AppStrings.buy),
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
  final VoidCallback? onTap;

  const _HeaderAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(Responsive.width(context, 4)),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: Responsive.getFontSize(context, 24),
            ),
          ),
        ),
        SizedBox(height: Responsive.height(context, 1)),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.getFontSize(context, 15),
              fontFamily: 'Poppins',
              height: 0,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _BottomNavigation({required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Responsive.height(context, 2),
        left: Responsive.width(context, 10),
        right: Responsive.width(context, 6),
        bottom: Responsive.height(context, 2),
      ),
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BottomItem(
            imageAsset: 'asset/images/home.png',
            label: '',
            active: activeIndex == 0,
            onTap: () => onTap(0),
          ),
          _BottomItem(
            imageAsset: 'asset/images/cloud.png',
            label: '',
            active: activeIndex == 1,
            onTap: () => onTap(1),
          ),
          _BottomItem(
            imageAsset: 'asset/images/user.png',
            label: '',
            active: activeIndex == 2,
            onTap: () => onTap(2),
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
    final Color color = active ? AppColors.primary : AppColors.disabled;
    final double iconSize = Responsive.getFontSize(context, 34);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (imageAsset != null)
          Image.asset(
            imageAsset!,
            width: iconSize,
            height: iconSize,
            color: color,
          )
        else if (icon != null)
          Icon(icon, color: color, size: iconSize),
        if (label.isNotEmpty)
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: Responsive.getFontSize(context, 12),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${AppStrings.profileContent}\n${AppStrings.comingSoon}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Responsive.getFontSize(context, 18),
          color: AppColors.textSecondary,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
