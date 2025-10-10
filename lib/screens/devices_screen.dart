import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/persistent_main_layout.dart';
import 'package:vpncn2_app/widgets/devices_content.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentMainLayout(
      body: const DevicesContent(),
      activeIndex: 1, // Cloud/Devices is active
    );
  }
}
