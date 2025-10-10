import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Builder(builder: (context) {
          final double logoWidth = MediaQuery.of(context).size.width * 0.5;
          return Center(
            child: Image.asset(
              'asset/images/logo-vpncn2.png',
              width: logoWidth,
              fit: BoxFit.contain,
            ),
          );
        }),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1B2430))),
        const SizedBox(height: 6),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF394452))),
      ],
    );
  }
}


