import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/cart_repository.dart';

class RemoveFromCartUseCase implements UseCase<bool, String> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String itemId) async {
    return await repository.removeFromCart(itemId);
  }
}
