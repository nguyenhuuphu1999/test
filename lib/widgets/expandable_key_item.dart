import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/models/key_details.dart';
import 'package:vpncn2_app/widgets/key_details_expansion.dart';

class ExpandableKeyItem extends StatefulWidget {
  final String name;
  final String quotaText;
  final int? remainDays;
  final bool expired;
  final VoidCallback? onConnect;
  final Function(String code, String country)? onServerLocationChanged;

  const ExpandableKeyItem({
    super.key,
    required this.name,
    required this.quotaText,
    this.remainDays,
    this.expired = false,
    this.onConnect,
    this.onServerLocationChanged,
  });

  @override
  State<ExpandableKeyItem> createState() => _ExpandableKeyItemState();
}

class _ExpandableKeyItemState extends State<ExpandableKeyItem> {
  bool _isExpanded = false;
  late KeyDetails _keyDetails;

  @override
  void initState() {
    super.initState();
    _keyDetails = KeyDetails.fromKeyItem(
      widget.name,
      widget.quotaText,
      widget.remainDays ?? 0,
      expired: widget.expired,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final Color dotColor = widget.expired
        ? const Color(0xFFFA3D3D)
        : const Color(0xFF2F6BFF);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main key item row
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  // Key icon with status
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.key,
                            color: Color(0xFF4894FE),
                            size: 24,
                          ),
                        ),
                        if (!widget.expired)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Key info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B2430),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.expired
                              ? t.expired
                              : t.remainDays(
                                  widget.remainDays?.toString() ?? '0',
                                ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: widget.expired
                                ? const Color(0xFFFA3D3D)
                                : const Color(0xFF9AA6B2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quota info
                  Text(
                    widget.quotaText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF394452),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Connect button
                  TextButton(
                    onPressed: widget.onConnect,
                    child: Text(
                      t.connect,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dropdown arrow
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF4894FE),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded)
            KeyDetailsExpansion(
              keyDetails: _keyDetails,
              onServerLocationChanged: (code, country) {
                setState(() {
                  _keyDetails = KeyDetails(
                    name: _keyDetails.name,
                    packageName: _keyDetails.packageName,
                    startDate: _keyDetails.startDate,
                    endDate: _keyDetails.endDate,
                    serverLocation: code,
                    outlineLink: _keyDetails.outlineLink,
                    alternateLink: _keyDetails.alternateLink,
                    quotaText: _keyDetails.quotaText,
                    remainDays: _keyDetails.remainDays,
                    expired: _keyDetails.expired,
                  );
                });
                if (widget.onServerLocationChanged != null) {
                  widget.onServerLocationChanged!(code, country);
                }
              },
            ),
        ],
      ),
    );
  }
}
