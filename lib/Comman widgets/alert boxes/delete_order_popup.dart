import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/utils.dart';

class DeleteOrderPopUp extends StatefulWidget {
  String id;
  String orderType;

  DeleteOrderPopUp({
    super.key,
    required this.id,
    required this.orderType,
  });

  @override
  State<DeleteOrderPopUp> createState() => _DeleteOrderPopUpState();
}

class _DeleteOrderPopUpState extends State<DeleteOrderPopUp> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          TextStrings.textKey['delete_order']!,
          style: const TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        TextStrings.textKey['delete_order_sub']!,
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
                          if (widget.orderType == 'Bulk') {
                            deleteBulkOrderApiCall(context);
                          } else {
                            deleteOrderApiCall(context);
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

  void deleteOrderApiCall(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await PostApiServer().deleteOrderApi(widget.id).then((value) {
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

  void deleteBulkOrderApiCall(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await PostApiServer().deleteBulkOrderApi(widget.id).then((value) {
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
