import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/remote/api_service.dart';
import '../../data/datasources/remote/network_info.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/data_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/data_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../domain/usecases/cart/remove_from_cart_usecase.dart';
import '../../domain/usecases/cart/update_cart_usecase.dart';
import '../../domain/usecases/data/fetch_home_data_usecase.dart';
import '../../domain/usecases/data/fetch_user_profile_usecase.dart';
import '../../domain/usecases/data/search_users_usecase.dart';
import '../../domain/usecases/data/fetch_notifications_usecase.dart';
import '../../presentation/providers/app_provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/cart_provider.dart';
import '../../presentation/providers/data_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  // Features - Cart
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartUseCase(sl()));

  // Features - Data
  sl.registerLazySingleton(() => FetchHomeDataUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => SearchUsersUseCase(sl()));
  sl.registerLazySingleton(() => FetchNotificationsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<DataRepository>(
    () => DataRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio());

  // Providers
  sl.registerFactory(() => AppProvider());
  sl.registerFactory(() => AuthProvider(
        loginUseCase: sl(),
        registerUseCase: sl(),
        verifyOtpUseCase: sl(),
        forgotPasswordUseCase: sl(),
      ));
  sl.registerFactory(() => CartProvider(
        addToCartUseCase: sl(),
        removeFromCartUseCase: sl(),
        updateCartUseCase: sl(),
      ));
  sl.registerFactory(() => DataProvider(
        fetchHomeDataUseCase: sl(),
        fetchUserProfileUseCase: sl(),
        searchUsersUseCase: sl(),
        fetchNotificationsUseCase: sl(),
      ));
}
