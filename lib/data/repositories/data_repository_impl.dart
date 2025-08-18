import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/repositories/data_repository.dart';
import '../datasources/remote/api_service.dart';
import '../datasources/local/local_storage.dart';
import '../datasources/remote/network_info.dart';

class DataRepositoryImpl implements DataRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DataRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchHomeData(String? userId, Map<String, dynamic>? location) async {
    if (await networkInfo.isConnected) {
      try {
        final homeData = await remoteDataSource.getHomeData(userId, location);
        return Right({
          'data': homeData.data,
          'chefs': homeData.chefs,
          'grocers': homeData.grocers,
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
  Future<Either<Failure, Map<String, dynamic>>> fetchUserProfile(String userId, String userType) async {
    if (await networkInfo.isConnected) {
      try {
        final userProfile = await remoteDataSource.getUserProfile(userId, userType);
        return Right({
          'success': userProfile.success,
          'msg': userProfile.msg,
          'data': userProfile.data,
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
  Future<Either<Failure, List<dynamic>>> searchUsers(String query, String? userId) async {
    if (await networkInfo.isConnected) {
      try {
        final searchResponse = await remoteDataSource.searchUsers(query, userId);
        return Right(searchResponse.data ?? []);
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
  Future<Either<Failure, List<dynamic>>> fetchNotifications(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final notifications = await remoteDataSource.getNotifications(userId);
        return Right(notifications.map((n) => n.toJson()).toList());
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
  Future<Either<Failure, bool>> markNotificationAsRead(String notificationId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.markNotificationAsRead(notificationId, userId);
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
}
