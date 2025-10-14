import 'package:flutter/material.dart';

class PersistentMainLayout extends StatefulWidget {
  final Widget body;
  final int activeIndex; // 0: home, 1: cloud, 2: user

  const PersistentMainLayout({
    super.key,
    required this.body,
    required this.activeIndex,
  });

  @override
  State<PersistentMainLayout> createState() => _PersistentMainLayoutState();
}

class _PersistentMainLayoutState extends State<PersistentMainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: widget.body));
  }
}
