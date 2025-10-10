import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/common_search_field.dart';
import 'package:vpncn2_app/constants/app_strings.dart';

class ServerLocationModal extends StatelessWidget {
  final String currentLocation;
  final Function(String code, String country) onLocationSelected;

  const ServerLocationModal({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F8FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Color(0xFF4894FE), size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Change Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4894FE),
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.public, color: Color(0xFF4894FE), size: 24),
              ],
            ),
          ),

          // Current Location Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Location Key-name-01:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF394452),
                  ),
                ),
                const SizedBox(height: 12),
                _CurrentLocationItem(
                  country: currentLocation == 'US'
                      ? 'United States'
                      : currentLocation == 'UK'
                      ? 'United Kingdom'
                      : currentLocation == 'DE'
                      ? 'Germany'
                      : currentLocation == 'JP'
                      ? 'Japan'
                      : currentLocation == 'SG'
                      ? 'Singapore'
                      : currentLocation == 'CA'
                      ? 'Canada'
                      : currentLocation == 'AU'
                      ? 'Australia'
                      : currentLocation == 'NL'
                      ? 'Netherlands'
                      : 'US',
                  flag: _getFlag(currentLocation),
                  percentage: '99.9%',
                  isSelected: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B2430),
                  ),
                ),
                const SizedBox(height: 12),
                // Search bar
                CommonSearchField.custom(
                  hintText: AppStrings.searchCountry,
                  backgroundColor: const Color(0xFFF8F9FA),
                  width: 100, // Full width
                  onChanged: (value) {
                    // TODO: Implement search functionality
                  },
                ),
              ],
            ),
          ),

          // Server locations list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ServerLocationItem(
                  country: 'United States',
                  flag: '🇺🇸',
                  code: 'US',
                  percentage: '68%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'US',
                  onTap: () => _selectServer(context, 'US', 'United States'),
                ),
                ServerLocationItem(
                  country: 'Australia',
                  flag: '🇦🇺',
                  code: 'AU',
                  percentage: '21%',
                  connectionQuality: ConnectionQuality.good,
                  isSelected: currentLocation == 'AU',
                  onTap: () => _selectServer(context, 'AU', 'Australia'),
                ),
                ServerLocationItem(
                  country: 'Bangladesh',
                  flag: '🇧🇩',
                  code: 'BD',
                  percentage: '85%',
                  connectionQuality: ConnectionQuality.poor,
                  isSelected: currentLocation == 'BD',
                  onTap: () => _selectServer(context, 'BD', 'Bangladesh'),
                ),
                ServerLocationItem(
                  country: 'China',
                  flag: '🇨🇳',
                  code: 'CN',
                  percentage: '69%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'CN',
                  onTap: () => _selectServer(context, 'CN', 'China'),
                ),
                ServerLocationItem(
                  country: 'Laos',
                  flag: '🇱🇦',
                  code: 'LA',
                  percentage: '84%',
                  connectionQuality: ConnectionQuality.poor,
                  isSelected: currentLocation == 'LA',
                  onTap: () => _selectServer(context, 'LA', 'Laos'),
                ),
                ServerLocationItem(
                  country: 'United Kingdom',
                  flag: '🇬🇧',
                  code: 'UK',
                  percentage: '42%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'UK',
                  onTap: () => _selectServer(context, 'UK', 'United Kingdom'),
                ),
                ServerLocationItem(
                  country: 'Vietnam',
                  flag: '🇻🇳',
                  code: 'VN',
                  percentage: '15%',
                  connectionQuality: ConnectionQuality.good,
                  isSelected: currentLocation == 'VN',
                  onTap: () => _selectServer(context, 'VN', 'Vietnam'),
                ),
                ServerLocationItem(
                  country: 'Germany',
                  flag: '🇩🇪',
                  code: 'DE',
                  percentage: '75%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'DE',
                  onTap: () => _selectServer(context, 'DE', 'Germany'),
                ),
                ServerLocationItem(
                  country: 'Japan',
                  flag: '🇯🇵',
                  code: 'JP',
                  percentage: '99%',
                  connectionQuality: ConnectionQuality.excellent,
                  isSelected: currentLocation == 'JP',
                  onTap: () => _selectServer(context, 'JP', 'Japan'),
                ),
                ServerLocationItem(
                  country: 'Singapore',
                  flag: '🇸🇬',
                  code: 'SG',
                  percentage: '88%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'SG',
                  onTap: () => _selectServer(context, 'SG', 'Singapore'),
                ),
                ServerLocationItem(
                  country: 'Canada',
                  flag: '🇨🇦',
                  code: 'CA',
                  percentage: '62%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'CA',
                  onTap: () => _selectServer(context, 'CA', 'Canada'),
                ),
                ServerLocationItem(
                  country: 'Netherlands',
                  flag: '🇳🇱',
                  code: 'NL',
                  percentage: '58%',
                  connectionQuality: ConnectionQuality.medium,
                  isSelected: currentLocation == 'NL',
                  onTap: () => _selectServer(context, 'NL', 'Netherlands'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectServer(BuildContext context, String code, String country) {
    Navigator.pop(context);
    onLocationSelected(code, country);
  }

  String _getFlag(String code) {
    switch (code) {
      case 'US':
        return '🇺🇸';
      case 'UK':
        return '🇬🇧';
      case 'DE':
        return '🇩🇪';
      case 'JP':
        return '🇯🇵';
      case 'SG':
        return '🇸🇬';
      case 'CA':
        return '🇨🇦';
      case 'AU':
        return '🇦🇺';
      case 'NL':
        return '🇳🇱';
      default:
        return '🇺🇸';
    }
  }
}

enum ConnectionQuality { excellent, good, medium, poor }

class _CurrentLocationItem extends StatelessWidget {
  final String country;
  final String flag;
  final String percentage;
  final bool isSelected;

  const _CurrentLocationItem({
    required this.country,
    required this.flag,
    required this.percentage,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4894FE), width: 2),
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              country,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4894FE),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                percentage,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4894FE),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF4894FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }
}

class ServerLocationItem extends StatelessWidget {
  final String country;
  final String flag;
  final String code;
  final String percentage;
  final ConnectionQuality connectionQuality;
  final bool isSelected;
  final VoidCallback onTap;

  const ServerLocationItem({
    super.key,
    required this.country,
    required this.flag,
    required this.code,
    required this.percentage,
    required this.connectionQuality,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4894FE).withValues(alpha: 0.1)
              : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4894FE)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                country,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF4894FE)
                      : const Color(0xFF394452),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getConnectionColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF4894FE)
                        : const Color(0xFF394452),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF4894FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4894FE), width: 2),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getConnectionColor() {
    switch (connectionQuality) {
      case ConnectionQuality.excellent:
        return Colors.green;
      case ConnectionQuality.good:
        return Colors.green;
      case ConnectionQuality.medium:
        return Colors.orange;
      case ConnectionQuality.poor:
        return Colors.red;
    }
  }
}
