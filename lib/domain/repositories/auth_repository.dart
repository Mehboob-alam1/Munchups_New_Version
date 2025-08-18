import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(String email, String password);
  Future<Either<Failure, Map<String, dynamic>>> register(Map<String, dynamic> userData);
  Future<Either<Failure, bool>> verifyOtp(String otp, String email);
  Future<Either<Failure, bool>> resendOtp(String email);
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUser();
}
