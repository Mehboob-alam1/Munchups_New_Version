import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../presentation/providers/cart_provider.dart';

class AddToCartPopup extends StatefulWidget {
  dynamic data;
  AddToCartPopup({super.key, required this.data});

  @override
  State<AddToCartPopup> createState() => _AddToCartPopupState();
}

class _AddToCartPopupState extends State<AddToCartPopup> {
  int count = 1;
  double countPrice = 0.0;
  dynamic data;
  dynamic userData;
  dynamic checkItem;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    countPrice = double.parse(data['dish_price']);
    checkItemApi();
    getUserData();
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
    // Check if item is already in cart using CartProvider
    if (mounted) {
      final cartProvider = context.read<CartProvider>();
      await cartProvider.initializeCart();
      if (mounted) {
        setState(() {
          final isInCart = cartProvider.isItemInCart(data['dish_id'].toString());
          if (isInCart) {
            final quantity = cartProvider.getItemQuantity(data['dish_id'].toString());
            count = quantity;
            countPrice = double.parse(data['dish_price']) * count;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
        child: Text(
          TextStrings.textKey['addtocart']!,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        height: SizeConfig.getSizeHeightBy(context: context, by: 0.15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  data['dish_name'],
                  style: white15bold,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (count > 1) {
                              setState(() {
                                count--;
                                countPrice =
                                    double.parse(data['dish_price']) * count;
                              });
                            }
                          },
                          child: Container(
                            height: 25,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: DynamicColor.primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.remove,
                              color: DynamicColor.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          count.toString(),
                          style: white17Bold,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              count++;
                              countPrice =
                                  double.parse(data['dish_price']) * count;
                            });
                          },
                          child: Container(
                            height: 25,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: DynamicColor.primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.add,
                              color: DynamicColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Divider(color: DynamicColor.lightGrey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Initial Price: ', style: white15bold),
                Text('$currencySymbol${data['dish_price']}',
                    style: white15bold),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price: ', style: white15bold),
                Text(
                    '$currencySymbol${countPrice.toStringAsFixed(2).toString()}',
                    style: white15bold),
              ],
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CommanButton(
              heroTag: 1,
              shap: 10.0,
              hight: 40.0,
              width: MediaQuery.of(context).size.width * 0.4,
              buttonName: TextStrings.textKey['addtocart']!.toUpperCase(),
              textSize: 16.0,
              onPressed: () {
                if (checkItem['success'] == 'true') {
                  addToCartApiCall();
                } else {
                  Utils().myToast(context, msg: checkItem['msg']);
                }
              }),
        )
      ],
    );
  }

  void checkItemApi() async {
    try {
      GetApiServer().checkAddToCartApi(data['dish_id']).then((value) {
        setState(() {
          checkItem = value;
        });
      });
    } catch (e) {}
  }

  void addToCartApiCall() async {
    if (!mounted) return;
    
    try {
      final cartProvider = context.read<CartProvider>();
      
      // Determine seller type and ID
      final sellerId = (data['chef_id'] != null) 
          ? data['chef_id'].toString() 
          : data['grocer_id'].toString();
      final sellerType = (data['chef_id'] != null) ? 'chef' : 'grocer';
      
      // Get seller name (fallback to shop_name or full_name or user_name)
      String sellerName = 'Unknown';
      if (data['shop_name'] != null && data['shop_name'].toString().isNotEmpty && data['shop_name'] != 'NA') {
        sellerName = data['shop_name'].toString();
      } else if (data['full_name'] != null && data['full_name'].toString().isNotEmpty) {
        sellerName = data['full_name'].toString();
      } else if (data['first_name'] != null && data['last_name'] != null) {
        sellerName = '${data['first_name']} ${data['last_name']}';
      } else if (data['user_name'] != null && data['user_name'].toString().isNotEmpty) {
        sellerName = data['user_name'].toString();
      }
      
      // Create CartItem
      final cartItem = CartItem(
        id: data['dish_id'].toString(),
        name: data['dish_name'].toString(),
        image: (data['dish_images'] != null && 
                data['dish_images'] != 'NA' && 
                data['dish_images'].isNotEmpty)
            ? data['dish_images'][0]['kitchen_image'].toString()
            : '',
        price: double.parse(data['dish_price'].toString()),
        quantity: count,
        sellerId: sellerId,
        sellerType: sellerType,
        sellerName: sellerName,
      );
      
      // Add to cart using CartProvider
      await cartProvider.addItem(cartItem);
      
      if (mounted) {
        Utils().myToast(context, msg: 'Item added successfully');
        Navigator.of(context).pop(); // Close dialog
        Timer(const Duration(milliseconds: 300), () {
          if (mounted) {
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          }
        });
      }
    } catch (e) {
      log('cart error = ' + e.toString());
      if (mounted) {
        Utils().myToast(context, msg: 'Error adding item to cart');
      }
    }
  }
}
