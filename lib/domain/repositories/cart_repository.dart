import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, bool>> addToCart(CartItem item);
  Future<Either<Failure, bool>> removeFromCart(String itemId);
  Future<Either<Failure, bool>> updateCartItem(String itemId, int quantity);
  Future<Either<Failure, bool>> clearCart();
  Future<Either<Failure, int>> getCartCount();
}
