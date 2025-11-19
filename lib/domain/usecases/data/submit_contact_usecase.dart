import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class SubmitContactUseCase
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final DataRepository repository;

  SubmitContactUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) {
    return repository.submitContactUs(params);
  }
}

