import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/address_list_popup.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/occation_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Comman widgets/Input Fields/input_fields_with_lightwhite.dart';

class EdtiDemandFoodForm extends StatefulWidget {
  dynamic foodID;
  EdtiDemandFoodForm({super.key, required this.foodID});

  @override
  State<EdtiDemandFoodForm> createState() => _EdtiDemandFoodFormState();
}

class _EdtiDemandFoodFormState extends State<EdtiDemandFoodForm> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController formDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController foodTime = TextEditingController();

  dynamic userData;
  dynamic selectedOccation;

  List selectedFood = [];
  List addressList = [];

  String noOfPeople = '';
  String pickAndDrop = '';
  String budget = '';
  String postFromDate = '';
  String postToDate = '';
  String time = '';
  String postalCode = '';
  String note = '';
  String food24Time = '';

  bool isLoading = false;

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getUsertype();
    getFoodDetailApiCall();
  }

  @override
  void dispose() {
    super.dispose();
    addressController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(
              title: TextStrings.textKey['on_demand_food']!)),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: DynamicColor.primaryColor))
          : SingleChildScrollView(
              child: Form(
                  key: globalKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.getSize25(context: context),
                        right: SizeConfig.getSize25(context: context)),
                    child: Column(
                      children: [
                        SizedBox(
                            height: SizeConfig.getSize40(context: context)),
                        OccationDropDown(
                            title: TextStrings.textKey['select_occasion']!,
                            type: 'Occasion',
                            selectedData: selectedOccation,
                            onChanged: (value) {
                              setState(() {
                                selectedOccation = value;
                              });
                            }),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        noOfPeopleFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        FoodCategoryDropDown(
                            title: TextStrings.textKey['food_cate']!,
                            type: 'Food Categories',
                            selectedData: selectedFood,
                            onChanged: (value) {
                              setState(() {
                                selectedFood = value;
                              });
                            }),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        pickDropButton(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        budgetFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        Row(
                          children: [
                            Expanded(child: formDateFiled()),
                            SizedBox(
                                width: SizeConfig.getSize10(context: context)),
                            Expanded(child: toDateFiled()),
                          ],
                        ),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        timeFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        postalCodeFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        locationFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        noteFiled(),
                        SizedBox(
                            height: SizeConfig.getSize50(context: context)),
                        buttons(),
                        SizedBox(
                            height: SizeConfig.getSizeHeightBy(
                                context: context, by: 0.1)),
                      ],
                    ),
                  )),
            ),
    );
  }

  Widget noOfPeopleFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: noOfPeople,
        labelText: TextStrings.textKey['no_of_people'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            noOfPeople = value;
          });
        });
  }

  Widget pickDropButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              Radio(
                value: 'Drop',
                activeColor: DynamicColor.primaryColor,
                groupValue: pickAndDrop,
                onChanged: (String? value) {
                  setState(() {
                    pickAndDrop = value!;
                  });
                },
              ),
              Text(
                TextStrings.textKey['drop']!,
                style: white15bold,
              ),
              Radio(
                value: 'Pickup',
                activeColor: DynamicColor.primaryColor,
                groupValue: pickAndDrop,
                onChanged: (String? value) {
                  setState(() {
                    pickAndDrop = value!;
                  });
                },
              ),
              Text(
                TextStrings.textKey['pickup']!,
                style: white15bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget budgetFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: budget,
        labelText: TextStrings.textKey['budget'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        prefixIcon: SizedBox(
          width: SizeConfig.getSize40(context: context),
          child: Center(
            child: Text(
              currencySymbol,
              style: lightGrey17bold,
            ),
          ),
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            budget = value;
          });
        });
  }

  Widget formDateFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          selectDate(context, 'From');
        },
        controller: formDate,
        readOnly: true,
        labelText: TextStrings.textKey['from_date'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {});
        });
  }

  Widget toDateFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          selectDate(context, 'To');
        },
        controller: toDate,
        readOnly: true,
        labelText: TextStrings.textKey['to_date'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {});
        });
  }

  Widget timeFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          selectTime(context);
        },
        controller: foodTime,
        readOnly: true,
        labelText: TextStrings.textKey['time'],
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            time = value;
          });
        });
  }

  Widget locationFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          if (postalCode.isNotEmpty) {
            if (addressList.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) => AddressPopupPopUp(list: addressList));
            } else {
              Utils().myToast(context, msg: 'Address not found!');
            }
          } else {
            Utils().myToast(context, msg: 'Please enter postal code');
          }
        },
        readOnly: true,
        controller: addressController,
        labelText: TextStrings.textKey['location'],
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.streetAddress,
        style: black15bold,
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          size: 35,
          color: DynamicColor.primaryColor,
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {});
  }

  Widget postalCodeFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: postalCode,
        labelText: TextStrings.textKey['zip'],
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            postalCode = value;
            addressController.text = '';
            getOnlineAddress(value);
          });
        });
  }

  Widget noteFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: note,
        labelText: TextStrings.textKey['note'],
        maxLines: 5,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        onChanged: (value) {
          setState(() {
            note = value;
          });
        });
  }

  Widget buttons() {
    return CommanButton(
        heroTag: 1,
        shap: 10.0,
        width: MediaQuery.of(context).size.width * 0.5,
        buttonName: TextStrings.textKey['submit']!.toUpperCase(),
        onPressed: () {
          if (globalKey.currentState!.validate()) {
            if (selectedOccation != null &&
                selectedFood.isNotEmpty &&
                pickAndDrop.isNotEmpty) {
              onDemandFoodApiCall(context);
            } else {
              Utils().myToast(context, msg: 'All fields are required');
            }
          }
        });
  }

  Future selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        if (type == 'From') {
          formDate.text = DateFormat('dd MMM yyyy').format(picked);
          postFromDate = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          toDate.text = DateFormat('dd MMM yyyy').format(picked);
          postToDate = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        foodTime.text = picked.format(context);

        food24Time =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void getFoodDetailApiCall() async {
    setState(() {
      isLoading = true;
    });
    try {
      await GetApiServer()
          .onDemandFoodDetailApi(widget.foodID.toString())
          .then((value) {
        setState(() {
          isLoading = false;
          if (value['success'] == 'true') {
            selectedOccation =
                value['food_arr'][0]['occasion_category_id'].toString();
            for (var element in value['oc_category_id']) {
              selectedFood.add(element['category_id']);
            }
            //selectedFood = value['oc_category_id'][0]['category_id'].toString();
            noOfPeople = value['food_arr'][0]['no_of_people'].toString();
            pickAndDrop = value['food_arr'][0]['service_type'] == 'pickup'
                ? 'Pickup'
                : 'Drop';
            budget = value['food_arr'][0]['budget'].toString();
            formDate.text = value['food_arr'][0]['start_date'].toString();
            postFromDate = value['food_arr'][0]['start_date'].toString();
            toDate.text = value['food_arr'][0]['end_date'].toString();
            postToDate = value['food_arr'][0]['end_date'].toString();
            foodTime.text = value['food_arr'][0]['occasion_time'].toString();
            food24Time = value['food_arr'][0]['occasion_time'].toString();
            addressController.text =
                value['food_arr'][0]['location'].toString();
            postalCode = value['food_arr'][0]['postal_code'].toString();
            note = value['food_arr'][0]['description'].toString();
          }
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getOnlineAddress(getPostalCode) async {
    addressList.clear();
    try {
      await GetApiServer().getOnlineAddressApi(getPostalCode).then((value) {
        if (value['suggestions'].isNotEmpty) {
          setState(() {
            for (var element in value['suggestions']) {
              addressList.add(element['address']);
            }
          });
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void onDemandFoodApiCall(context) async {
    Utils().showSpinner(context);

    dynamic body = {
      'food_id': widget.foodID.toString(),
      'user_id': userData['user_id'].toString(),
      'occasion_category_id': selectedOccation.toString(),
      'no_of_people': noOfPeople.trim(),
      'food_category': selectedFood.toString().trim(),
      'service_type': pickAndDrop,
      'budget': budget.contains('.00') ? budget.trim() : '${budget.trim()}.00',
      'start_date': postFromDate.trim(),
      'end_date': postToDate.trim(),
      'occasion_time': food24Time.toString(),
      'location': addressController.text.trim(),
      'postal_code': postalCode.trim(),
      'note': note.trim(),
    };

    try {
      await PostApiServer().onDemandFoodApi(body).then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          addressController.text = '';

          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          });
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }
}
