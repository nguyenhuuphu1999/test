import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class PlatformInfo {
  final String os;
  final String osVersion;
  final String? model;
  final String? deviceId;
  final String? appVersion;

  PlatformInfo({
    required this.os,
    required this.osVersion,
    this.model,
    this.deviceId,
    this.appVersion,
  });

  static Future<PlatformInfo> load() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        return PlatformInfo(
          os: 'android',
          osVersion: android.version.release ?? '',
          model: android.model,
          deviceId: android.id,
          appVersion: android.version.sdkInt.toString(),
        );
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        return PlatformInfo(
          os: 'ios',
          osVersion: ios.systemVersion ?? '',
          model: ios.utsname.machine,
          deviceId: ios.identifierForVendor,
          appVersion: ios.systemVersion,
        );
      } else if (Platform.isWindows) {
        final windows = await deviceInfo.windowsInfo;
        return PlatformInfo(
          os: 'windows',
          osVersion: windows.displayVersion,
          model: windows.computerName,
          deviceId: windows.deviceId,
        );
      } else if (Platform.isMacOS) {
        final macos = await deviceInfo.macOsInfo;
        return PlatformInfo(
          os: 'macos',
          osVersion: macos.osRelease,
          model: macos.model,
          deviceId: macos.systemGUID,
        );
      } else if (Platform.isLinux) {
        final linux = await deviceInfo.linuxInfo;
        return PlatformInfo(
          os: 'linux',
          osVersion: linux.version ?? '',
          model: linux.name,
          deviceId: linux.machineId,
        );
      }
    } catch (e) {
      // Fallback if device_info_plus fails
      print('Warning: Failed to get device info: $e');
    }

    // Fallback
    return PlatformInfo(
      os: Platform.operatingSystem,
      osVersion: '',
      model: null,
      deviceId: null,
    );
  }

  Map<String, String> toHeaders() {
    final headers = <String, String>{'x-os': os, 'x-os-version': osVersion};

    if (model != null) {
      headers['x-device-model'] = model!;
    }

    if (deviceId != null) {
      headers['x-device-id'] = deviceId!;
    }

    if (appVersion != null) {
      headers['x-app-version'] = appVersion!;
    }

    return headers;
  }
}
