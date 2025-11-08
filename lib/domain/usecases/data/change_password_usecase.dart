import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class ChangePasswordUseCase
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final DataRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) {
    return repository.changePassword(params);
  }
}
