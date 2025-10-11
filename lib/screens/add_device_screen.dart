import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/constants/app_strings.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/widgets/common_footer.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController _macController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _macFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set default MAC address
    _macController.text = '94:83:C4:67:06:BB';
    _nameController.text = AppStrings.router01;

    // Add listener for MAC formatting
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

    if (cleanText.length > 12) {
      cleanText = cleanText.substring(0, 12);
    }

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

  void _validateAndAddDevice() async {
    String mac = _macController.text.trim();
    String name = _nameController.text.trim();

    if (!_isValidMacAddress(mac)) {
      _showErrorDialog('Invalid MAC address format');
      return;
    }

    if (name.isEmpty) {
      _showErrorDialog('Please enter device name');
      return;
    }

    // Simulate database check
    await _checkDeviceInDatabase(mac);
  }

  Future<void> _checkDeviceInDatabase(String mac) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock database responses for different scenarios
    final mockResponses = {
      '94:83:C4:67:06:BB': 'already_added',
      'AA:BB:CC:DD:EE:FF': 'not_online',
      '11:22:33:44:55:66': 'not_exist',
    };

    String response = mockResponses[mac] ?? 'available';

    switch (response) {
      case 'already_added':
        _showErrorDialog(AppStrings.deviceAlreadyAdded);
        break;
      case 'not_exist':
        _showErrorDialog(AppStrings.deviceNotExist);
        break;
      case 'not_online':
        _showConfirmationDialog();
        break;
      case 'available':
        _addDevice();
        break;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Status'),
        content: const Text(AppStrings.deviceNotOnline),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addDevice();
            },
            child: const Text(AppStrings.yes),
          ),
        ],
      ),
    );
  }

  void _addDevice() {
    // Simulate adding device
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Device added successfully!'),
        backgroundColor: AppColors.SUCCESS_COLOR,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.TEXT_PRIMARY_COLOR,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppStrings.addNewDevice,
          style: TextStyle(
            color: AppColors.TEXT_PRIMARY_COLOR,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: Responsive.getPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.height(context, 3)),

                    // Device MAC Field
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
                        border: Border.all(
                          color: AppColors.BORDER_COLOR,
                          width: 1,
                        ),
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
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9A-Fa-f:]'),
                          ),
                          LengthLimitingTextInputFormatter(
                            17,
                          ), // MAC with colons
                        ],
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),

                    SizedBox(height: Responsive.height(context, 4)),

                    // Set the name Field
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
                        border: Border.all(
                          color: AppColors.BORDER_COLOR,
                          width: 1,
                        ),
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

                    const Spacer(),

                    // Add Device Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _validateAndAddDevice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          AppStrings.addDevice,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Responsive.height(context, 2)),
                  ],
                ),
              ),
            ),
          ),

          // Common Footer
          CommonFooter(
            activeIndex: 1, // Cloud is active on add device screen
            onTabChanged: (index) {
              switch (index) {
                case 0:
                case 1:
                  Navigator.pop(context);
                  break;
                case 2:
                  // TODO: Navigate to profile screen
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
