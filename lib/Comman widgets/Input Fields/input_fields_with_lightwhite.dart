import 'package:flutter/material.dart';

import '../../Component/color_class/color_class.dart';
import '../../Component/global_data/global_data.dart';
import '../../Component/styles/styles.dart';

class InputFieldsWithLightWhiteColor extends StatefulWidget {
  final labelText;
  final prefixIcon;
  final textInputAction;
  final keyboardType;
  final style;
  final suffixIcon;
  final maxLines;
  final obsecureText;
  final initialValue;
  final titleStyle;
  final borderStyle;
  final labelStyle;
  final readOnly;
  final validator;
  final inputFormatters;
  final optionalORnote;
  final maxLength;
  final focusNode;
  final textCapitalization;
  final fillColor;
  final ValueChanged<String> onChanged;
  VoidCallback? onEditingComplete;
  TextEditingController? controller;
  VoidCallback? onTap;

  InputFieldsWithLightWhiteColor({
    Key? key,
    this.titleStyle,
    this.labelStyle,
    this.borderStyle,
    this.maxLines,
    this.labelText,
    this.prefixIcon,
    this.textInputAction,
    this.keyboardType,
    this.obsecureText,
    this.style,
    this.suffixIcon,
    this.initialValue,
    this.readOnly,
    required this.onChanged,
    this.validator,
    this.inputFormatters,
    this.optionalORnote,
    this.controller,
    this.onTap,
    this.maxLength,
    this.onEditingComplete,
    this.focusNode,
    this.textCapitalization,
    this.fillColor,
  }) : super(key: key);

  @override
  _InputFieldsWithLightWhiteColorState createState() =>
      _InputFieldsWithLightWhiteColorState();
}

class _InputFieldsWithLightWhiteColorState
    extends State<InputFieldsWithLightWhiteColor> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 50,
      child: TextFormField(
        onTap: widget.onTap,
        controller: widget.controller,
        focusNode: widget.focusNode,
        textCapitalization: (widget.textCapitalization == null)
            ? TextCapitalization.none
            : widget.textCapitalization,
        cursorColor: DynamicColor.primaryColor,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        style: (widget.style != null) ? widget.style : lightBleck15W500,
        onChanged: widget.onChanged,
        onEditingComplete: (widget.onEditingComplete == null)
            ? null
            : widget.onEditingComplete,
        validator: widget.validator,
        readOnly: (widget.readOnly == null) ? false : widget.readOnly,
        obscureText:
            (widget.obsecureText != null) ? widget.obsecureText : false,
        maxLines: (widget.maxLines != null) ? widget.maxLines : null,
        maxLength: (widget.maxLength != null) ? widget.maxLength : null,
        initialValue:
            (widget.initialValue != null) ? widget.initialValue : null,
        decoration: InputDecoration(
            hintText: widget.labelText,
            hintStyle: (widget.labelStyle != null)
                ? widget.labelStyle
                : lightBleck15W500,
            prefixIcon: (widget.prefixIcon != null) 
                ? (widget.prefixIcon is IconData 
                    ? Icon(widget.prefixIcon) 
                    : widget.prefixIcon)
                : null,
            suffixIcon: (widget.suffixIcon != null) 
                ? (widget.suffixIcon is IconData 
                    ? Icon(widget.suffixIcon) 
                    : widget.suffixIcon)
                : null,
            suffixIconColor: DynamicColor.lightGrey,
            errorStyle: const TextStyle(color: Colors.red),
            fillColor: (widget.fillColor == null)
                ? DynamicColor.white
                : widget.fillColor,
            filled: true,
            border: (widget.borderStyle != null)
                ? widget.borderStyle
                : outlineInputBorder,
            enabledBorder: (widget.borderStyle != null)
                ? widget.borderStyle
                : outlineInputBorder,
            focusedBorder: (widget.borderStyle != null)
                ? widget.borderStyle
                : outlineInputBorderBlack,
            errorBorder: (widget.borderStyle != null)
                ? widget.borderStyle
                : outlineInputBorder,
            focusedErrorBorder: (widget.borderStyle != null)
                ? widget.borderStyle
                : outlineInputBorderFocuse,
            contentPadding:
                const EdgeInsets.only(top: 10, right: 10, left: 10)),
      ),
    );
  }
}
