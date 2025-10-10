import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/screens/add_device_screen.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_search_field.dart';
import 'package:vpncn2_app/widgets/device_card.dart';
import 'package:vpncn2_app/widgets/server_location_modal.dart';
import 'package:vpncn2_app/widgets/vpn_package_modal.dart';

class DevicesContent extends StatefulWidget {
  const DevicesContent({super.key});

  @override
  State<DevicesContent> createState() => _DevicesContentState();
}

class _DevicesContentState extends State<DevicesContent> {
  // Mock device data - replace with real data from your state management
  late List<Map<String, dynamic>> devices;

  @override
  void initState() {
    super.initState();
    devices = [
      {
        'name': 'Router 01',
        'ssid': 'SSID Name',
        'isOnline': true,
        'isVpnConnected': true,
        'currentPackage': 'R500-manhnguyen-250420',
      },
      {
        'name': 'Router 02',
        'ssid': 'My WiFi',
        'isOnline': true,
        'isVpnConnected': false,
        'currentPackage': 'R1000-premium-250420',
      },
      {
        'name': 'Router 03',
        'ssid': 'Offline Router',
        'isOnline': false,
        'isVpnConnected': false,
        'currentPackage': 'R2000-unlimited-250420',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        CommonSearchField.devices(onChanged: (value) {}),

        SizedBox(height: Responsive.height(context, 3)),

        // Devices List
        Expanded(
          child: devices.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.only(
                    top: Responsive.height(context, 2),
                    bottom: Responsive.height(context, 2),
                  ),
                  itemCount: devices.length + 1, // +1 for Add button
                  itemBuilder: (context, index) {
                    if (index == devices.length) {
                      // Add New Button
                      return Padding(
                        padding: EdgeInsets.only(
                          top: Responsive.height(context, 2),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddDeviceScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: Responsive.getFontSize(context, 42),
                              height: Responsive.getFontSize(context, 42),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
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

                    final device = devices[index];
                    return DeviceCard(
                      deviceName: device['name'],
                      ssidName: device['ssid'],
                      isOnline: device['isOnline'],
                      isVpnConnected: device['isVpnConnected'],
                      onToggle: () {
                        // Toggle VPN connection state
                        setState(() {
                          device['isVpnConnected'] = !device['isVpnConnected'];
                        });
                        print(
                          'Toggle VPN for ${device['name']}: ${device['isVpnConnected']}',
                        );
                      },
                      onExpand: () {
                        // Handle expand logic (now handled internally)
                        print('Expand ${device['name']}');
                      },
                      onChangeLocation: () {
                        // Show change location modal
                        _showChangeLocationModal(context, device['name']);
                      },
                      onSelectVpnPackage: () {
                        // Show VPN package selection modal
                        _showVpnPackageModal(
                          context,
                          device['name'],
                          device['currentPackage'],
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty State Message
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 5),
            ),
            child: Text(
              '${AppStrings.noDevicesYet}\n${AppStrings.clickToAddNew}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: Responsive.getFontSize(context, 15),
                fontFamily: 'Poppins',
                height: 0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),

          SizedBox(height: Responsive.height(context, 7)),

          // Add New Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddDeviceScreen(),
                ),
              );
            },
            child: Container(
              width: Responsive.getFontSize(context, 42),
              height: Responsive.getFontSize(context, 42),
              decoration: BoxDecoration(
                color: AppColors.primary,
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
    );
  }

  void _showChangeLocationModal(BuildContext context, String deviceName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServerLocationModal(
        currentLocation: 'US: 102.101.102.101',
        onLocationSelected: (location, locationName) {
          print('Selected location for $deviceName: $location');
          // Handle location change logic here
        },
      ),
    );
  }

  void _showVpnPackageModal(
    BuildContext context,
    String deviceName,
    String currentPackage,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VpnPackageModal(
        currentPackage: currentPackage,
        onPackageSelected: (packageName) {
          setState(() {
            // Find and update the device's current package
            for (var device in devices) {
              if (device['name'] == deviceName) {
                device['currentPackage'] = packageName;
                break;
              }
            }
          });
          print('Selected VPN package for $deviceName: $packageName');
        },
      ),
    );
  }
}
