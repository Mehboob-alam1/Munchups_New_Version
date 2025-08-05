import 'dart:io';

import 'package:flutter/material.dart';

import '../color_class/color_class.dart';

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(
      style: BorderStyle.solid, color: DynamicColor.lightBlack),
  borderRadius: BorderRadius.circular(10),
);
OutlineInputBorder outlineInputBorderBlack = OutlineInputBorder(
  borderSide: const BorderSide(
      style: BorderStyle.solid, color: DynamicColor.lightBlack),
  borderRadius: BorderRadius.circular(10),
);
OutlineInputBorder outlineInputBorderFocuse = OutlineInputBorder(
  borderSide: const BorderSide(
      style: BorderStyle.solid, color: DynamicColor.primaryColor),
  borderRadius: BorderRadius.circular(10),
);

String googleApiKey = 'AIzaSyArVg2eeb6UbZtIgSHLEqUpHD1Itj5nYsw';
String apiKey = 'Fvo6g6H3XEaA7xFlMchbNA43771';
String date_format = 'dd-MM-yy';
String screteKey =
    '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';
//'sk_test_N950jTKYw562aEty72yLlaEZ';

String deviceType = 'android';
String playerID = '123456';
String appVersion = '';
String appLogoUrl = 'assets/images/logo_with_name.png';
String currencySymbol = '£';
TextEditingController homeSearchTextController = TextEditingController();
TextEditingController addressController = TextEditingController();

File imageFile = File('');
File imageFile2 = File('');
File imageFile3 = File('');

String formatAddress(String address) {
  if (address.length <= 80) {
    return address;
  }
  String firstPart = address.substring(3, 80);

  return '$firstPart...';
}

String formatMobileNumber(String mobileNumber) {
  if (mobileNumber.length < 2) {
    return mobileNumber;
  }
  String lastTwoDigits = mobileNumber.substring(mobileNumber.length - 2);
  String maskedDigits = 'X' * (mobileNumber.length - 2);
  return '$maskedDigits$lastTwoDigits';
}
