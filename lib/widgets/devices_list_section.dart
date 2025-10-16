import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/widgets/add_device_form.dart';
import 'package:vpncn2_app/features/devices/domain/entities/device.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/device_key_style_card.dart';
import 'package:vpncn2_app/services/user_service.dart';
import 'package:vpncn2_app/services/devices_service.dart';
import 'package:vpncn2_app/widgets/assign_vpn_package_modal.dart';
import 'package:vpncn2_app/widgets/change_location_modal.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';

class DevicesListSection extends StatefulWidget {
  const DevicesListSection({super.key});

  @override
  State<DevicesListSection> createState() => _DevicesListSectionState();
}

class _DevicesListSectionState extends State<DevicesListSection>
    with ErrorHandlerMixin {
  late List<Map<String, dynamic>> devices;
  bool _loading = false;
  bool _loadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    devices = [];
    _scrollController.addListener(_onScroll);
    _loadDevices(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreDevices();
    }
  }

  Future<void> _loadDevices({bool isRefresh = false}) async {
    if (_loading && !isRefresh) return;

    setState(() {
      _loading = true;
      if (isRefresh) {
        _currentPage = 1;
        devices = [];
      }
    });

    final res = await DevicesService.getDevices(
      page: _currentPage,
      limit: _pageSize,
    );

    handleApiResult(
      res,
      onSuccess: (tuple) {
        final list = tuple.$1;
        final currentPage = tuple.$2;
        final totalPages = tuple.$3;

        final newDevices = list
            .map(
              (e) => {
                'id': e.id,
                'name': e.deviceName,
                'ssid': e.ssidRouter,
                'isOnline': e.routerStatus.toUpperCase() == 'ONLINE',
                'isVpnConnected': e.vpnStatus.toUpperCase() == 'ENABLED',
                'currentPackage': '',
              },
            )
            .toList();

        setState(() {
          if (isRefresh) {
            devices = newDevices;
          } else {
            devices.addAll(newDevices);
          }
          _currentPage = currentPage;
          _totalPages = totalPages;
          _loading = false;
        });
      },
      onRetry: () => _loadDevices(isRefresh: isRefresh),
    );
  }

  Future<void> _loadMoreDevices() async {
    if (_loadingMore || _currentPage >= _totalPages) return;

    setState(() {
      _loadingMore = true;
    });

    _currentPage++;
    await _loadDevices(isRefresh: false);

    setState(() {
      _loadingMore = false;
    });
  }

  Future<void> _onRefresh() async {
    await UserService.getCurrentUser();
    await _loadDevices(isRefresh: true);
    if (!mounted) return;
    showSuccess('Devices list refreshed!');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : devices.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: Responsive.height(context, 2),
                bottom: Responsive.height(context, 2),
              ),
              itemCount: devices.length + 1 + (_loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the bottom when loading more
                if (index == devices.length + (_loadingMore ? 1 : 0)) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.height(context, 2),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final created = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (_) => const AddDeviceForm(),
                          );
                          if (created == true) {
                            _onRefresh();
                          }
                        },
                        child: Container(
                          width: Responsive.getFontSize(context, 42),
                          height: Responsive.getFontSize(context, 42),
                          decoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: Responsive.getFontSize(context, 24),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Show loading more indicator
                if (index == devices.length && _loadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final device = devices[index];
                return DeviceKeyStyleCard(
                  deviceName: device['name'],
                  ssidName: device['ssid'],
                  location: 'US: 102.101.102.101', // Mock location for now
                  isOnline: device['isOnline'],
                  isVpnConnected: device['isVpnConnected'],
                  onConnect: () async {
                    final deviceId = device['id']?.toString() ?? '';
                    final isCurrentlyConnected =
                        device['isVpnConnected'] as bool;

                    // Show loading state
                    setState(() {
                      device['isVpnConnected'] = !isCurrentlyConnected;
                    });

                    // Call appropriate API
                    final result = isCurrentlyConnected
                        ? await DevicesService.turnOffVpn(deviceId)
                        : await DevicesService.turnOnVpn(deviceId);

                    handleApiResultWithSuccess(
                      result,
                      onSuccess: (_) {
                        // Success - state already updated
                      },
                      successMessage: isCurrentlyConnected
                          ? 'VPN turned off successfully'
                          : 'VPN turned on successfully',
                      onRetry: () async {
                        // Retry the VPN toggle operation
                        final retryResult = isCurrentlyConnected
                            ? await DevicesService.turnOffVpn(deviceId)
                            : await DevicesService.turnOnVpn(deviceId);

                        retryResult.when(
                          ok: (_) {
                            setState(() {
                              device['isVpnConnected'] = !isCurrentlyConnected;
                            });
                            showSuccess(
                              isCurrentlyConnected
                                  ? 'VPN turned off successfully'
                                  : 'VPN turned on successfully',
                            );
                          },
                          err: (failure) {
                            // Keep original state on retry failure
                            setState(() {
                              device['isVpnConnected'] = isCurrentlyConnected;
                            });
                            showError(failure);
                          },
                        );
                      },
                    );
                  },
                  onExpand: () async {
                    final id = device['id']?.toString() ?? '';
                    final detail = await DevicesService.getDeviceDetail(id);
                    handleApiResult(
                      detail,
                      onSuccess: (d) {
                        _showDeviceDetailModal(
                          context,
                          d,
                          device['name'],
                          device['id']?.toString() ?? '',
                        );
                      },
                      onRetry: () async {
                        final retryDetail =
                            await DevicesService.getDeviceDetail(id);
                        handleApiResult(
                          retryDetail,
                          onSuccess: (d) {
                            _showDeviceDetailModal(
                              context,
                              d,
                              device['name'],
                              device['id']?.toString() ?? '',
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.width(context, 5),
                ),
                child: Text(
                  '${AppStrings.noDevicesYet}\n${AppStrings.clickToAddNew}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.TEXT_SECONDARY_COLOR,
                    fontSize: Responsive.getFontSize(context, 15),
                    fontFamily: 'Poppins',
                    height: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: Responsive.height(context, 7)),
              GestureDetector(
                onTap: () async {
                  final created = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (_) => const AddDeviceForm(),
                  );
                  if (created == true) {
                    _onRefresh();
                  }
                },
                child: Container(
                  width: Responsive.getFontSize(context, 42),
                  height: Responsive.getFontSize(context, 42),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: Responsive.getFontSize(context, 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeviceDetailModal(
    BuildContext context,
    DeviceDetail detail,
    String deviceName,
    String deviceId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(Responsive.width(context, 6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(context, 3)),

            // Device info
            _buildInfoRow('WAN IP', detail.ipWanRouter),
            SizedBox(height: Responsive.height(context, 2)),
            _buildInfoRow('LAN IP', detail.ipLanRouter),
            SizedBox(height: Responsive.height(context, 2)),
            _buildInfoRow('Firmware', detail.firmwareRouter),
            SizedBox(height: Responsive.height(context, 2)),
            _buildInfoRow(
              'Package Name',
              detail.keyName.isNotEmpty ? detail.keyName : 'n/a',
            ),
            SizedBox(height: Responsive.height(context, 2)),
            _buildInfoRow('Start date', _formatDate(detail.startDate)),
            SizedBox(height: Responsive.height(context, 2)),
            _buildInfoRow('Expired date', _formatDate(detail.endDate)),
            SizedBox(height: Responsive.height(context, 2)),
            _buildUsageRow(detail.dataUsage, detail.totalDataUsage),

            SizedBox(height: Responsive.height(context, 4)),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showAssignVpnPackageModal(context, deviceId, deviceName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE3F2FD), // Light blue
                      foregroundColor: const Color(0xFF1976D2), // Dark blue
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.height(context, 2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Select VPN Package',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 3)),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showChangeLocationModal(context, deviceId, deviceName);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF757575), // Grey
                      side: const BorderSide(
                        color: Color(0xFFE0E0E0),
                      ), // Light grey border
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.height(context, 2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Change location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF616161), // Muted blue-grey
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1976D2), // Dark blue
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageRow(int dataUsage, int totalDataUsage) {
    final usageGB = (dataUsage / (1024 * 1024 * 1024)).toStringAsFixed(0);
    final totalGB = (totalDataUsage / (1024 * 1024 * 1024)).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage / Total: ',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF616161), // Muted blue-grey
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Text(
                '${usageGB}GB / ${totalGB}GB',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1976D2), // Dark blue
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          '(Last 30 days)',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF9E9E9E), // Light grey
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showAssignVpnPackageModal(
    BuildContext context,
    String deviceId,
    String deviceName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AssignVpnPackageModal(deviceId: deviceId, deviceName: deviceName),
    );
  }

  void _showChangeLocationModal(
    BuildContext context,
    String deviceId,
    String deviceName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ChangeLocationModal(keyId: deviceId, deviceName: deviceName),
    );
  }
}
