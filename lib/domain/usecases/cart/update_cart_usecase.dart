import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/cart_repository.dart';

class UpdateCartUseCase implements UseCase<bool, Map<String, dynamic>> {
  final CartRepository repository;

  UpdateCartUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Map<String, dynamic> params) async {
    return await repository.updateCartItem(params['itemId'], params['quantity']);
  }
}
