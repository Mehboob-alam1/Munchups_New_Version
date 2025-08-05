import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  dynamic data;
  ReportPage({super.key, required this.data});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List reportList = [
    {'title': 'Abusive images or contents in ad', 'isSelected': false},
    {'title': 'Payment mode but order not received', 'isSelected': false},
    {'title': 'Order delivered but payment not received', 'isSelected': false},
    {
      'title': "Dosen't match description of item what I bought from seller",
      'isSelected': false
    },
    {'title': 'Antisocial behavior by buyer', 'isSelected': false},
    {'title': 'Antisocial behavior by seller', 'isSelected': false},
    {
      'title': "Wrong items sold on our platform which shouldn't be here",
      'isSelected': false
    },
  ];
  int selectedItemIndex = 0;

  dynamic userData;

  String getUserType = 'buyer';
  String selectMsg = 'Abusive images or contents in ad';
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: reportList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    elevation: 5,
                    color: DynamicColor.boxColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: RadioListTile(
                      title: Text(reportList[index]['title']),
                      value: index,
                      groupValue: selectedItemIndex,
                      onChanged: (value) {
                        setState(() {
                          selectedItemIndex = value as int;
                          selectMsg = reportList[selectedItemIndex]['title'];
                          for (var i = 0; i < reportList.length; i++) {
                            reportList[i]['isSelected'] = (i == value);
                          }
                        });
                      },
                      selected: reportList[index]['isSelected'],
                    ),
                  ),
                );
              }),
          SizedBox(height: SizeConfig.getSize60(context: context)),
          CommanButton(
              heroTag: 1,
              shap: 10.0,
              width: MediaQuery.of(context).size.width * 0.5,
              buttonName: TextStrings.textKey['submit']!.toUpperCase(),
              onPressed: () {
                if (userData != null) {
                  reportApiCall(context);
                } else {
                  // showDialog(
                  //     barrierDismissible: false,
                  //     context: context,
                  //     builder: (context) => GuestUserPoupup(
                  //           msg:
                  //               "You don't have access to it without logging in.",
                  //         ));
                  PageNavigateScreen().push(context, const LoginPage());
                }
              })
        ],
      ),
    );
  }

  void reportApiCall(context) async {
    Utils().showSpinner(context);

    dynamic body = {
      'my_user_id': userData['user_id'].toString(),
      'other_user_id': widget.data['profile_data'] == null
          ? widget.data['chef_grocer_id'].toString()
          : widget.data['profile_data']['user_id'].toString(),
      'dish_id': 'NA',
      'message': selectMsg,
      'player_id': playerID,
      'device_type': deviceType,
    };

    try {
      await PostApiServer().reportApi(body).then((value) {
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
