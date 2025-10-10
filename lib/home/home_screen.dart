import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/persistent_main_layout.dart';
import 'package:vpncn2_app/widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentMainLayout(
      body: const HomeContent(),
      activeIndex: 0, // Home is active
    );
  }
}
