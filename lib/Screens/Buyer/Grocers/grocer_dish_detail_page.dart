import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/Custom%20Slider/custome_slider.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../presentation/providers/cart_provider.dart';

class GrocerDishDetailPage extends StatefulWidget {
  dynamic dishID;
  dynamic userID;
  dynamic buyerDetail;
  GrocerDishDetailPage({
    super.key,
    required this.dishID,
    required this.userID,
    required this.buyerDetail,
  });

  @override
  State<GrocerDishDetailPage> createState() => _GrocerDishDetailPageState();
}

class _GrocerDishDetailPageState extends State<GrocerDishDetailPage> {
  int count = 1;
  double countPrice = 0.0;

  bool isLoading = false;

  List sliderImages = [];

  dynamic dishData;
  dynamic userData;

  @override
  void initState() {
    super.initState();

    dishDetailApiCall();
  }

  void dishDetailApiCall() async {
    setState(() {
      isLoading = true;
      sliderImages.clear();
    });
    try {
      await GetApiServer()
          .dishDetailApi(widget.dishID, widget.userID)
          .then((value) {
        setState(() {
          isLoading = false;

          if (value != null) {
            dishData = value['all_grocery'][0]['all_dish_grocer'][0];

            userData = value['all_grocery'][0];
            for (var element in value['all_grocery'][0]['all_dish_grocer'][0]
                ['dish_images']) {
              sliderImages.add(element['kitchen_image']);
            }
            getCartItem();
          }
        });
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void getCartItem() async {
    if (!mounted) return;
    try {
      final cartProvider = context.read<CartProvider>();
      await cartProvider.initializeCart();
      if (mounted) {
        setState(() {
          final isInCart = cartProvider.isItemInCart(dishData['dish_id'].toString());
          if (isInCart) {
            final quantity = cartProvider.getItemQuantity(dishData['dish_id'].toString());
            count = quantity;
            countPrice = double.parse(dishData['dish_price']) * count;
          }
        });
      }
    } catch (e) {
      log('Error getting cart item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: button(),
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(color: DynamicColor.primaryColor))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSlider(list: sliderImages),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dishData['dish_name'],
                                  style: white21bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text('$currencySymbol${dishData['dish_price']}',
                                  style: const TextStyle(
                                    color: DynamicColor.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 35,
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: DynamicColor.borderline),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star,
                                        color: DynamicColor.primaryColor,
                                        size: 18),
                                    Text(
                                        ' ${userData['avg_rating'].toString()}',
                                        style: white13w5),
                                  ],
                                ),
                              ),
                              addtoCard(),
                            ],
                          ),
                          const Divider(color: DynamicColor.white),
                          serviceTypeAndPerson(),
                          const SizedBox(height: 5),
                          Text('Item Description', style: primary17w6),
                          const SizedBox(height: 10),
                          Text(dishData['dish_description'])
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget serviceTypeAndPerson() {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
          child: Card(
            color: DynamicColor.boxColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Phone No.',
                      style: lightWhite14Bold, textAlign: TextAlign.center),
                  const SizedBox(height: 5),
                  Text(
                      (userData['phone'] == null)
                          ? 'No available'
                          : formatMobileNumber(userData['phone']),
                      style: primary15w5),
                ],
              ),
            ),
          ),
        )),
        Expanded(
            child: SizedBox(
          height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
          child: Card(
            color: DynamicColor.boxColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Miles',
                    style: lightWhite14Bold, textAlign: TextAlign.center),
                const SizedBox(height: 5),
                Text(
                  (userData['postal_code'] == null)
                      ? 'No available'
                      : double.parse(userData['distance'].toString())
                          .toStringAsFixed(2),
                  style: primary15w5,
                )
              ],
            ),
          ),
        )),
        Expanded(
            child: SizedBox(
          height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
          child: Card(
            color: DynamicColor.boxColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Service Type',
                    style: lightWhite14Bold, textAlign: TextAlign.center),
                const SizedBox(height: 5),
                Text(
                  dishData['service_type'].toString().toUpperCase(),
                  style: primary15w5,
                )
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget addtoCard() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        height: 40,
        padding: const EdgeInsets.only(left: 8, right: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: DynamicColor.borderline),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (count > 1) {
                  setState(() {
                    count--;
                    countPrice = double.parse(dishData['dish_price']) * count;
                  });
                }
              },
              child: const Icon(
                Icons.remove,
                color: DynamicColor.white,
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
                  countPrice = double.parse(dishData['dish_price']) * count;
                });
              },
              child: const Icon(
                Icons.add,
                color: DynamicColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FloatingActionButton.extended(
          elevation: 2.0,
          heroTag: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: DynamicColor.primaryColor,
          label: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Add to Cart', style: white15bold),
                const SizedBox(width: 10),
                countPrice == 0.0
                    ? dishData == null
                        ? Text('$currencySymbol 0.00', style: secondry18bold)
                        : Text('$currencySymbol${dishData['dish_price']}',
                            style: secondry18bold)
                    : Text(
                        '$currencySymbol${countPrice.toStringAsFixed(2).toString()}',
                        style: secondry18bold)
              ],
            ),
          ),
          onPressed: () {
            if (widget.buyerDetail != null) {
              addToCartApiCall();
            } else {
              PageNavigateScreen().push(context, const LoginPage());
            }
          }),
    );
  }

  void addToCartApiCall() async {
    if (!mounted) return;
    
    try {
      final cartProvider = context.read<CartProvider>();
      
      // Get seller name from userData
      String sellerName = 'Unknown';
      if (userData['shop_name'] != null && userData['shop_name'].toString().isNotEmpty && userData['shop_name'] != 'NA') {
        sellerName = userData['shop_name'].toString();
      } else if (userData['full_name'] != null && userData['full_name'].toString().isNotEmpty) {
        sellerName = userData['full_name'].toString();
      } else if (userData['first_name'] != null && userData['last_name'] != null) {
        sellerName = '${userData['first_name']} ${userData['last_name']}';
      } else if (userData['user_name'] != null && userData['user_name'].toString().isNotEmpty) {
        sellerName = userData['user_name'].toString();
      }
      
      // Create CartItem
      final cartItem = CartItem(
        id: dishData['dish_id'].toString(),
        name: dishData['dish_name'].toString(),
        image: sliderImages.isNotEmpty
            ? dishData['dish_images'][0]['kitchen_image'].toString()
            : '',
        price: double.parse(dishData['dish_price'].toString()),
        quantity: count,
        sellerId: dishData['grocer_id'].toString(),
        sellerType: 'grocer',
        sellerName: sellerName,
      );
      
      // Add to cart using CartProvider
      await cartProvider.addItem(cartItem);
      
      if (mounted) {
        Utils().myToast(context, msg: 'Item added successfully');
        Timer(const Duration(milliseconds: 500), () {
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
