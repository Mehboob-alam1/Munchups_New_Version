import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/food_category_model.dart';

class ProfessionDropDown extends StatefulWidget {
  final title;
  final type;
  final selectedData;
  final ValueChanged<String?> onChanged;

  ProfessionDropDown({
    Key? key,
    required this.title,
    required this.type,
    required this.onChanged,
    this.selectedData,
  }) : super(key: key);

  @override
  State<ProfessionDropDown> createState() => _ProfessionDropDownState();
}

class _ProfessionDropDownState extends State<ProfessionDropDown> {
  List<ChefProfession> getdataList = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getProfessionCategoryApi();
  }

  void getProfessionCategoryApi() async {
    try {
      await GetApiServer().getChefCategoryAndProfationApi().then((value) {
        if (value.success == 'true') {
          setState(() {
            getdataList = value.profession;
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
              value: '${item.professionId}',
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CustomNetworkImage(
                        url: item.professionImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      item.professionName,
                      style: black15bold,
                    ),
                  ),
                ],
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
