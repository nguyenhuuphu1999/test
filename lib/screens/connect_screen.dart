import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/top_search_bar.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';
import 'package:vpncn2_app/widgets/key_summary_header.dart';
import 'package:vpncn2_app/widgets/location_availability_tile.dart';
import 'package:vpncn2_app/widgets/change_server_row.dart';
import 'package:vpncn2_app/widgets/change_location_modal.dart';
import 'package:vpncn2_app/widgets/earth_rotating.dart';
import 'package:vpncn2_app/services/keys_service.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;

class ConnectScreen extends StatefulWidget {
  final String? keyId; // Optional: pass selected key id
  const ConnectScreen({super.key, this.keyId});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  KeyEntity.Key? _keyDetail;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchKeyDetailIfPossible();
  }

  Future<void> _fetchKeyDetailIfPossible() async {
    final keyId = widget.keyId;
    if (keyId == null || keyId.isEmpty) return;
    setState(() => _loading = true);
    final res = await KeysService.getKeyDetailV2(keyId);
    res.when(
      ok: (k) {
        setState(() {
          _keyDetail = k;
          _loading = false;
        });
      },
      err: (f) {
        setState(() => _loading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(f.message ?? 'Load key detail failed')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      bottomNavigationBar: CommonFooter(
        activeIndex: 1,
        onTabChanged: (_) {},
        context: context,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.width(context, 6),
            vertical: Responsive.height(context, 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Reuse TopSearchBar in title mode
              TopSearchBar(
                onChanged: (_) {},
                centerChild: Text(
                  'VPNCN2',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.TEXT_PRIMARY_COLOR,
                  ),
                ),
                onLeftIconPressed: () {},
                onRightIconPressed: () {},
              ),

              SizedBox(height: Responsive.height(context, 1.5)),

              // Key card
              _KeySummaryCard(keyDetail: _keyDetail, loading: _loading),

              SizedBox(height: Responsive.height(context, 1.5)),

              // Country and availability row
              _CountryAvailabilityRow(keyDetail: _keyDetail),
              SizedBox(height: Responsive.height(context, 1.5)),

              // Download/Upload row
              _TrafficRow(),

              SizedBox(height: Responsive.height(context, 1.5)),

              // Globe + current city bubble
              Expanded(
                child: _GlobeSection(locationName: _keyDetail?.serverLocation),
              ),

              SizedBox(height: Responsive.height(context, 1.2)),

              // Connected time
              _ConnectedTime(),

              SizedBox(height: Responsive.height(context, 1.5)),

              // Change server row
              ChangeServerRow(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ChangeLocationModal(
                      keyId: widget.keyId ?? '',
                      deviceName: 'This Device',
                    ),
                  );
                },
              ),

              SizedBox(height: Responsive.height(context, 1.5)),

              // Bottom connect bar
              // _BottomConnectBar(),
              SizedBox(height: Responsive.height(context, 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeySummaryCard extends StatelessWidget {
  final KeyEntity.Key? keyDetail;
  final bool loading;

  const _KeySummaryCard({
    super.key,
    required this.keyDetail,
    required this.loading,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: loading
            ? const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator()),
              )
            : KeySummaryHeader(
                keyName: keyDetail?.name ?? '---',
                expireText: keyDetail?.endDate != null
                    ? 'Expire: ${keyDetail!.endDate.toLocal().toString().split(' ').first}'
                    : 'Expire: --',
                usageText:
                    'Used: ${(keyDetail?.dataUsage ?? 0) ~/ (1024 * 1024)} MB   Limit: ${(keyDetail?.dataLimit ?? 0) ~/ (1024 * 1024 * 1024)} GB',
                onActionPressed: () {},
              ),
      ),
    );
  }
}

class _CountryAvailabilityRow extends StatelessWidget {
  final KeyEntity.Key? keyDetail;
  const _CountryAvailabilityRow({super.key, this.keyDetail});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LocationAvailabilityTile(
          country: keyDetail?.serverName ?? 'Unknown Server',
          city: keyDetail?.serverLocation ?? 'Unknown',
          availabilityText: '—',
        ),
      ),
    );
  }
}

class _TrafficRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _TrafficTile(
            title: 'download :',
            value: '527 MB',
            icon: Icons.download,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _TrafficTile(
            title: 'upload :',
            value: '49 MB',
            icon: Icons.upload,
          ),
        ),
      ],
    );
  }
}

class _TrafficTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _TrafficTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.PRIMARY_COLOR),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobeSection extends StatelessWidget {
  final String? locationName;
  const _GlobeSection({super.key, this.locationName});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Leave room for labels (reserve ~56 px to be safe across font scales)
        final available = constraints.maxHeight;
        final reservedForLabels = 56.0;
        final earthSize = (available - reservedForLabels).clamp(100.0, 220.0);

        return Column(
          children: [
            SizedBox(
              width: earthSize,
              height: earthSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: earthSize * 0.9,
                    height: earthSize * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.12),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  EarthRotating(size: earthSize),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                Text(locationName ?? '—', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 2),
                const Text('—', style: TextStyle(fontSize: 11)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ConnectedTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Connected Time',
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 12),
            color: AppColors.SUCCESS_COLOR,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '02',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Text(
              ':',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Text(
              '41',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Text(
              ':',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Text(
              '52',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

// moved to widgets/change_server_row.dart
