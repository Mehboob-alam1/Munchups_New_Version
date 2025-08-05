import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';

class AddressDropDown extends StatefulWidget {
  final title;
  final selectedData;
  final ValueChanged<String?> onChanged;
  List list;
  AddressDropDown({
    Key? key,
    required this.title,
    required this.onChanged,
    this.selectedData,
    required this.list,
  }) : super(key: key);

  @override
  State<AddressDropDown> createState() => _AddressDropDownState();
}

class _AddressDropDownState extends State<AddressDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: (widget.selectedData != null) ? widget.selectedData : null,
      onChanged: widget.onChanged,
      onTap: () {
        setState(() {
          FocusManager.instance.primaryFocus!.unfocus();
        });
      },
      isDense: true,
      isExpanded: true,
      iconDisabledColor: DynamicColor.lightGrey,
      iconEnabledColor: DynamicColor.primaryColor,
      iconSize: 30,
      menuMaxHeight: 400,
      alignment: Alignment.centerLeft,
      dropdownColor: DynamicColor.white,
      style: black15bold,
      decoration: InputDecoration(
          hintText: widget.title,
          hintStyle: lightBleck15W500,
          errorStyle: const TextStyle(color: Colors.red),
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderBlack,
          errorBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorderFocuse,
          fillColor: DynamicColor.white,
          filled: true,
          contentPadding: const EdgeInsets.only(top: 10, left: 10)),
      items: widget.list.isEmpty
          ? [
              const DropdownMenuItem<String>(
                value: 'No address found',
                alignment: Alignment.centerLeft,
                child: Text('No address found'),
              )
            ]
          : widget.list.map<DropdownMenuItem<String>>((dynamic item) {
              return DropdownMenuItem<String>(
                value: '$item',
                alignment: Alignment.centerLeft,
                child: Text(item),
              );
            }).toList(),
    );
  }
}
