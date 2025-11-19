import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/faq_entity.dart';
import '../../repositories/data_repository.dart';

class FetchFaqContentUseCase implements UseCase<FaqEntity, NoParams> {
  final DataRepository repository;

  FetchFaqContentUseCase(this.repository);

  @override
  Future<Either<Failure, FaqEntity>> call(NoParams params) {
    return repository.fetchFaqContent();
  }
}

