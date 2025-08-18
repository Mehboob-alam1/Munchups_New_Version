import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class FetchNotificationsUseCase implements UseCase<List<dynamic>, String> {
  final DataRepository repository;

  FetchNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(String userId) async {
    return await repository.fetchNotifications(userId);
  }
}
