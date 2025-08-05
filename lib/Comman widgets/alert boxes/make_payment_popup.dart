import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';

class MakePaymentToAcceptPopup extends StatefulWidget {
  String proposalId;

  MakePaymentToAcceptPopup({super.key, required this.proposalId});

  @override
  State<MakePaymentToAcceptPopup> createState() =>
      _MakePaymentToAcceptPopupState();
}

class _MakePaymentToAcceptPopupState extends State<MakePaymentToAcceptPopup> {
  TextEditingController textEditingController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          'Munchups Information!',
          style: TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: const Text(
        'Are you sure you want to pay this order?',
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
                          payOrderStatus(context);
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

  void payOrderStatus(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await PostApiServer()
          .makePaymentApi(widget.proposalId.toString())
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          });
        } else {
          PageNavigateScreen().back(context);
        }
      });
    } catch (e) {
      PageNavigateScreen().back(context);
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
