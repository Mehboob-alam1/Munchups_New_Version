import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../datasources/local/local_storage.dart';

class CartRepositoryImpl implements CartRepository {
  final LocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final cartData = await localDataSource.getCartData();
      final cartItems = cartData.map((json) => CartItem(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        price: (json['price'] ?? 0.0).toDouble(),
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        sellerId: json['seller_id'] ?? '',
        sellerType: json['seller_type'] ?? '',
        sellerName: json['seller_name'] ?? '',
      )).toList();
      
      return Right(cartItems);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addToCart(CartItem item) async {
    try {
      final currentCart = await localDataSource.getCartData();
      
      // Check if item already exists
      final existingIndex = currentCart.indexWhere((cartItem) => cartItem['id'] == item.id);
      
      if (existingIndex >= 0) {
        // Update quantity
        final prevQty = (currentCart[existingIndex]['quantity'] as num?)?.toInt() ?? 0;
        currentCart[existingIndex]['quantity'] = prevQty + item.quantity;
      } else {
        // Add new item
        currentCart.add({
          'id': item.id,
          'name': item.name,
          'image': item.image,
          'price': item.price,
          'quantity': item.quantity,
          'seller_id': item.sellerId,
          'seller_type': item.sellerType,
          'seller_name': item.sellerName,
        });
      }
      
      await localDataSource.saveCartData(currentCart);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(String itemId) async {
    try {
      final currentCart = await localDataSource.getCartData();
      currentCart.removeWhere((item) => item['id'] == itemId);
      await localDataSource.saveCartData(currentCart);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCartItem(String itemId, int quantity) async {
    try {
      final currentCart = await localDataSource.getCartData();
      final itemIndex = currentCart.indexWhere((item) => item['id'] == itemId);
      
      if (itemIndex >= 0) {
        if (quantity <= 0) {
          currentCart.removeAt(itemIndex);
        } else {
          currentCart[itemIndex]['quantity'] = quantity;
        }
        await localDataSource.saveCartData(currentCart);
        return const Right(true);
      } else {
        return const Left(CacheFailure('Item not found in cart'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearCart() async {
    try {
      await localDataSource.saveCartData([]);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCartCount() async {
    try {
      final cartData = await localDataSource.getCartData();
      final totalItems = cartData.fold<int>(0, (sum, item) => sum + ((item['quantity'] as num?)?.toInt() ?? 0));
      return Right(totalItems);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
