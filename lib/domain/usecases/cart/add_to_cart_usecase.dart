import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/cart_repository.dart';
import '../../entities/cart_item.dart';

class AddToCartUseCase implements UseCase<bool, CartItem> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CartItem params) async {
    return await repository.addToCart(params);
  }
}
