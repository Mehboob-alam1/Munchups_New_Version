import 'package:flutter/material.dart';

import '../../Component/color_class/color_class.dart';

class CommanButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  final textStyle;
  final buttonBGColor;
  final textColor;
  final hight;
  final width;
  double shap;
  final heroTag;
  final textSize;
  //passing props in react style
  CommanButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    this.textStyle,
    this.buttonBGColor,
    this.textColor,
    this.hight,
    this.width,
    this.heroTag,
    this.textSize,
    required this.shap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (hight == null) ? 50.0 : hight,
      width: (width == null) ? MediaQuery.of(context).size.width - 25 : width,
      child: FloatingActionButton.extended(
          key: key,
          elevation: 2.0,
          heroTag: (heroTag == null) ? 0 : heroTag,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((shap == null) ? 5.0 : shap),
          ),
          backgroundColor: (buttonBGColor != null)
              ? buttonBGColor
              : DynamicColor.primaryColor,
          label: Text(buttonName,
              style: TextStyle(
                  color: (textColor == null) ? DynamicColor.white : textColor,
                  fontSize: (textSize == null) ? 18 : textSize,
                  fontWeight: FontWeight.bold)),
          onPressed: onPressed),
    );
  }
}
