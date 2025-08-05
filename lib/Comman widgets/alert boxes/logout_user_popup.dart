import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Component/Strings/strings.dart';
import '../../Component/color_class/color_class.dart';
import '../../Component/navigatepage/navigate_page.dart';
import '../comman_button/comman_botton.dart';

class LogOutUserPopUp extends StatefulWidget {
  const LogOutUserPopUp({
    Key? key,
  }) : super(key: key);

  @override
  _LogOutUserPopUpState createState() => _LogOutUserPopUpState();
}

class _LogOutUserPopUpState extends State<LogOutUserPopUp> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.remove('cart');
      prefs.remove('data');
      prefs.remove('user_type');
      prefs.remove('cart_detail');
      prefs.remove('following_count');
      prefs.remove('show_terms');

      isLoading = true;
    });
    Timer(const Duration(seconds: 1), () {
      navigatePage();
      setState(() {
        isLoading = false;
      });
    });
  }

  navigatePage() {
    PageNavigateScreen().pushRemovUntil(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          TextStrings.textKey['logout_app']!,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        TextStrings.textKey['logout_sub']!,
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
                          logoutUser();
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
}
