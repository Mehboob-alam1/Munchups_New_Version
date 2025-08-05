import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/order_confirmation_popup.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPPopup extends StatefulWidget {
  dynamic data;
  String orderType;
  OTPPopup({
    super.key,
    required this.data,
    required this.orderType,
  });

  @override
  State<OTPPopup> createState() => _OTPPopupState();
}

class _OTPPopupState extends State<OTPPopup> {
  TextEditingController textEditingController = TextEditingController();

  dynamic userData;
  dynamic dishData;

  String userType = 'chef';

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("user_type").toString();
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
      contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Center(
        child: Text(
          'Please ask buyer to disclose the OTP you releasing a payment',
          style: TextStyle(
              color: DynamicColor.white,
              fontWeight: FontWeight.bold,
              fontSize: 17),
          textAlign: TextAlign.center,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.getSize30(context: context),
          ),
          child: InputFieldsWithLightWhiteColor(
              controller: textEditingController,
              labelText: 'Enter OTP',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              style: black15bold,
              onChanged: (value) {
                setState(() {});
              }),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: CommanButton(
              heroTag: 1,
              shap: 10.0,
              hight: 35.0,
              width: MediaQuery.of(context).size.width * 0.3,
              buttonName: 'Verify',
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  if (widget.orderType == 'single order') {
                    PageNavigateScreen().back(context);
                    showDialog(
                        context: context,
                        barrierDismissible: Platform.isAndroid ? false : true,
                        builder: (context) => ConfirmConpleteOrderPopup(
                              data: dishData,
                              otp: textEditingController.text.trim(),
                              userType: userType,
                            ));
                  } else {
                    otpApiCall(context);
                  }
                } else {
                  Utils().myToast(context, msg: 'Please enter OTP');
                }
              }),
        ),
      ],
    );
  }

  void otpApiCall(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Utils().showSpinner(context);
    try {
      await GetApiServer()
          .orderOtpVerifyApi(dishData['order_unique_number'].toString(),
              textEditingController.text.trim())
          .then((value) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          if (userType == 'chef') {
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
        } else {
          PageNavigateScreen().back(context);
        }
      });
    } catch (e) {
      log('cart error = ' + e.toString());
      Utils().stopSpinner(context);
    }
  }
}
