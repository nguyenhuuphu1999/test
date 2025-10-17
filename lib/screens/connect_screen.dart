import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/connect_component.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool _isConnected = false;
  String _connectedTime = '00 : 00 : 00';
  String _downloadSpeed = '0 MB';
  String _uploadSpeed = '0 MB';
  String _serverLocation = 'Amsterdam';
  String _serverCountry = 'Netherlands';
  String _availability = '99.9%';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Simulate connection timer
    Future.delayed(const Duration(seconds: 1), () {
      if (_isConnected && mounted) {
        _updateConnectedTime();
        _startTimer();
      }
    });
  }

  void _updateConnectedTime() {
    final parts = _connectedTime.split(' : ');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    seconds++;
    if (seconds >= 60) {
      seconds = 0;
      minutes++;
      if (minutes >= 60) {
        minutes = 0;
        hours++;
      }
    }

    setState(() {
      _connectedTime = '${hours.toString().padLeft(2, '0')} : '
          '${minutes.toString().padLeft(2, '0')} : '
          '${seconds.toString().padLeft(2, '0')}';
    });
  }

  void _handleConnect() {
    setState(() {
      _isConnected = !_isConnected;
      if (_isConnected) {
        _connectedTime = '00 : 00 : 00';
        _downloadSpeed = '527 MB';
        _uploadSpeed = '49 MB';
        _startTimer();
      } else {
        _downloadSpeed = '0 MB';
        _uploadSpeed = '0 MB';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isConnected ? 'Connected to VPN' : 'Disconnected from VPN',
        ),
        backgroundColor: _isConnected ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleChangeServer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Server'),
        content: const Text('Server selection feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSwitchKey() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Key'),
        content: const Text('Key switching feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      appBar: AppBar(
        title: const Text(
          'VPN Connection',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.TEXT_PRIMARY_COLOR,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.TEXT_PRIMARY_COLOR,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConnectComponent(
          isConnected: _isConnected,
          serverLocation: _serverLocation,
          serverCountry: _serverCountry,
          availability: _availability,
          connectedTime: _connectedTime,
          downloadSpeed: _downloadSpeed,
          uploadSpeed: _uploadSpeed,
          onConnect: _handleConnect,
          onChangeServer: _handleChangeServer,
          onSwitchKey: _handleSwitchKey,
        ),
      ),
    );
  }
}
