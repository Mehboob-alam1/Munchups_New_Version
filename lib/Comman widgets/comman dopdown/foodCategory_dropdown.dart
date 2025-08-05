import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/food_category_model.dart';

class SingleFoodCategoryDropDown extends StatefulWidget {
  final title;
  final type;
  final selectedData;
  final ValueChanged<String?> onChanged;

  SingleFoodCategoryDropDown({
    Key? key,
    required this.title,
    required this.type,
    required this.onChanged,
    this.selectedData,
  }) : super(key: key);

  @override
  State<SingleFoodCategoryDropDown> createState() =>
      _SingleFoodCategoryDropDownState();
}

class _SingleFoodCategoryDropDownState
    extends State<SingleFoodCategoryDropDown> {
  List<FoodCategory> getdataList = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getFoodCategoryApi();
  }

  void getFoodCategoryApi() async {
    try {
      await GetApiServer().getChefCategoryAndProfationApi().then((value) {
        if (value.success == 'true') {
          setState(() {
            getdataList = value.category;
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
              value: '${item.categoryId}',
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                        height: 20, child: CustomNetworkImage(url: item.image)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      item.categoryName,
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

class FoodCategoryDropDown extends StatefulWidget {
  final title;
  final type;
  final List selectedData;
  final ValueChanged<List> onChanged;

  FoodCategoryDropDown({
    required this.title,
    required this.type,
    required this.onChanged,
    required this.selectedData,
  });

  @override
  _FoodCategoryDropDownState createState() => _FoodCategoryDropDownState();
}

class _FoodCategoryDropDownState extends State<FoodCategoryDropDown> {
  List _tempSelectedItems = [];

  List<FoodCategory> getdataList = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getFoodCategoryApi();
    _tempSelectedItems = widget.selectedData;
  }

  void getFoodCategoryApi() async {
    try {
      await GetApiServer().getChefCategoryAndProfationApi().then((value) {
        if (value.success == 'true') {
          setState(() {
            getdataList = value.category;
          });
        }
      });
    } catch (e) {
      getdataList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          barrierDismissible: Platform.isAndroid ? false : true,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'Select Category',
                  style: white15bold,
                ),
                content: SizedBox(
                  height: SizeConfig.getSizeHeightBy(context: context, by: 0.3),
                  width: double.maxFinite,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: getdataList.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: DynamicColor.lightBlack,
                      height: 0,
                    ),
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        checkColor: DynamicColor.white,
                        activeColor: DynamicColor.green,
                        value: _tempSelectedItems
                            .contains(getdataList[index].categoryId),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                  height: 25,
                                  child: CustomNetworkImage(
                                      url: getdataList[index].image)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                getdataList[index].categoryName,
                                style: white14w5,
                              ),
                            ),
                          ],
                        ),
                        onChanged: (bool? value) {
                          if (value == true) {
                            if (!_tempSelectedItems
                                .contains(getdataList[index].categoryId)) {
                              setState(() {
                                _tempSelectedItems
                                    .add(getdataList[index].categoryId);
                              });
                            }
                          } else {
                            if (_tempSelectedItems
                                .contains(getdataList[index].categoryId)) {
                              setState(() {
                                _tempSelectedItems
                                    .remove(getdataList[index].categoryId);
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onChanged(_tempSelectedItems);
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        decoration: BoxDecoration(
          color: DynamicColor.white,
          border: Border.all(color: DynamicColor.lightBlack),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                _tempSelectedItems.isEmpty
                    ? 'Select Category'
                    : _tempSelectedItems.length.toString() + ' Selected',
                style:
                    _tempSelectedItems.isEmpty ? lightBleck15W500 : black15bold,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: DynamicColor.primaryColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
