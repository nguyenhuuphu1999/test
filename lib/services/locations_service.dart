import 'package:dio/dio.dart';
import '../core/di/simple_injector.dart';
import '../core/error/result.dart';
import '../features/locations/data/datasources/locations_api.dart';
import '../features/locations/data/repositories/locations_repository_impl.dart';
import '../features/locations/domain/entities/location.dart';
import '../features/locations/domain/repositories/locations_repository.dart';

class LocationsService {
  static bool _isInitialized = false;
  static late LocationsRepository _repository;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    await initSimpleDI();
    final dio = sl<Dio>();
    _repository = LocationsRepositoryImpl(LocationsApi(dio));
    _isInitialized = true;
  }

  static Future<Result<LocationsResponse>> getLocations({
    required String deviceId,
    String? search,
  }) async {
    await initialize();
    return _repository.getLocations(deviceId: deviceId, search: search);
  }
}
