import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/services/devices_service.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';

class AddDeviceForm extends StatefulWidget {
  const AddDeviceForm({super.key});

  @override
  State<AddDeviceForm> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> with ErrorHandlerMixin {
  final TextEditingController _macController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _macFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _macController.text = '94:83:C4:67:06:BB';
    _nameController.text = AppStrings.router01;
    _macController.addListener(_formatMacAddress);
  }

  @override
  void dispose() {
    _macController.dispose();
    _nameController.dispose();
    _macFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _formatMacAddress() {
    String text = _macController.text;
    String cleanText = text.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
    if (cleanText.length > 12) cleanText = cleanText.substring(0, 12);
    String formattedText = '';
    for (int i = 0; i < cleanText.length; i += 2) {
      if (i > 0) formattedText += ':';
      if (i + 1 < cleanText.length) {
        formattedText += cleanText.substring(i, i + 2);
      } else {
        formattedText += cleanText.substring(i);
      }
    }
    if (formattedText != text) {
      _macController.value = _macController.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  bool _isValidMacAddress(String mac) {
    final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    return macRegex.hasMatch(mac);
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final mac = _macController.text.trim();
    final name = _nameController.text.trim();
    if (!_isValidMacAddress(mac)) {
      _showError('Invalid MAC address format');
      return;
    }
    if (name.isEmpty) {
      _showError('Please enter device name');
      return;
    }

    setState(() => _isSubmitting = true);
    final serial = 'SN${DateTime.now().millisecondsSinceEpoch}';
    final result = await DevicesService.addDevice(
      deviceSerialNumber: serial,
      deviceMacAddress: mac,
      deviceAlias: name,
    );

    if (!mounted) return;
    handleApiResultWithSuccess(
      result,
      onSuccess: (_) {
        Navigator.of(context).pop(true);
      },
      successMessage: 'Device added successfully!',
      onRetry: () => _submit(),
    );
    if (mounted) setState(() => _isSubmitting = false);
  }

  void _showError(String msg) {
    showError(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Responsive.width(context, 6),
        right: Responsive.width(context, 6),
        top: Responsive.height(context, 2),
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                AppStrings.addNewDevice,
                style: TextStyle(
                  color: AppColors.TEXT_PRIMARY_COLOR,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 2)),
          const Text(
            AppStrings.deviceMac,
            style: TextStyle(
              color: AppColors.TEXT_PRIMARY_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Responsive.height(context, 1)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.SURFACE_COLOR,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
            ),
            child: TextField(
              controller: _macController,
              focusNode: _macFocusNode,
              style: const TextStyle(
                color: AppColors.TEXT_PRIMARY_COLOR,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'XX:XX:XX:XX:XX:XX',
                hintStyle: TextStyle(
                  color: AppColors.TEXT_SECONDARY_COLOR,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f:]')),
                LengthLimitingTextInputFormatter(17),
              ],
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          SizedBox(height: Responsive.height(context, 2)),
          const Text(
            AppStrings.setTheName,
            style: TextStyle(
              color: AppColors.TEXT_PRIMARY_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Responsive.height(context, 1)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.SURFACE_COLOR,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.BORDER_COLOR, width: 1),
            ),
            child: TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              style: const TextStyle(
                color: AppColors.TEXT_PRIMARY_COLOR,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: AppStrings.router01,
                hintStyle: TextStyle(
                  color: AppColors.TEXT_SECONDARY_COLOR,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.height(context, 3)),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.PRIMARY_COLOR,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isSubmitting ? 'Adding...' : AppStrings.addDevice,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
