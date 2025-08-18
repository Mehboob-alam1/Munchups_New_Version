import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String sellerId;
  final String sellerType;
  final String sellerName;

  const CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.sellerId,
    required this.sellerType,
    required this.sellerName,
  });

  @override
  List<Object> get props => [id, name, image, price, quantity, sellerId, sellerType, sellerName];

  CartItem copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? sellerId,
    String? sellerType,
    String? sellerName,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      sellerId: sellerId ?? this.sellerId,
      sellerType: sellerType ?? this.sellerType,
      sellerName: sellerName ?? this.sellerName,
    );
  }
}
