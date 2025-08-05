import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class ChefReportFormPage extends StatefulWidget {
  String orderUniqueNumber;
  ChefReportFormPage({super.key, required this.orderUniqueNumber});

  @override
  State<ChefReportFormPage> createState() => _ChefReportFormPageState();
}

class _ChefReportFormPageState extends State<ChefReportFormPage> {
  TextEditingController textEditingController = TextEditingController();

  dynamic userData;

  String getUserType = 'buyer';

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("user_type") != null) {
        getUserType = prefs.getString("user_type").toString();
      }
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getUsertype();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: TextStrings.textKey['report']!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getSize30(context: context)),
            Text('IF you want to submit a report',
                style: white17Bold, textAlign: TextAlign.center),
            Text('against chef then write a',
                style: white17Bold, textAlign: TextAlign.center),
            Text('complete detail below',
                style: white17Bold, textAlign: TextAlign.center),
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.getSize30(context: context),
                  left: SizeConfig.getSize20(context: context),
                  right: SizeConfig.getSize20(context: context)),
              child: InputFieldsWithLightWhiteColor(
                  controller: textEditingController,
                  labelText: 'Please describe your problem',
                  textInputAction: TextInputAction.done,
                  maxLines: 8,
                  keyboardType: TextInputType.emailAddress,
                  style: black15bold,
                  onChanged: (value) {
                    setState(() {});
                  }),
            ),
            SizedBox(height: SizeConfig.getSize60(context: context)),
            CommanButton(
                heroTag: 1,
                shap: 10.0,
                width: MediaQuery.of(context).size.width * 0.5,
                buttonName: TextStrings.textKey['submit']!.toUpperCase(),
                onPressed: () {
                  if (textEditingController.text.isNotEmpty) {
                    reportApiCall(context);
                  } else {
                    Utils().myToast(context, msg: 'Please enter some text');
                  }
                })
          ],
        ),
      ),
    );
  }

  void reportApiCall(context) async {
    Utils().showSpinner(context);

    dynamic body = {
      'user_id': userData['user_id'].toString(),
      'order_unique_number': widget.orderUniqueNumber,
      'report_content': textEditingController.text.trim(),
    };

    try {
      await PostApiServer().orderReportApi(body).then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);

        if (value['success'] == 'true') {
          Utils().myToast(context, msg: value['msg']);
          if (getUserType == 'buyer') {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const BuyerHomePage());
            });
          } else if (getUserType == 'chef') {
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
          Utils().myToast(context, msg: value['msg']);
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }
}
