import 'package:flutter/material.dart';

class Vpncn2Loading extends StatefulWidget {
  final double size; // diameter of the bouncing logo
  final Duration duration;

  const Vpncn2Loading({
    super.key,
    this.size = 64,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  State<Vpncn2Loading> createState() => _Vpncn2LoadingState();
}

class _Vpncn2LoadingState extends State<Vpncn2Loading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _offsetY = Tween<double>(
      begin: 0,
      end: -10,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, _offsetY.value), child: child),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset('asset/images/logo-vpncn2.png', fit: BoxFit.contain),
      ),
    );
  }
}

Future<void> showVpncn2LoadingDialog(
  BuildContext context, {
  bool barrierDismissible = false,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.15),
    builder: (context) {
      return const Center(child: Vpncn2Loading());
    },
  );
}
