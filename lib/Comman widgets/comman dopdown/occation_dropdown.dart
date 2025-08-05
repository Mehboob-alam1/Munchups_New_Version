import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';

class OccationDropDown extends StatefulWidget {
  final title;
  final type;
  final selectedData;
  final ValueChanged<String?> onChanged;

  OccationDropDown({
    Key? key,
    required this.title,
    required this.type,
    required this.onChanged,
    this.selectedData,
  }) : super(key: key);

  @override
  State<OccationDropDown> createState() => _OccationDropDownState();
}

class _OccationDropDownState extends State<OccationDropDown> {
  List getdataList = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    occationApi();
  }

  void occationApi() async {
    try {
      await GetApiServer().occasionApi().then((value) {
        if (value['success'] == 'true') {
          setState(() {
            getdataList = value['oc_category'];
          });
        }
      });
    } catch (e) {
      getdataList = [];
    }
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
          items: getdataList.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: '${item['occasion_category_id']}',
              alignment: Alignment.centerLeft,
              child: Text(
                item['category_name'],
                style: black15bold,
              ),
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
