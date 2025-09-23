import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:munchups_app/domain/usecases/auth/register_usecase.dart';
import 'package:munchups_app/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_usecase.dart';
import 'login_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../core/error/failures.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => AuthFlowUseCase(repository: sl())); // Add this

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
  
  // Register AuthFlowProvider
  sl.registerFactory(() => AuthFlowProvider());
}
