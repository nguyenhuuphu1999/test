import 'package:dio/dio.dart';

class DevicesApi {
  final Dio _dio;
  DevicesApi(Dio dio) : _dio = dio;

  Future<Response<dynamic>> getDevices({
    required int page,
    required int limit,
    String? search,
  }) async {
    return _dio.get(
      '/mobile/devices',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
  }

  Future<Response<dynamic>> getDeviceDetail(String deviceId) async {
    return _dio.get('/mobile/devices/$deviceId');
  }

  Future<Response<dynamic>> addDevice({
    required String deviceSerialNumber,
    required String deviceMacAddress,
    required String deviceAlias,
  }) async {
    return _dio.post(
      '/mobile/devices/add',
      data: {
        'deviceSerialNumber': deviceSerialNumber,
        'deviceMacAddress': deviceMacAddress,
        'deviceAlias': deviceAlias,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<Response<dynamic>> turnOnVpn(String deviceId) async {
    return _dio.post(
      '/mobile/devices/vpn/turn-on/$deviceId',
      options: Options(headers: {'accept': '*/*'}),
    );
  }

  Future<Response<dynamic>> turnOffVpn(String deviceId) async {
    return _dio.post(
      '/mobile/devices/vpn/turn-off/$deviceId',
      options: Options(headers: {'accept': '*/*'}),
    );
  }
}
