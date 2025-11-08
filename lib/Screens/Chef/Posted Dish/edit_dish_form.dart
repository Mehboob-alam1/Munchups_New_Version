import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/custom_drodown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20image%20picker/comman_imagepicker.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Comman widgets/Input Fields/input_fields_with_lightwhite.dart';

class EditChefPostDishForm extends StatefulWidget {
  dynamic dishData;
  EditChefPostDishForm({super.key, required this.dishData});

  @override
  State<EditChefPostDishForm> createState() => _EditChefPostDishFormState();
}

class _EditChefPostDishFormState extends State<EditChefPostDishForm> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController dishServingDate = TextEditingController();
  TextEditingController dishServingTimeFrom = TextEditingController();
  TextEditingController dishServingTimeTo = TextEditingController();

  String dishName = '';
  String collecAndDelivery = 'Collection';
  String servingDate = '';
  String price = '';
  String description = '';
  String dishSrevingDate = '';
  String start24Time = '';
  String end24Time = '';
  String networkImage1 = '';
  String networkImage2 = '';
  String networkImage3 = '';

  dynamic userData;
  dynamic selectMeal;
  dynamic selectedPerPersion;
  dynamic selectedDiliveryRange;
  dynamic dishData;
  dynamic selectedFood;

  List mealList = [
    'Breakfast',
    'Lunch',
    'Dinner',
  ];

  List portionPerPersionList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  List deliveryRangList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50'
  ];

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    dishData = widget.dishData;
    initData();
    getUsertype();
  }

  void initData() async {
    dishName = dishData['dish_name'];
    selectMeal = dishData['meal'] == 'breakfast'
        ? 'Breakfast'
        : dishData['meal'] == 'lunch'
            ? 'Lunch'
            : 'Dinner';
    collecAndDelivery =
        dishData['service_type'] == 'delivery' ? 'Delivery' : 'Collection';
    dishSrevingDate = dishData['dish_date'];
    dishServingDate.text = dishData['dish_date'];
    dishServingTimeFrom.text = dishData['start_time'];
    dishServingTimeTo.text = dishData['end_time'];
    start24Time = dishData['start_time_24'];
    end24Time = dishData['end_time_24'];
    selectedFood = dishData['dish_category_id'].toString();
    selectedPerPersion = dishData['portion'];
    selectedDiliveryRange = dishData['criteria'];
    price = dishData['dish_price'];
    description = dishData['dish_description'];
    final normalizedImages = _normalizeImages(dishData['dish_images']);
    print('EditDishForm: normalized images=$normalizedImages');
    if (normalizedImages.isNotEmpty) {
      networkImage1 = (normalizedImages.length >= 1
          ? normalizedImages[0]['kitchen_image']
          : null)!;
      networkImage2 = (normalizedImages.length >= 2
          ? normalizedImages[1]['kitchen_image']
          : null)!;
      networkImage3 = (normalizedImages.length >= 3
          ? normalizedImages[2]['kitchen_image']
          : null)!;
    }
  }

  List<Map<String, String>> _normalizeImages(dynamic source) {
    final List<Map<String, String>> images = [];

    void addImage(dynamic entry) {
      if (entry is Map && entry['kitchen_image'] != null) {
        images.add({'kitchen_image': entry['kitchen_image'].toString()});
      } else if (entry is String && entry.trim().isNotEmpty) {
        images.add({'kitchen_image': entry.trim()});
      }
    }

    if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
        return images;
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          for (final entry in decoded) {
            addImage(entry);
          }
        } else if (decoded is Map) {
          for (final entry in decoded.values) {
            addImage(entry);
          }
        }
      } catch (e) {
        log('Unable to decode dish_images string: $e');
      }
    } else if (source is List) {
      for (final entry in source) {
        addImage(entry);
      }
    } else if (source is Map) {
      for (final entry in source.values) {
        addImage(entry);
      }
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['post_dish']!)),
      body: SingleChildScrollView(
        child: Form(
            key: globalKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.getSize25(context: context),
                  right: SizeConfig.getSize25(context: context)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.getSize30(context: context)),
                  CommanImagePicker(
                    networkImage1: networkImage1,
                    networkImage2: networkImage2,
                    networkImage3: networkImage3,
                  ),
                  SizedBox(height: SizeConfig.getSize20(context: context)),
                  dishNameFiled(),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  CommanDropDown(
                      title: 'Meal For',
                      type: 'Meal for',
                      list: mealList,
                      selectedData: selectMeal,
                      onChanged: (value) {
                        setState(() {
                          selectMeal = value;
                        });
                      }),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  colloectionAndDileveryButton(),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  dishServingDateFiled(),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  Row(
                    children: [
                      Expanded(child: dishSerTimeFromFiled()),
                      SizedBox(width: SizeConfig.getSize10(context: context)),
                      Expanded(child: dishSerTimeToFiled()),
                    ],
                  ),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  SingleFoodCategoryDropDown(
                      title: TextStrings.textKey['food_cate']!,
                      type: 'Single Food Categories',
                      selectedData: selectedFood,
                      onChanged: (value) {
                        setState(() {
                          selectedFood = value;
                        });
                      }),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  CommanDropDown(
                      title: 'Portion per person',
                      type: 'Portion per person',
                      list: portionPerPersionList,
                      selectedData: selectedPerPersion,
                      onChanged: (value) {
                        setState(() {
                          selectedPerPersion = value;
                        });
                      }),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  dishPriceFiled(),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  CommanDropDown(
                      title: 'Delivery Range',
                      type: 'Delivery Range',
                      list: deliveryRangList,
                      selectedData: selectedDiliveryRange,
                      onChanged: (value) {
                        setState(() {
                          selectedDiliveryRange = value;
                        });
                      }),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  discriptionFiled(),
                  SizedBox(height: SizeConfig.getSize50(context: context)),
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

  Widget dishNameFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: dishName,
        labelText: 'Dish Name',
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
            dishName = value;
          });
        });
  }

  Widget colloectionAndDileveryButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              Radio(
                value: 'Collection',
                activeColor: DynamicColor.primaryColor,
                groupValue: collecAndDelivery,
                onChanged: (String? value) {
                  setState(() {
                    collecAndDelivery = value!;
                  });
                },
              ),
              Text(
                'Collection',
                style: white15bold,
              ),
              Radio(
                value: 'Delivery',
                activeColor: DynamicColor.primaryColor,
                groupValue: collecAndDelivery,
                onChanged: (String? value) {
                  setState(() {
                    collecAndDelivery = value!;
                  });
                },
              ),
              Text(
                'Delivery',
                style: white15bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dishServingDateFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          selectDate(context);
        },
        controller: dishServingDate,
        readOnly: true,
        labelText: 'Dish Serving Date',
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

  Widget dishSerTimeFromFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          selectTime(context, 'From');
        },
        controller: dishServingTimeFrom,
        readOnly: true,
        labelText: 'Serving Time From',
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

  Widget dishSerTimeToFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          selectTime(context, 'To');
        },
        controller: dishServingTimeTo,
        readOnly: true,
        labelText: 'Serving Time To',
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

  Widget dishPriceFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: price,
        labelText: 'Dish Price',
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
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
            price = value;
          });
        });
  }

  Widget discriptionFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: description,
        labelText: 'Dish Description',
        maxLines: 5,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        onChanged: (value) {
          setState(() {
            description = value;
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
          updateDishApiCall(context);
        });
  }

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        dishServingDate.text = DateFormat('dd MMM yyyy').format(picked);
        dishSrevingDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> selectTime(BuildContext context, type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (type == 'From') {
          dishServingTimeFrom.text = picked.format(context);
          start24Time =
              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        } else {
          dishServingTimeTo.text = picked.format(context);
          // end24Time = '${picked.hour}:${picked.minute}}';
          end24Time =
              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        }
      });
    }
  }

  void updateDishApiCall(context) async {
    Utils().showSpinner(context);

    dynamic body = {
      'dish_id': dishData['dish_id'].toString(),
      'user_id': userData['user_id'].toString(),
      'type': 'chef',
      'name': dishName.trim(),
      'meal': selectMeal.toString().toLowerCase(),
      'service_type': collecAndDelivery,
      'dish_date': dishSrevingDate.trim(),
      'start_time': dishServingTimeFrom.text.trim(),
      'end_time': dishServingTimeTo.text.trim(),
      'category_id': selectedFood.toString(),
      'portion': selectedPerPersion.toString(),
      'price': price.trim(),
      'criteria': selectedDiliveryRange.toString(),
      'description': description.trim(),
    };

    try {
      await PostApiServer()
          .updateDishApi(body, imageFile, imageFile2, imageFile3)
          .then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);

        if (value['success'] == 'true') {
          imageFile = File('');
          imageFile2 = File('');
          imageFile3 = File('');
          Utils().myToast(context, msg: value['msg']);

          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
          });
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }
}
