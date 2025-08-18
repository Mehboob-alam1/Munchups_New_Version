import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/providers/main_provider.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:provider/provider.dart';

import '../Component/providers/cart_provider.dart';

class AddToCard extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemImage;
  final double itemPrice;
  final String sellerId;
  final String sellerType;
  final String sellerName;

  const AddToCard({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.sellerId,
    required this.sellerType,
    required this.sellerName,
  });

  @override
  State<AddToCard> createState() => _AddToCardState();
}

class _AddToCardState extends State<AddToCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isItemInCart(widget.itemId);
        final currentQuantity = cartProvider.getItemQuantity(widget.itemId);
        
        if (isInCart) {
          // Item is in cart - show quantity controls
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: DynamicColor.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrease quantity button
                InkWell(
                  onTap: () async {
                    if (currentQuantity > 1) {
                      await cartProvider.updateQuantity(widget.itemId, currentQuantity - 1);
                    } else {
                      await cartProvider.removeItem(widget.itemId);
                    }
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: DynamicColor.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 16,
                      color: DynamicColor.primaryColor,
                    ),
                  ),
                ),
                
                // Quantity display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    currentQuantity.toString(),
                    style: white15bold,
                  ),
                ),
                
                // Increase quantity button
                InkWell(
                  onTap: () async {
                    await cartProvider.updateQuantity(widget.itemId, currentQuantity + 1);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: DynamicColor.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: DynamicColor.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Item not in cart - show add button
          return InkWell(
            onTap: () async {
              final cartItem = CartItem(
                id: widget.itemId,
                name: widget.itemName,
                image: widget.itemImage,
                price: widget.itemPrice,
                quantity: 1,
                sellerId: widget.sellerId,
                sellerType: widget.sellerType,
                sellerName: widget.sellerName,
              );
              
              await cartProvider.addItem(cartItem);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.itemName} added to cart'),
                  backgroundColor: DynamicColor.primaryColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: DynamicColor.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_shopping_cart,
                    color: DynamicColor.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add to Cart',
                    style: white15bold,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
