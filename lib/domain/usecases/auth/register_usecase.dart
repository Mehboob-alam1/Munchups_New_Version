import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(Map<String, dynamic> params) async {
    return await repository.register(params);
  }
}
