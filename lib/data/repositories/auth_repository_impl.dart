import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/api_service.dart';
import '../datasources/local/local_storage.dart';
import '../datasources/remote/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await remoteDataSource.login(email, password);
        
        // Save user data locally
        await localDataSource.saveUserData(authResponse.data!);
        await localDataSource.saveUserType(authResponse.userType!);
        if (authResponse.token != null) {
          await localDataSource.saveAuthToken(authResponse.token!);
        }
        
        return Right({
          'user_data': authResponse.data,
          'user_type': authResponse.userType,
          'token': authResponse.token,
          'my_followers': authResponse.myFollowers,
          'currency': authResponse.currency,
        });
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await remoteDataSource.register(userData);
        
        // Save user data locally
        await localDataSource.saveUserData(authResponse.data!);
        await localDataSource.saveUserType(authResponse.userType!);
        if (authResponse.token != null) {
          await localDataSource.saveAuthToken(authResponse.token!);
        }
        
        return Right({
          'user_data': authResponse.data,
          'user_type': authResponse.userType,
          'token': authResponse.token,
          'my_followers': authResponse.myFollowers,
          'currency': authResponse.currency,
        });
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String otp, String email) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.verifyOtp(otp, email);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> resendOtp(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.resendOtp(email);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.forgotPassword(email);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await localDataSource.clearUserData();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final userData = await localDataSource.getUserData();
      final userType = await localDataSource.getUserType();
      return Right(userData != null && userType != null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUser() async {
    try {
      final userData = await localDataSource.getUserData();
      final userType = await localDataSource.getUserType();
      
      if (userData != null && userType != null) {
        return Right({
          'user_data': userData,
          'user_type': userType,
        });
      } else {
        return const Left(AuthFailure('User not logged in'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
