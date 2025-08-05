import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';

class ConfirmConpleteOrderPopup extends StatefulWidget {
  dynamic data;
  String otp;
  String userType;
  ConfirmConpleteOrderPopup({
    super.key,
    required this.data,
    required this.otp,
    required this.userType,
  });

  @override
  State<ConfirmConpleteOrderPopup> createState() =>
      _ConfirmConpleteOrderPopupState();
}

class _ConfirmConpleteOrderPopupState extends State<ConfirmConpleteOrderPopup> {
  bool isLoading = false;
  dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          'Order Confirmation',
          style: TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: const Text(
        'Are you sure you want to complete order?',
        textAlign: TextAlign.center,
      ),
      actions: [
        isLoading == false
            ? Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CommanButton(
                        hight: 40.0,
                        width: 60.0,
                        buttonName: TextStrings.textKey['no']!,
                        buttonBGColor: DynamicColor.green,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shap: 7),
                    CommanButton(
                        hight: 40.0,
                        width: 60.0,
                        buttonName: TextStrings.textKey['yes']!,
                        buttonBGColor: DynamicColor.primaryColor,
                        onPressed: () {
                          completeOrder(context);
                        },
                        shap: 7)
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ),
              )
      ],
    );
  }

// /8W7B9Z
  void completeOrder(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await GetApiServer()
          .completeOrderOtpVerifyApi(data['order_unique_number'].toString(),
              widget.otp, data['buyer_id'])
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          if (widget.userType == 'chef') {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const ChefHomePage());
            });
          } else {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const GrocerHomePage());
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
