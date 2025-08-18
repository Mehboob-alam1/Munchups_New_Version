import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String sellerId;
  final String sellerType;
  final String sellerName;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.sellerId,
    required this.sellerType,
    required this.sellerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'seller_id': sellerId,
      'seller_type': sellerType,
      'seller_name': sellerName,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      sellerId: json['seller_id'],
      sellerType: json['seller_type'],
      sellerName: json['seller_name'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

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

  // Initialize cart from SharedPreferences
  Future<void> initializeCart() async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cartData = prefs.getString('cart');
      if (cartData != null) {
        List<dynamic> cartList = jsonDecode(cartData);
        _items = cartList.map((item) => CartItem.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
      _items = [];
    } finally {
      _setLoading(false);
    }
  }

  // Save cart to SharedPreferences
  Future<void> _saveCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> cartData = _items.map((item) => item.toJson()).toList();
      await prefs.setString('cart', jsonEncode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Add item to cart
  Future<void> addItem(CartItem item) async {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.id == item.id);
    
    if (existingIndex >= 0) {
      // Update quantity if item already exists
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        name: _items[existingIndex].name,
        image: _items[existingIndex].image,
        price: _items[existingIndex].price,
        quantity: _items[existingIndex].quantity + item.quantity,
        sellerId: _items[existingIndex].sellerId,
        sellerType: _items[existingIndex].sellerType,
        sellerName: _items[existingIndex].sellerName,
      );
    } else {
      // Add new item
      _items.add(item);
    }
    
    notifyListeners();
    await _saveCart();
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = CartItem(
          id: _items[index].id,
          name: _items[index].name,
          image: _items[index].image,
          price: _items[index].price,
          quantity: quantity,
          sellerId: _items[index].sellerId,
          sellerType: _items[index].sellerType,
          sellerName: _items[index].sellerName,
        );
      }
      notifyListeners();
      await _saveCart();
    }
  }

  // Remove item from cart
  Future<void> removeItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
    await _saveCart();
  }

  // Clear cart
  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await _saveCart();
  }

  // Check if item exists in cart
  bool isItemInCart(String itemId) {
    return _items.any((item) => item.id == itemId);
  }

  // Get item quantity
  int getItemQuantity(String itemId) {
    final item = _items.firstWhere((item) => item.id == itemId, orElse: () => CartItem(
      id: '',
      name: '',
      image: '',
      price: 0.0,
      quantity: 0,
      sellerId: '',
      sellerType: '',
      sellerName: '',
    ));
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
