import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class FetchUserProfileUseCase implements UseCase<Map<String, dynamic>, Map<String, String>> {
  final DataRepository repository;

  FetchUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(Map<String, String> params) async {
    return await repository.fetchUserProfile(params['userId']!, params['userType']!);
  }
}
