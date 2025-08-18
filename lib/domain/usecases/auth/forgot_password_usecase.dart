import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<bool, String> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
