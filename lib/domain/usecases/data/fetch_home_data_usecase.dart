import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class FetchHomeDataUseCase implements UseCase<Map<String, dynamic>, Map<String, dynamic>?> {
  final DataRepository repository;

  FetchHomeDataUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(Map<String, dynamic>? params) async {
    String? userId = params?['userId'];
    Map<String, dynamic>? location = params?['location'];
    return await repository.fetchHomeData(userId, location);
  }
}
