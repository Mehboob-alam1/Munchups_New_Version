import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/chef_dashboard_entity.dart';
import '../../domain/entities/chef_orders_entity.dart';
import '../../domain/entities/chef_followers_entity.dart';
import '../../domain/repositories/chef_repository.dart';
import '../datasources/remote/api_service.dart';
import '../datasources/remote/network_info.dart';

class ChefRepositoryImpl implements ChefRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChefRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ChefDashboardEntity>> fetchDashboard(
      String chefId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getChefDashboard(chefId);
        return Right(ChefDashboardEntity(
          success: response.success,
          message: response.message,
          occasions: response.occasions,
          notificationCount: response.notificationCount,
          raw: response.raw,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(NetworkFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, ChefOrdersEntity>> fetchOrders(String chefId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getChefOrders(chefId);
        return Right(ChefOrdersEntity(
          success: response.success,
          message: response.message,
          orders: response.orders,
          activeBulkOrders: response.activeBulkOrders,
          completedBulkOrders: response.completedBulkOrders,
          raw: response.raw,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(NetworkFailure('No internet connection'));
  }

  @override
  Future<Either<Failure, ChefFollowersEntity>> fetchFollowers(
      String userId, String userType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getChefFollowers(
          userId,
          userType,
        );
        return Right(ChefFollowersEntity(
          success: response.success,
          message: response.message,
          followersCount: response.followersCount,
          followingCount: response.followingCount,
          followers: response.followers,
          raw: response.raw,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(NetworkFailure('No internet connection'));
  }
}

