import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
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

class DetailPage extends StatefulWidget {
  dynamic userData;
  dynamic data;
  dynamic guestUserData;
  DetailPage({
    super.key,
    required this.userData,
    required this.data,
    required this.guestUserData,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int count = 1;
  double countPrice = 0.0;

  bool isLoading = false;

  List sliderImages = [];

  dynamic dishData;
  dynamic userData;
  dynamic checkItemLocal;

  @override
  void initState() {
    super.initState();
    dishData = widget.data;
    if (dishData['kitchen_image'] != 'NA') {
      for (var element in dishData['dish_images']) {
        sliderImages.add(element['kitchen_image']);
      }
    }

    userData = widget.userData;
    getCartItem();
  }

  void getCartItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkItemLocal = jsonDecode(prefs.getString('cart').toString());
      if (checkItemLocal != null) {
        if (checkItemLocal['dish_id'] == dishData['dish_id']) {
          countPrice = checkItemLocal['total_price'];
        }
      }
    });
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
    return Column(
      children: [
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text('Dish Serving Time',
        //         style: lightWhite14Bold, textAlign: TextAlign.center),
        //     const SizedBox(height: 5),
        //     Text('Start: ${dishData['start_time']}', style: green13bold),
        //     Text('End: ${dishData['end_time']}', style: primary13bold)
        //   ],
        // ),
        const SizedBox(height: 5),
        Center(child: Text('Dish Serving time', style: white17Bold)),
        Center(
          child: Text('${dishData['start_time']} - ${dishData['end_time']}',
              style: primary15w5),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: SizedBox(
              height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
              child: Card(
                color: DynamicColor.boxColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Meal',
                          style: lightWhite14Bold, textAlign: TextAlign.center),
                      const SizedBox(height: 5),
                      Text(dishData['meal'].toString().toUpperCase(),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
            Expanded(
                child: SizedBox(
              height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
              child: Card(
                color: DynamicColor.boxColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Portion Per Persion',
                        style: lightWhite14Bold, textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    Text(
                      dishData['portion'].toString(),
                      style: primary15w5,
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
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
            if (widget.guestUserData != null) {
              if (checkItemLocal == null) {
                addToCartApiCall();
              } else {
                Utils().myToast(context, msg: 'Item already added!');
              }
            } else {
              PageNavigateScreen().push(context, const LoginPage());
            }
          }),
    );
  }

  void addToCartApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      dynamic body = {
        'user_id': userData['user_id'],
        'chef_grocer_id': dishData['chef_id'],
        'dish_id': dishData['dish_id'],
        'dish_name': dishData['dish_name'],
        'dish_image': dishData['dish_images'] == 'NA'
            ? ''
            : dishData['dish_images'][0]['kitchen_image'],
        'quantity': count,
        'dish_price': double.parse(dishData['dish_price']),
        'total_price': countPrice == 0.0
            ? double.parse(dishData['dish_price'])
            : countPrice,
      };

      prefs.setString('cart', jsonEncode(body));
      Utils().myToast(context, msg: 'Item added succesfully');
      Timer(const Duration(milliseconds: 500), () {
        PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
      });
    } catch (e) {
      log('cart error = ' + e.toString());
    }
  }
}
