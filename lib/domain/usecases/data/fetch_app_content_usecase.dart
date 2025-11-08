import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/app_content_entity.dart';
import '../../repositories/data_repository.dart';

class FetchAppContentUseCase
    implements UseCase<AppContentEntity, NoParams> {
  final DataRepository repository;

  FetchAppContentUseCase(this.repository);

  @override
  Future<Either<Failure, AppContentEntity>> call(NoParams params) {
    return repository.fetchAppContent();
  }
}
