import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';

import '../../Screens/Chef/Home/home_model.dart';

class ChnageOrderStatusPopup extends StatefulWidget {
  OcCategoryOrderArr data;
  String name;
  ChnageOrderStatusPopup({super.key, required this.data, required this.name});

  @override
  State<ChnageOrderStatusPopup> createState() => _ChnageOrderStatusPopupState();
}

class _ChnageOrderStatusPopupState extends State<ChnageOrderStatusPopup> {
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
        'Are you sure you want to ${widget.name.toLowerCase()} order?',
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
                          changeStatus(context);
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

  void changeStatus(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await GetApiServer()
          .changeProposalStatusApi(widget.data.foodId.toString(),
              widget.data.proposalId.toString(), widget.data.buyerId.toString())
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
