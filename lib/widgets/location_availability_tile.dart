import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';

class LocationAvailabilityTile extends StatelessWidget {
  final String country;
  final String city;
  final String availabilityText;
  final Widget? flagWidget; // optional custom flag

  const LocationAvailabilityTile({
    super.key,
    required this.country,
    required this.city,
    required this.availabilityText,
    this.flagWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Flag (3 stripes) or custom widget
        flagWidget ?? _DefaultFlag(),
        const SizedBox(width: 12),

        // Country/City
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                country,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                city,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Availability
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Available',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 4),
            Text(
              availabilityText,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}

class _DefaultFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simple 3-bar flag placeholder (blue/white/red like NL)
    return Column(
      children: [
        Container(
          width: 42,
          height: 32,
          color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.25),
        ),
        const SizedBox(height: 4),
        Container(width: 42, height: 21.33333396911621, color: Colors.white),
        const SizedBox(height: 4),
        Container(
          width: 42,
          height: 10.666666984558105,
          color: Colors.redAccent.withOpacity(0.7),
        ),
      ],
    );
  }
}
