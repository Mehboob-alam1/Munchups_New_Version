import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Component/Strings/strings.dart';
import '../../Component/color_class/color_class.dart';
import '../../Component/navigatepage/navigate_page.dart';
import '../comman_button/comman_botton.dart';

class DeleteAccountPopUp extends StatefulWidget {
  const DeleteAccountPopUp({
    Key? key,
  }) : super(key: key);

  @override
  _DeleteAccountPopUpState createState() => _DeleteAccountPopUpState();
}

class _DeleteAccountPopUpState extends State<DeleteAccountPopUp> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          TextStrings.textKey['delete_account']!,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        TextStrings.textKey['delete_account_sub']!,
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
                          deleteAccountApiCall(context);
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

  void deleteAccountApiCall(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    try {
      await PostApiServer().deleteAccountApi().then((value) {
        setState(() {
          isLoading = false;
        });
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          setState(() {
            prefs.clear();
          });
          PageNavigateScreen().pushRemovUntil(context, const LoginPage());
        }
      });
    } catch (e) {
      Utils().myToast(context, msg: 'Internal server error occurred');

      log(e.toString());
      setState(() {
        isLoading = false;
      });
      PageNavigateScreen().back(context);
    }
  }
}
