import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/insuficiant_amount_popup.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Card%20Payment/card_payment_form.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/presentation/providers/cart_provider.dart';

class AddCommentToOrderForPlacedPopup extends StatefulWidget {
  dynamic data;
  AddCommentToOrderForPlacedPopup({super.key, required this.data});

  @override
  State<AddCommentToOrderForPlacedPopup> createState() =>
      _AddCommentToOrderForPlacedPopupState();
}

class _AddCommentToOrderForPlacedPopupState
    extends State<AddCommentToOrderForPlacedPopup> {
  TextEditingController textEditingController = TextEditingController();

  dynamic userData;
  dynamic dishData;

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    dishData = widget.data;
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsAlignment: MainAxisAlignment.center,
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: Center(
        child: Text(
          TextStrings.textKey['add_note_to_seller']!,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.getSize20(context: context),
          ),
          child: InputFieldsWithLightWhiteColor(
              controller: textEditingController,
              labelText: TextStrings.textKey['add_note_to_seller_sub']!,
              textInputAction: TextInputAction.done,
              maxLines: 8,
              keyboardType: TextInputType.emailAddress,
              style: black15bold,
              onChanged: (value) {
                setState(() {});
              }),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CommanButton(
              heroTag: 1,
              shap: 10.0,
              hight: 35.0,
              width: MediaQuery.of(context).size.width * 0.5,
              buttonName: TextStrings.textKey['place_order']!.toUpperCase(),
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  orderPlaceApiCall(context);
                } else {
                  Utils().myToast(context, msg: 'Please enter message!');
                }
              }),
        ),
      ],
    );
  }

  void orderPlaceApiCall(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScope.of(context).requestFocus(FocusNode());
    Utils().showSpinner(context);
    try {
      dynamic body = {
        'user_id': userData['user_id'].toString(),
        'chef_grocer_id': dishData['chef_grocer_id'].toString(),
        'dish_id': dishData['dish_id'].toString(),
        'dish_name': dishData['dish_name'].toString(),
        'dish_image': dishData['dish_image'].toString(),
        'quantity': dishData['quantity'].toString(),
        'dish_price': dishData['dish_price'].toString(),
        'total_price': dishData['total_price'].toString(),
        'grand_total': dishData['total_price'].toString(),
        'note': textEditingController.text,
      };
      await PostApiServer().orderPlaceApi(body).then((value) {
        Utils().stopSpinner(context);

        if (value['success'] == 'true') {
          Utils().myToast(context, msg: value['msg']);
          prefs.remove('cart');
          if (mounted) {
            context.read<CartProvider>().initializeCart();
          }

          Timer(const Duration(milliseconds: 600), () {
            prefs.remove('cart');
            if (mounted) {
              context
                  .read<CartProvider>()
                  .initializeCart();
              PageNavigateScreen()
                  .pushRemovUntil(context, const BuyerHomePage());
            }
          });
        } else {
          if (value['status'] == 'no_customer') {
            PageNavigateScreen().push(
                context,
                CardPaymentFormPage(
                  type: 'order',
                  dishData: dishData,
                  notes: textEditingController.text.trim(),
                ));
          } else {
            Utils().myToast(context, msg: value['msg']);
            myDialog(context, value['msg']);
          }
        }
      });
    } catch (e) {
      log('cart error = ' + e.toString());
      Utils().stopSpinner(context);
    }
  }

  void myDialog(context, String msg) {
    showDialog(
        barrierDismissible: Platform.isAndroid ? false : true,
        context: context,
        builder: (context) => InsuficiantAmountPopup(
              msg: msg,
              dishData: dishData,
              notes: textEditingController.text.trim(),
            ));
  }
}
