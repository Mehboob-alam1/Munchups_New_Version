import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../core/error/failures.dart';

class AuthFlowUseCase {
  final AuthRepository repository;

  AuthFlowUseCase({required this.repository});

  Future<bool> isAccountVerified() async {
    return await repository.isAccountVerified();
  }

  Future<void> saveVerificationStatus(String status) async {
    return await repository.saveVerificationStatus(status);
  }

  Future<void> completeRegistration(Map<String, dynamic> userData) async {
    return await repository.completeRegistration(userData);
  }

  Future<void> completeLogin(Map<String, dynamic> userData, String token) async {
    return await repository.completeLogin(userData, token);
  }

  Future<Either<Failure, bool>> logout() async {
    return await repository.logout();
  }
}

