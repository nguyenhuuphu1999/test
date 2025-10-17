import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/device_card.dart';
import '../widgets/device_key_style_card.dart';
import '../widgets/connect_component.dart';
import '../utils/responsive.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      appBar: AppBar(
        title: const Text(
          'Demo - Device Icons & Connect Component',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.TEXT_PRIMARY_COLOR,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.TEXT_PRIMARY_COLOR,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Device Cards with Lightning Bolt Icons
            const Text(
              'Device Cards with Lightning Bolt Icons:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_PRIMARY_COLOR,
              ),
            ),
            const SizedBox(height: 16),
            
            // Device Card 1 - Online
            DeviceCard(
              deviceName: 'Router 01',
              ssidName: 'SSID Name',
              isOnline: true,
              isVpnConnected: true,
              onToggle: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Router 01 VPN toggled'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              onExpand: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Router 01 details opened'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            
            // Device Card 2 - Offline
            DeviceCard(
              deviceName: 'Router 02',
              ssidName: 'My WiFi',
              isOnline: false,
              isVpnConnected: false,
              onToggle: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Router 02 VPN toggled'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              onExpand: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Router 02 details opened'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Section 2: Device Key Style Cards
            const Text(
              'Device Key Style Cards with Lightning Bolt Icons:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_PRIMARY_COLOR,
              ),
            ),
            const SizedBox(height: 16),
            
            // Device Key Style Card 1
            DeviceKeyStyleCard(
              deviceName: 'Router 03',
              ssidName: 'Offline Router',
              location: 'US: 102.101.102.101',
              isOnline: false,
              isVpnConnected: false,
              onConnect: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Router 03 VPN toggled'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              onExpand: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Router 03 details opened'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Section 3: Connect Component
            const Text(
              'Connect Component (like the image):',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_PRIMARY_COLOR,
              ),
            ),
            const SizedBox(height: 16),
            
            // Connect Component
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ConnectComponent(
                isConnected: _isConnected,
                serverLocation: 'Amsterdam',
                serverCountry: 'Netherlands',
                availability: '99.9%',
                connectedTime: _isConnected ? '02 : 41 : 52' : '00 : 00 : 00',
                downloadSpeed: _isConnected ? '527 MB' : '0 MB',
                uploadSpeed: _isConnected ? '49 MB' : '0 MB',
                onConnect: () {
                  setState(() {
                    _isConnected = !_isConnected;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isConnected ? 'Connected to VPN' : 'Disconnected from VPN',
                      ),
                      backgroundColor: _isConnected ? Colors.green : Colors.red,
                    ),
                  );
                },
                onChangeServer: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Change server feature coming soon!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                onSwitchKey: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Switch key feature coming soon!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Section 4: Navigation Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Navigation:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Bottom navigation now includes a lightning bolt connect button\n'
                    '• Navigate to /connect to see the full connect screen\n'
                    '• Navigate to /devices to see device list with lightning bolt icons\n'
                    '• All device icons have been replaced with lightning bolt icons',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
