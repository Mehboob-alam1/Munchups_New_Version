import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/utils.dart';

import '../../Apis/post_apis.dart';

class NotificationDeletePopUp extends StatefulWidget {
  String id;
  NotificationDeletePopUp({super.key, required this.id});

  @override
  State<NotificationDeletePopUp> createState() =>
      _NotificationDeletePopUpState();
}

class _NotificationDeletePopUpState extends State<NotificationDeletePopUp> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          TextStrings.textKey['delete_notification']!,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        TextStrings.textKey['delete_notification_sub']!,
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
                          deleteNotificationApiCall(context);
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

  void deleteNotificationApiCall(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await PostApiServer().deleteNotificationApi(widget.id).then((value) {
        setState(() {
          isLoading = false;
        });
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          PageNavigateScreen().back(context);
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
