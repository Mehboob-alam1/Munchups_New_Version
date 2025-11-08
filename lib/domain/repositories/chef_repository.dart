import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/chef_dashboard_entity.dart';
import '../entities/chef_orders_entity.dart';
import '../entities/chef_followers_entity.dart';

abstract class ChefRepository {
  Future<Either<Failure, ChefDashboardEntity>> fetchDashboard(String chefId);
  Future<Either<Failure, ChefOrdersEntity>> fetchOrders(String chefId);
  Future<Either<Failure, ChefFollowersEntity>> fetchFollowers(
    String userId,
    String userType,
  );
}

