import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../color_class/color_class.dart';

class Utils {
  static baseUrl() {
    return 'https://munchups.com/webservice/';
    //'https://munchups.com/webservice/';
  }

  // static imageBaseUrl() {
  //   return 'https://drivers.cdlapps.com//admin/uploads/';
  // }

  late FToast fToast;

  myToast(BuildContext context, {required String msg}) {
    fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      gravity: ToastGravity.TOP,
      fadeDuration: const Duration(milliseconds: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: const Color.fromARGB(255, 127, 133, 152),
        ),
        child: Text(
          msg,
          style: const TextStyle(
              color: DynamicColor.white,
              fontSize: 15,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // checkToken(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  //   PageNavigateScreen().pushRemovUntil(context, const LoginPage());
  // }
  void showSpinner(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(children: [
        const SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            color: DynamicColor.primaryColor,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text("Processing...")),
      ]),
    );
    showDialog(
      barrierDismissible: Platform.isAndroid ? false : true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void stopSpinner(BuildContext context) {
    if (context != null) {
      if (ModalRoute.of(context)?.isCurrent != true) {
        Navigator.of(context).pop();
      }
    }
  }

  static launchUrls(String setUrl, BuildContext context) async {
    final url = setUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // static onShare(String url) {
  //   Share.share(url);
  // }
}
