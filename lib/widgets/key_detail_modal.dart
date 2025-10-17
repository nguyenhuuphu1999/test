import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';
import 'package:vpncn2_app/services/keys_service.dart';

class KeyDetailModal extends StatefulWidget {
  final String keyId;
  final String keyName;

  const KeyDetailModal({super.key, required this.keyId, required this.keyName});

  @override
  State<KeyDetailModal> createState() => _KeyDetailModalState();
}

class _KeyDetailModalState extends State<KeyDetailModal>
    with ErrorHandlerMixin {
  KeyEntity.Key? _keyDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKeyDetail();
  }

  Future<void> _loadKeyDetail() async {
    setState(() {
      _isLoading = true;
    });

    final result = await KeysService.getKeyDetail(widget.keyId);

    handleApiResult(
      result,
      onSuccess: (keyDetail) {
        setState(() {
          _keyDetail = keyDetail;
          _isLoading = false;
        });
      },
      onRetry: () => _loadKeyDetail(),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showSuccess('Copied to clipboard!');
  }

  void _openOutlineApp() {
    // TODO: Implement opening Outline app with the access URL
    showWarning('Opening Outline app...');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(Responsive.width(context, 6)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.PRIMARY_COLOR,
                    size: Responsive.getFontSize(context, 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Key Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.getFontSize(context, 20),
                ), // Placeholder for alignment
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _keyDetail == null
                ? const Center(child: Text('Failed to load key details'))
                : _buildKeyDetailContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyDetailContent() {
    final key = _keyDetail!;
    final remainDays = key.endDate.difference(DateTime.now()).inDays;
    final dataLimitGB = (key.dataLimit / (1024 * 1024 * 1024)).round();

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.width(context, 6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Summary Card
          Container(
            padding: EdgeInsets.all(Responsive.width(context, 4)),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  width: Responsive.getFontSize(context, 48),
                  height: Responsive.getFontSize(context, 48),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.vpn_key,
                    color: AppColors.PRIMARY_COLOR,
                    size: Responsive.getFontSize(context, 24),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key.name,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      SizedBox(height: Responsive.height(context, 1)),
                      Text(
                        'Remain: $remainDays Days',
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          color: AppColors.TEXT_SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${dataLimitGB}GB',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Responsive.height(context, 4)),

          // Package Information Section
          Text(
            'Package Information',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: AppColors.TEXT_PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: Responsive.height(context, 2)),

          _buildInfoRow('Package name', 'M-${dataLimitGB}'),
          SizedBox(height: Responsive.height(context, 1.5)),
          _buildInfoRow('Start', _formatDateTime(key.startDate)),
          SizedBox(height: Responsive.height(context, 1.5)),
          _buildInfoRow('End', _formatDateTime(key.endDate)),
          SizedBox(height: Responsive.height(context, 1.5)),
          _buildInfoRowWithIcon(
            'Server Location',
            key.serverLocation,
            Icons.refresh,
          ),
          SizedBox(height: Responsive.height(context, 1.5)),
          _buildInfoRowWithIcon('Outline link', 'Main link', Icons.copy),

          SizedBox(height: Responsive.height(context, 4)),

          // Connection Instructions Section
          Text(
            'Connection Instructions',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: AppColors.TEXT_PRIMARY_COLOR,
            ),
          ),
          SizedBox(height: Responsive.height(context, 2)),

          Text(
            '(Please copy and paste the link into Outline APP to connect VPN)',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
          ),
          SizedBox(height: Responsive.height(context, 2)),

          // Access URL Display
          Container(
            padding: EdgeInsets.all(Responsive.width(context, 3)),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    key.accessUrl,
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(context, 12),
                      color: AppColors.TEXT_PRIMARY_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: Responsive.width(context, 2)),
                GestureDetector(
                  onTap: () => _copyToClipboard(key.accessUrl),
                  child: Icon(
                    Icons.copy,
                    color: AppColors.PRIMARY_COLOR,
                    size: Responsive.getFontSize(context, 18),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Responsive.height(context, 4)),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyToClipboard(key.accessUrl),
                  icon: Icon(
                    Icons.copy,
                    color: AppColors.PRIMARY_COLOR,
                    size: Responsive.getFontSize(context, 16),
                  ),
                  label: Text(
                    'Copy Link',
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.PRIMARY_COLOR),
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.height(context, 2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Responsive.width(context, 3)),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openOutlineApp,
                  icon: Icon(
                    Icons.open_in_new,
                    color: AppColors.PRIMARY_COLOR,
                    size: Responsive.getFontSize(context, 16),
                  ),
                  label: Text(
                    'Open Outline',
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.PRIMARY_COLOR),
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.height(context, 2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 14),
            color: AppColors.TEXT_SECONDARY_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithIcon(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: Responsive.getFontSize(context, 14),
            color: AppColors.TEXT_SECONDARY_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (icon == Icons.copy) {
              _copyToClipboard(value);
            } else if (icon == Icons.refresh) {
              // TODO: Implement server location refresh
              showWarning('Refreshing server location...');
            }
          },
          child: Icon(
            icon,
            color: AppColors.PRIMARY_COLOR,
            size: Responsive.getFontSize(context, 16),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
