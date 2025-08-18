import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/login_params.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<Map<String, dynamic>, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}
