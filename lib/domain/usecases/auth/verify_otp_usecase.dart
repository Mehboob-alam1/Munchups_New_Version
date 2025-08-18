import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<bool, Map<String, String>> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Map<String, String> params) async {
    return await repository.verifyOtp(params['otp']!, params['email']!);
  }
}
