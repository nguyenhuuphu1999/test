import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/top_search_bar.dart';
import 'package:vpncn2_app/widgets/home_tabs.dart';
import 'package:vpncn2_app/widgets/keys_list_section.dart';
import 'package:vpncn2_app/widgets/devices_list_section.dart';
import 'package:vpncn2_app/widgets/activity_feed_list.dart';
import 'package:vpncn2_app/widgets/plans_selection_modal.dart';
import 'package:vpncn2_app/services/vpn_service.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';

class HomeContent extends StatefulWidget {
  final int initialTabIndex; // 0: Key, 1: Device, 2: History

  const HomeContent({super.key, this.initialTabIndex = 0});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late int _selectedTabIndex; // 0: Key, 1: Device, 2: History
  final GlobalKey<KeysListSectionState> _keysListKey =
      GlobalKey<KeysListSectionState>();

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _initializeVpn();
  }

  Future<void> _initializeVpn() async {
    try {
      await VpnService().initialize();
    } catch (e) {
      debugPrint('Failed to initialize VPN service: $e');
    }
  }

  int get _keyCount {
    return _keysListKey.currentState?.count ?? 0;
  }

  void _showPlansModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PlansSelectionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Top search row like screenshot
            TopSearchBar(onChanged: (value) {}),
            const SizedBox(height: 12),

            // Tabs
            HomeTabs(
              selectedIndex: _selectedTabIndex,
              keyCount: _keyCount,
              onChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            const SizedBox(height: 8),

            // Body by tab
            Expanded(child: _buildBodyByTab()),
          ],
        ),

        // Shopping Cart Floating Action Button
        Positioned(
          left: Responsive.width(context, 4),
          bottom: Responsive.height(context, 8),
          child: FloatingActionButton(
            onPressed: _showPlansModal,
            backgroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'asset/images/shopping-cart.png',
              width: Responsive.getFontSize(context, 24),
              height: Responsive.getFontSize(context, 24),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyByTab() {
    switch (_selectedTabIndex) {
      case 0:
        // Key tab
        return KeysListSection(key: _keysListKey);
      case 1:
        // Device tab: inline devices list, keep header/footer same
        return const DevicesListSection();
      case 2:
        // History tab
        return const ActivityFeedList();
      default:
        return KeysListSection(key: _keysListKey);
    }
  }
}
