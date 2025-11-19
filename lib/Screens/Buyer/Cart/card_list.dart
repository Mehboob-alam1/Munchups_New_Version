import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Comman widgets/alert boxes/add_comment_to oder_placed_popup.dart';
import '../../../Comman widgets/app_bar/back_icon_appbar.dart';
import '../../../Comman widgets/comman_button/comman_botton.dart';
import '../../../Component/Strings/strings.dart';
import '../../../Component/color_class/color_class.dart';
import '../../../Component/global_data/global_data.dart';
import '../../../Component/navigatepage/navigate_page.dart';
import '../../../Component/styles/styles.dart';
import '../../../Component/utils/custom_network_image.dart';
import '../../../Component/utils/sizeConfig/sizeConfig.dart';
import '../../../Component/utils/utils.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../presentation/providers/cart_provider.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CartProvider>().initializeCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: TextStrings.textKey['cart']!)),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          final items = cartProvider.items;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.getSizeHeightBy(context: context, by: 0.25),
                ),
                child:  Text('No item available', style: primary13bold),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.getSize10(context: context),
              right: SizeConfig.getSize10(context: context),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _CartItemCard(item: items[index]),
                  ),
                ),
                _CartTotals(
                  totalItems: cartProvider.totalItems,
                  totalAmount: cartProvider.totalAmount,
                  onCheckout: () {
                    final firstItem = items.first;
                    final payload = _buildOrderPayload(firstItem);

                    showDialog(
                      context: context,
                      barrierDismissible: Platform.isAndroid ? false : true,
                      builder: (context) =>
                          AddCommentToOrderForPlacedPopup(data: payload),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _buildOrderPayload(CartItem item) {
    final totalPrice = (item.price * item.quantity);
    return {
      'chef_grocer_id': item.sellerId,
      'seller_type': item.sellerType,
      'seller_name': item.sellerName,
      'dish_id': item.id,
      'dish_name': item.name,
      'dish_image': item.image,
      'quantity': item.quantity,
      'dish_price': item.price,
      'total_price': totalPrice,
      'grand_total': totalPrice,
    };
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final itemTotal = item.price * item.quantity;

    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: SizeConfig.getSizeHeightBy(context: context, by: 0.11),
                width: SizeConfig.getSizeWidthBy(context: context, by: 0.25),
                color: DynamicColor.black.withOpacity(0.3),
                child: CustomNetworkImage(
                  url: item.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: white17Bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Initial Price: $currencySymbol${item.price.toStringAsFixed(2)}',
                    style: lightWhite14Bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Price: $currencySymbol${itemTotal.toStringAsFixed(2)}',
                    style: greenColor15bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.quantity}',
                    style: lightWhite15Bold,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: () async {
                          if (item.quantity > 1) {
                            await cartProvider.updateQuantity(
                              item.id,
                              item.quantity - 1,
                            );
                          } else {
                            await cartProvider.removeItem(item.id);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item.quantity.toString(),
                          style: white17Bold,
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: () async {
                          await cartProvider.updateQuantity(
                            item.id,
                            item.quantity + 1,
                          );
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          await cartProvider.removeItem(item.id);
                          Utils().myToast(context, msg: 'Removed successfully');
                        },
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: DynamicColor.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DynamicColor.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: DynamicColor.white,
          size: 18,
        ),
      ),
    );
  }
}

class _CartTotals extends StatelessWidget {
  final int totalItems;
  final double totalAmount;
  final VoidCallback onCheckout;

  const _CartTotals({
    required this.totalItems,
    required this.totalAmount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Items:', style: white15bold),
                Text(totalItems.toString(), style: white15bold),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Sub Total:', style: white15bold),
                Text(
                  '$currencySymbol${totalAmount.toStringAsFixed(2)}',
                  style: white15bold,
                ),
              ],
            ),
            const Divider(color: DynamicColor.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Total', style: white21bold),
                Text(
                  '$currencySymbol${totalAmount.toStringAsFixed(2)}',
                  style: primary25bold,
                ),
              ],
            ),
            const SizedBox(height: 24),
            CommanButton(
              heroTag: 1,
              shap: 10.0,
              width: MediaQuery.of(context).size.width * 0.7,
              buttonName: 'Pay & Get Order Number',
              onPressed: () {
                if (totalItems == 0) {
                  Utils().myToast(context, msg: 'No Cart item available');
                } else {
                  onCheckout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
