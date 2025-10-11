import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/home_content.dart';
import 'package:vpncn2_app/widgets/devices_content.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/screens/payment_screen.dart';
import 'package:vpncn2_app/screens/subscribe_screen.dart';
import 'package:vpncn2_app/screens/faq_screen.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';

class SmoothMainLayout extends StatefulWidget {
  final int initialIndex;

  const SmoothMainLayout({super.key, this.initialIndex = 0});

  @override
  State<SmoothMainLayout> createState() => _SmoothMainLayoutState();
}

class _SmoothMainLayoutState extends State<SmoothMainLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
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
      // Common Footer
      bottomNavigationBar: CommonFooter(
        activeIndex: _currentIndex,
        onTabChanged: (index) {
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
        color: AppColors.PRIMARY_COLOR,
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
              _HeaderAction(
                icon: Icons.help_outline,
                label: AppStrings.faq,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqScreen()),
                ),
              ),
              _HeaderAction(
                icon: Icons.business,
                label: AppStrings.buy,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscribeScreen(),
                  ),
                ),
              ),
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
              color: AppColors.PRIMARY_COLOR,
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
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ],
    );
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
          color: AppColors.TEXT_SECONDARY_COLOR,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
