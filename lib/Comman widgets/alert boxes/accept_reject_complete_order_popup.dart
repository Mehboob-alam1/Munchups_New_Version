import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/otp_popup.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/utils.dart';

class AcceptRejectCompleteOrderPopup extends StatefulWidget {
  String title;
  String orderID;
  String buyerID;
  String amount;
  String status;
  dynamic data;

  AcceptRejectCompleteOrderPopup({
    super.key,
    required this.title,
    required this.orderID,
    required this.buyerID,
    required this.amount,
    required this.status,
    this.data,
  });

  @override
  State<AcceptRejectCompleteOrderPopup> createState() =>
      _AcceptRejectCompleteOrderPopupState();
}

class _AcceptRejectCompleteOrderPopupState
    extends State<AcceptRejectCompleteOrderPopup> {
  TextEditingController textEditingController = TextEditingController();

  bool isLoading = false;

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
      content: Text(
        'Are you sure you want to ${widget.title} this order?',
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
                          PageNavigateScreen().back(context);
                        },
                        shap: 7),
                    CommanButton(
                        hight: 40.0,
                        width: 60.0,
                        buttonName: TextStrings.textKey['yes']!,
                        buttonBGColor: DynamicColor.primaryColor,
                        onPressed: () {
                          if (widget.title == 'complete') {
                            PageNavigateScreen().back(context);
                            showDialog(
                                barrierDismissible:
                                    Platform.isAndroid ? false : true,
                                context: context,
                                builder: (context) => OTPPopup(
                                      data: widget.data,
                                      orderType: 'single order',
                                    ));
                          } else {
                            cheangeOrderStatusApiCall(context, widget.orderID,
                                widget.buyerID, widget.amount, widget.status);
                          }
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

  void cheangeOrderStatusApiCall(
      context, orderID, buyerID, amount, status) async {
    Utils().showSpinner(context);
    try {
      await PostApiServer()
          .changeOrderStatusApi(orderID.toString(), buyerID.toString(),
              double.parse(amount).toStringAsFixed(0), status.toString())
          .then((value) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          PageNavigateScreen().back(context);
        } else {
          PageNavigateScreen().back(context);
        }
      });
    } catch (e) {
      setState(() {});
      log(e.toString());
      Utils().stopSpinner(context);
    }
  }
}
