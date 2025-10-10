import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const PrimaryButton({super.key, required this.label, required this.onPressed, this.height = 52});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4894FE),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}



