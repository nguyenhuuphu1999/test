import 'package:flutter/material.dart';

class EarthRotating extends StatefulWidget {
  final double size;
  final Duration duration;

  const EarthRotating({
    super.key,
    this.size = 220,
    this.duration = const Duration(seconds: 16),
  });

  @override
  State<EarthRotating> createState() => _EarthRotatingState();
}

class _EarthRotatingState extends State<EarthRotating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        'asset/images/earth.png',
        fit: BoxFit.contain,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
