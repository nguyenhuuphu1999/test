import '../../../../core/error/result.dart';
import '../entities/location.dart';

abstract class LocationsRepository {
  Future<Result<LocationsResponse>> getLocations({
    required String deviceId,
    String? search,
  });
}
