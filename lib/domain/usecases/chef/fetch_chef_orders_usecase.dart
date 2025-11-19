import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/chef_orders_entity.dart';
import '../../repositories/chef_repository.dart';

class FetchChefOrdersUseCase
    implements UseCase<ChefOrdersEntity, String> {
  final ChefRepository repository;

  FetchChefOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, ChefOrdersEntity>> call(String params) {
    return repository.fetchOrders(params);
  }
}


