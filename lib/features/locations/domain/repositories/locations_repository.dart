import '../../../../core/error/result.dart';
import '../entities/location.dart';

abstract class LocationsRepository {
  Future<Result<LocationsResponse>> getLocationsByKey({required String keyId});
}
