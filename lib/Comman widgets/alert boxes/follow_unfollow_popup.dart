import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';

import '../../Component/Strings/strings.dart';
import '../../Component/color_class/color_class.dart';
import '../../Component/navigatepage/navigate_page.dart';
import '../comman_button/comman_botton.dart';

class FollowUnfollowPopUp extends StatefulWidget {
  String toUserID;
  String currentStatus;
  FollowUnfollowPopUp({
    Key? key,
    required this.toUserID,
    required this.currentStatus,
  }) : super(
          key: key,
        );

  @override
  _FollowUnfollowPopUpState createState() => _FollowUnfollowPopUpState();
}

class _FollowUnfollowPopUpState extends State<FollowUnfollowPopUp> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  followUnfollowApiCall() async {
    setState(() {
      isLoading = true;
    });

    try {
      PostApiServer()
          .followUnfollowApi(
              widget.toUserID, widget.currentStatus.toLowerCase())
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value['success'] == 'true') {
          PageNavigateScreen().back(context);
        }
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          widget.currentStatus,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        'Are you sure you want to ${widget.currentStatus}?',
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
                          followUnfollowApiCall();
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
