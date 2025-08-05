import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';

class CommanDropDown extends StatefulWidget {
  final title;
  final type;
  final selectedData;
  final ValueChanged<String?> onChanged;
  List list;
  CommanDropDown({
    Key? key,
    required this.title,
    required this.type,
    required this.onChanged,
    this.selectedData,
    required this.list,
  }) : super(key: key);

  @override
  State<CommanDropDown> createState() => _CommanDropDownState();
}

class _CommanDropDownState extends State<CommanDropDown> {
  List getdataList = [];

  bool isLoading = false;
  bool isTap = false;
  @override
  void initState() {
    getdataList = widget.list;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropdownButtonFormField<String>(
          value: (widget.selectedData != null) ? widget.selectedData : null,
          onChanged: widget.onChanged,
          onSaved: (val) {},
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
          hint: Text(widget.title, style: lightBleck15W500),
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
          items: getdataList.map<DropdownMenuItem<String>>((dynamic item) {
            return DropdownMenuItem<String>(
              value: '$item',
              alignment: Alignment.centerLeft,
              child: widget.type == 'Delivery Range'
                  ? Text(item + ' Miles')
                  : Text(item),
            );
          }).toList(),
        ),
        isLoading == true
            ? Container(
                margin: const EdgeInsets.only(top: 50),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: DynamicColor.primaryColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
