import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class DataRepository {
  Future<Either<Failure, Map<String, dynamic>>> fetchHomeData(String? userId, Map<String, dynamic>? location);
  Future<Either<Failure, Map<String, dynamic>>> fetchUserProfile(String userId, String userType);
  Future<Either<Failure, List<dynamic>>> searchUsers(String query, String? userId);
  Future<Either<Failure, List<dynamic>>> fetchNotifications(String userId);
  Future<Either<Failure, bool>> markNotificationAsRead(String notificationId, String userId);
}
