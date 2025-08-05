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
  dynamic checkItemLocal;

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
      //prefs.remove('cart').toString();
      checkItemLocal = jsonDecode(prefs.getString('cart').toString());
    });
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
                  if (checkItemLocal == null) {
                    addToCartApiCall();
                  } else {
                    Utils().myToast(context, msg: 'Item already added!');
                  }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      dynamic body = {
        'user_id': userData['user_id'],
        'chef_grocer_id':
            (data['chef_id'] != null) ? data['chef_id'] : data['grocer_id'],
        'dish_id': data['dish_id'],
        'dish_name': data['dish_name'],
        'dish_image': data['dish_images'] == 'NA'
            ? ''
            : data['dish_images'][0]['kitchen_image'],
        'quantity': count,
        'dish_price': double.parse(data['dish_price']),
        'total_price': countPrice,
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
