import 'package:flutter/material.dart';

//0xffFB692D
class DynamicColor {
  static const Color themeColor = Color(0xff272A3D);
  static const Color primaryColor = Color.fromARGB(255, 254, 151, 110);
  static const Color secondryColor = Color(0xff171D2D);
  static const Color black = Color(0xFF000000);
  static const Color lightBlack = Color.fromRGBO(17, 17, 17, 0.6);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color trncperentWhite = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color trncperent = Color.fromARGB(8, 255, 255, 255);
  static const Color lightGrey = Color(0xff878787);
  static const Color borderline = Color(0xffD6D6D6);
  static const Color grey300 = Color(0xffF4F9F2);
  static const Color green = Color(0xff5CD41A);
  static const Color boxColor = Color.fromARGB(255, 75, 84, 108);
  static const Color redColor = Color.fromARGB(255, 237, 100, 91);
  // gradientColor
  static const gradientColorNoBegin = LinearGradient(
    colors: [DynamicColor.primaryColor, DynamicColor.secondryColor],
  );
}
