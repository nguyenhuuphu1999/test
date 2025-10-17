import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/device_card.dart';
import '../widgets/device_key_style_card.dart';

class TestIconsScreen extends StatelessWidget {
  const TestIconsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Test Icons'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Cards with Lightning Bolt Icons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Test DeviceCard
            DeviceCard(
              deviceName: 'Router 01',
              ssidName: 'Test WiFi',
              isOnline: true,
              isVpnConnected: true,
              onToggle: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Device toggled')),
                );
              },
            ),
            const SizedBox(height: 16),
            
            DeviceCard(
              deviceName: 'Router 02',
              ssidName: 'Offline Router',
              isOnline: false,
              isVpnConnected: false,
              onToggle: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Device toggled')),
                );
              },
            ),
            const SizedBox(height: 32),
            
            const Text(
              'Device Key Style Cards with Lightning Bolt Icons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Test DeviceKeyStyleCard
            DeviceKeyStyleCard(
              deviceName: 'Router 03',
              ssidName: 'Test SSID',
              location: 'US: 102.101.102.101',
              isOnline: true,
              isVpnConnected: false,
              onConnect: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connect pressed')),
                );
              },
            ),
            const SizedBox(height: 16),
            
            DeviceKeyStyleCard(
              deviceName: 'Router 04',
              ssidName: 'Offline Router',
              location: 'US: 102.101.102.102',
              isOnline: false,
              isVpnConnected: false,
              onConnect: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connect pressed')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
