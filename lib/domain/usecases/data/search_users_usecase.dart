import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class SearchUsersUseCase implements UseCase<List<dynamic>, Map<String, String?>> {
  final DataRepository repository;

  SearchUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(Map<String, String?> params) async {
    return await repository.searchUsers(params['query']!, params['userId']);
  }
}
