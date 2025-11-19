import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../domain/usecases/cart/remove_from_cart_usecase.dart';
import '../../domain/usecases/cart/update_cart_usecase.dart';
import '../../domain/usecases/cart/get_cart_items_usecase.dart';
import '../../core/usecases/usecase.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  // Use Cases
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartUseCase updateCartUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;

  CartProvider({
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartUseCase,
    required this.getCartItemsUseCase,
  });

  // Getters
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.length;
  
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Initialize cart
  Future<void> initializeCart() async {
    _setLoading(true);
    try {
      final result = await getCartItemsUseCase(NoParams());
      result.fold(
        (failure) {
          debugPrint('Error loading cart: ${failure.message}');
          _items = [];
        },
        (items) {
          _items = items;
        },
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing cart: $e');
      _items = [];
    } finally {
      _setLoading(false);
    }
  }

  // Add item to cart
  Future<void> addItem(CartItem item) async {
    try {
      final result = await addToCartUseCase(item);
      
      result.fold(
        (failure) {
          debugPrint('Error adding item to cart: ${failure.message}');
        },
        (success) {
          if (success) {
            final existingIndex = _items.indexWhere((cartItem) => cartItem.id == item.id);
            
            if (existingIndex >= 0) {
              // Update quantity if item already exists
              _items[existingIndex] = _items[existingIndex].copyWith(
                quantity: _items[existingIndex].quantity + item.quantity,
              );
            } else {
              // Add new item
              _items.add(item);
            }
            
            notifyListeners();
          }
        },
      );
    } catch (e) {
      debugPrint('Error adding item to cart: $e');
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      final result = await updateCartUseCase({
        'itemId': itemId,
        'quantity': quantity,
      });
      
      result.fold(
        (failure) {
          debugPrint('Error updating cart: ${failure.message}');
        },
        (success) {
          if (success) {
            final index = _items.indexWhere((item) => item.id == itemId);
            if (index >= 0) {
              if (quantity <= 0) {
                _items.removeAt(index);
              } else {
                _items[index] = _items[index].copyWith(quantity: quantity);
              }
              notifyListeners();
            }
          }
        },
      );
    } catch (e) {
      debugPrint('Error updating cart: $e');
    }
  }

  // Remove item from cart
  Future<void> removeItem(String itemId) async {
    try {
      final result = await removeFromCartUseCase(itemId);
      
      result.fold(
        (failure) {
          debugPrint('Error removing item from cart: ${failure.message}');
        },
        (success) {
          if (success) {
            _items.removeWhere((item) => item.id == itemId);
            notifyListeners();
          }
        },
      );
    } catch (e) {
      debugPrint('Error removing item from cart: $e');
    }
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Check if item exists in cart
  bool isItemInCart(String itemId) {
    return _items.any((item) => item.id == itemId);
  }

  // Get item quantity
  int getItemQuantity(String itemId) {
    final item = _items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => const CartItem(
        id: '',
        name: '',
        image: '',
        price: 0.0,
        quantity: 0,
        sellerId: '',
        sellerType: '',
        sellerName: '',
      ),
    );
    return item.quantity;
  }

  // Loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get cart count for display
  int get cartCount => totalItems;
}
