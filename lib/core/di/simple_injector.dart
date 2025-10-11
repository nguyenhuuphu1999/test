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

final sl = GetIt.instance;

Future<void> initSimpleDI() async {
  // Platform info
  final platformInfo = await PlatformInfo.load();
  sl.registerSingleton(platformInfo);

  // Register interceptors
  sl.registerLazySingleton(() => CorrelationInterceptor());
  sl.registerLazySingleton(() => DeviceInterceptor(sl<PlatformInfo>()));
  
  // Create a temporary Dio for auth interceptor
  final tempDio = Dio();
  sl.registerLazySingleton(() => AuthInterceptor(dio: tempDio));

  // Build final Dio client
  final dio = buildDio(
    authInterceptor: sl(),
    correlationInterceptor: sl(),
    deviceInterceptor: sl(),
  );

  // Register the final Dio client
  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerLazySingleton(() => DioClient(dio));

  // Auth feature
  sl.registerLazySingleton(() => AuthApi(sl<DioClient>()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authApi: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
}
