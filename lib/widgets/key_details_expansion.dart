import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpncn2_app/models/key_details.dart';
import 'package:vpncn2_app/widgets/info_row.dart';
import 'package:vpncn2_app/widgets/action_button.dart';
import 'package:vpncn2_app/widgets/server_location_modal.dart';

class KeyDetailsExpansion extends StatelessWidget {
  final KeyDetails keyDetails;
  final Function(String code, String country)? onServerLocationChanged;

  const KeyDetailsExpansion({
    super.key,
    required this.keyDetails,
    this.onServerLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package Information
          const Text(
            'Package Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B2430),
            ),
          ),
          const SizedBox(height: 12),
          InfoRow(label: 'Package name:', value: keyDetails.packageName),
          InfoRow(label: 'Start:', value: keyDetails.startDate),
          InfoRow(label: 'End:', value: keyDetails.endDate),
          InfoRow(
            label: 'Server Location:',
            value: keyDetails.serverLocation,
            hasChangeButton: true,
            onChange: () => _showServerLocationModal(context),
          ),
          InfoRow(
            label: 'Outline link:',
            value: keyDetails.outlineLink,
            hasCopyButton: true,
            onCopy: () => _copyToClipboard(context, keyDetails.outlineLink),
          ),

          const SizedBox(height: 16),

          // Connection Instructions
          const Text(
            'Connection Instructions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B2430),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(Please copy and paste the link into Outline APP to connect VPN)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF394452),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    keyDetails.outlineLink,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1B2430),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _copyToClipboard(context, keyDetails.outlineLink),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4894FE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.copy, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  icon: Icons.copy,
                  label: 'Copy Link',
                  onTap: () =>
                      _copyToClipboard(context, keyDetails.outlineLink),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  icon: Icons.open_in_new,
                  label: 'Open Outline',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Outline app...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showServerLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ServerLocationModal(
          currentLocation: keyDetails.serverLocation,
          onLocationSelected: (code, country) {
            if (onServerLocationChanged != null) {
              onServerLocationChanged!(code, country);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server changed to $country ($code)'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}
