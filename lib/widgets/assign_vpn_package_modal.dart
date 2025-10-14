import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/services/keys_service.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';

class AssignVpnPackageModal extends StatefulWidget {
  final String deviceId;
  final String deviceName;

  const AssignVpnPackageModal({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  State<AssignVpnPackageModal> createState() => _AssignVpnPackageModalState();
}

class _AssignVpnPackageModalState extends State<AssignVpnPackageModal>
    with ErrorHandlerMixin {
  List<KeyEntity.Key> _keys = [];
  bool _isLoading = true;
  String? _selectedKeyId;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    setState(() {
      _isLoading = true;
    });

    final result = await KeysService.getKeys(status: 1, pageSize: 50);
    handleApiResult(
      result,
      onSuccess: (keys) {
        setState(() {
          _keys = keys;
          _isLoading = false;
          if (keys.isNotEmpty) {
            _selectedKeyId = keys.first.id;
          }
        });
      },
      onRetry: () => _loadKeys(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(Responsive.width(context, 6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: Responsive.height(context, 3)),

          // Header
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.PRIMARY_COLOR,
                  size: Responsive.getFontSize(context, 24),
                ),
              ),
              SizedBox(width: Responsive.width(context, 4)),
              Expanded(
                child: Text(
                  'Assign VPN Package to device',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 3)),

          // Keys List
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_keys.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No VPN keys available',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    color: AppColors.TEXT_SECONDARY_COLOR,
                  ),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _keys.length,
                itemBuilder: (context, index) {
                  final key = _keys[index];
                  final isSelected = _selectedKeyId == key.id;
                  final remainDays = key.endDate
                      .difference(DateTime.now())
                      .inDays;
                  final quotaGB = (key.dataLimit / (1024 * 1024 * 1024))
                      .round();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.PRIMARY_COLOR
                            : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: Responsive.getFontSize(context, 48),
                        height: Responsive.getFontSize(context, 48),
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                          size: Responsive.getFontSize(context, 24),
                        ),
                      ),
                      title: Text(
                        key.name,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Responsive.height(context, 0.5)),
                          Text(
                            'Remain: ${remainDays > 0 ? remainDays : 0} Days',
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 12),
                              color: AppColors.TEXT_SECONDARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'M-$quotaGB',
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          SizedBox(width: Responsive.width(context, 3)),
                          Radio<String>(
                            value: key.id,
                            groupValue: _selectedKeyId,
                            onChanged: (value) {
                              setState(() {
                                _selectedKeyId = value;
                              });
                            },
                            activeColor: AppColors.PRIMARY_COLOR,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedKeyId = key.id;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: Responsive.height(context, 3)),

          // Assign Button
          if (!_isLoading && _keys.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedKeyId != null ? _assignVpnPackage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.height(context, 2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Assign VPN Package',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }

  Future<void> _assignVpnPackage() async {
    if (_selectedKeyId == null) return;

    // TODO: Implement assign VPN package API call
    // For now, just show success message
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('VPN package assigned successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
