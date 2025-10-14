import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/correlation_interceptor.dart';
import '../network/interceptors/device_interceptor.dart';
import '../utils/platform_info.dart';
import '../../features/auth/data/datasources/auth_api.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/keys/data/datasources/keys_api.dart';
import '../../features/keys/data/repositories/keys_repository_impl.dart';
import '../../features/keys/domain/repositories/keys_repository.dart';
import '../../features/keys/domain/usecases/get_keys_usecase.dart';
import '../../features/devices/data/datasources/devices_api.dart';
import '../../features/devices/data/repositories/devices_repository_impl.dart';
import '../../features/devices/domain/repositories/devices_repository.dart';
import '../../features/locations/data/datasources/locations_api.dart';
import '../../features/locations/data/repositories/locations_repository_impl.dart';
import '../../features/locations/domain/repositories/locations_repository.dart';
import '../../features/plans/data/datasources/plans_api.dart';
import '../../features/plans/data/repositories/plans_repository_impl.dart';
import '../../features/plans/domain/repositories/plans_repository.dart';
import '../../features/payment_methods/data/datasources/payment_methods_api.dart';
import '../../features/payment_methods/data/repositories/payment_methods_repository_impl.dart';
import '../../features/payment_methods/domain/repositories/payment_methods_repository.dart';

final sl = GetIt.instance;

Future<void> initSimpleDI() async {
  // Platform info - only register if not already registered
  if (!sl.isRegistered<PlatformInfo>()) {
    final platformInfo = await PlatformInfo.load();
    sl.registerSingleton(platformInfo);
  }

  // Register interceptors - only if not already registered
  if (!sl.isRegistered<CorrelationInterceptor>()) {
    sl.registerLazySingleton(() => CorrelationInterceptor());
  }

  if (!sl.isRegistered<DeviceInterceptor>()) {
    sl.registerLazySingleton(() => DeviceInterceptor(sl<PlatformInfo>()));
  }

  // Create a temporary Dio for auth interceptor
  if (!sl.isRegistered<AuthInterceptor>()) {
    final tempDio = Dio();
    sl.registerLazySingleton(() => AuthInterceptor(dio: tempDio));
  }

  // Build final Dio client - only if not already registered
  if (!sl.isRegistered<Dio>()) {
    final dio = buildDio(
      authInterceptor: sl(),
      correlationInterceptor: sl(),
      deviceInterceptor: sl(),
    );

    // Register the final Dio client
    sl.registerLazySingleton<Dio>(() => dio);
    sl.registerLazySingleton(() => DioClient(dio));
  }

  // Auth feature - only if not already registered
  if (!sl.isRegistered<AuthApi>()) {
    sl.registerLazySingleton(() => AuthApi(sl<DioClient>()));
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authApi: sl()),
    );
  }

  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  }

  // Keys feature - only if not already registered
  if (!sl.isRegistered<KeysApi>()) {
    sl.registerLazySingleton(() => KeysApi(sl<Dio>()));
  }

  if (!sl.isRegistered<KeysRepository>()) {
    sl.registerLazySingleton<KeysRepository>(
      () => KeysRepositoryImpl(sl<KeysApi>()),
    );
  }

  if (!sl.isRegistered<GetKeysUseCase>()) {
    sl.registerLazySingleton(() => GetKeysUseCase(sl<KeysRepository>()));
  }

  // Devices feature - only if not already registered
  if (!sl.isRegistered<DevicesApi>()) {
    sl.registerLazySingleton(() => DevicesApi(sl<Dio>()));
  }

  if (!sl.isRegistered<DevicesRepository>()) {
    sl.registerLazySingleton<DevicesRepository>(
      () => DevicesRepositoryImpl(sl<DevicesApi>()),
    );
  }

  // Locations feature - only if not already registered
  if (!sl.isRegistered<LocationsApi>()) {
    sl.registerLazySingleton(() => LocationsApi(sl<Dio>()));
  }

  if (!sl.isRegistered<LocationsRepository>()) {
    sl.registerLazySingleton<LocationsRepository>(
      () => LocationsRepositoryImpl(sl<LocationsApi>()),
    );
  }

  // Plans feature - only if not already registered
  if (!sl.isRegistered<PlansApi>()) {
    sl.registerLazySingleton(() => PlansApi(sl<Dio>()));
  }

  if (!sl.isRegistered<PlansRepository>()) {
    sl.registerLazySingleton<PlansRepository>(
      () => PlansRepositoryImpl(sl<PlansApi>()),
    );
  }

  // Payment Methods feature - only if not already registered
  if (!sl.isRegistered<PaymentMethodsApi>()) {
    sl.registerLazySingleton(() => PaymentMethodsApi(sl<Dio>()));
  }

  if (!sl.isRegistered<PaymentMethodsRepository>()) {
    sl.registerLazySingleton<PaymentMethodsRepository>(
      () => PaymentMethodsRepositoryImpl(sl<PaymentMethodsApi>()),
    );
  }
}
