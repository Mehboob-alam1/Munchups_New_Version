import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/app_content_entity.dart';
import '../entities/faq_entity.dart';

abstract class DataRepository {
  Future<Either<Failure, Map<String, dynamic>>> fetchHomeData(String? userId, Map<String, dynamic>? location);
  Future<Either<Failure, Map<String, dynamic>>> fetchUserProfile(String userId, String userType);
  Future<Either<Failure, List<dynamic>>> searchUsers(String query, String? userId);
  Future<Either<Failure, List<dynamic>>> fetchNotifications(String userId);
  Future<Either<Failure, bool>> markNotificationAsRead(String notificationId, String userId);
  Future<Either<Failure, AppContentEntity>> fetchAppContent();
  Future<Either<Failure, FaqEntity>> fetchFaqContent();
  Future<Either<Failure, Map<String, dynamic>>> changePassword(Map<String, dynamic> body);
  Future<Either<Failure, Map<String, dynamic>>> submitContactUs(Map<String, dynamic> body);
  Future<Either<Failure, Map<String, dynamic>>> updateProfile(
    Map<String, dynamic> body,
    String? imagePath,
  );
}
