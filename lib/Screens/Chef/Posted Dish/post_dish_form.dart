// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:munchups_app/Apis/post_apis.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Comman%20widgets/comman%20dopdown/custom_drodown.dart';
// import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
// import 'package:munchups_app/Comman%20widgets/comman%20image%20picker/comman_imagepicker.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../Comman widgets/Input Fields/input_fields_with_lightwhite.dart';
//
// class ChefPostDishForm extends StatefulWidget {
//   const ChefPostDishForm({super.key});
//
//   @override
//   State<ChefPostDishForm> createState() => _ChefPostDishFormState();
// }
//
// class _ChefPostDishFormState extends State<ChefPostDishForm> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//
//   TextEditingController dishServingDate = TextEditingController();
//   TextEditingController dishServingTimeFrom = TextEditingController();
//   TextEditingController dishServingTimeTo = TextEditingController();
//
//   String dishName = '';
//   String collecAndDelivery = 'Collection';
//   String servingDate = '';
//   String price = '';
//   String description = '';
//   String dishDate = '';
//   String start24Time = '';
//   String end24Time = '';
//
//   dynamic userData;
//   dynamic selectMeal;
//   dynamic selectedPerPersion;
//   dynamic selectedDiliveryRange;
//   dynamic selectedFood;
//
//   List mealList = [
//     'Breakfast',
//     'Lunch',
//     'Dinner',
//   ];
//
//   List portionPerPersionList = [
//     '1',
//     '2',
//     '3',
//     '4',
//     '5',
//     '6',
//     '7',
//     '8',
//     '9',
//     '10'
//   ];
//   List deliveryRangList = [
//     '<1',
//     '1',
//     '2',
//     '3',
//     '4',
//     '5',
//     '6',
//     '7',
//     '8',
//     '9',
//     '10',
//     '11',
//     '12',
//     '13',
//     '14',
//     '15',
//     '16',
//     '17',
//     '18',
//     '19',
//     '20',
//     '21',
//     '22',
//     '23',
//     '24',
//     '25',
//     '26',
//     '27',
//     '28',
//     '29',
//     '30',
//     '31',
//     '32',
//     '33',
//     '34',
//     '35',
//     '36',
//     '37',
//     '38',
//     '39',
//     '40',
//     '41',
//     '42',
//     '43',
//     '44',
//     '45',
//     '46',
//     '47',
//     '48',
//     '49',
//     '50'
//   ];
//
//   getUsertype() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userData = jsonDecode(prefs.getString('data').toString());
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getUsertype();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child:
//               BackIconCustomAppBar(title: TextStrings.textKey['post_dish']!)),
//       body: SingleChildScrollView(
//         child: Form(
//             key: globalKey,
//             child: Padding(
//               padding: EdgeInsets.only(
//                   left: SizeConfig.getSize25(context: context),
//                   right: SizeConfig.getSize25(context: context)),
//               child: Column(
//                 children: [
//                   SizedBox(height: SizeConfig.getSize30(context: context)),
//                   CommanImagePicker(
//                     networkImage1: '',
//                     networkImage2: '',
//                     networkImage3: '',
//                   ),
//                   SizedBox(height: SizeConfig.getSize20(context: context)),
//                   dishNameFiled(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   CommanDropDown(
//                       title: 'Meal For',
//                       type: 'Meal for',
//                       list: mealList,
//                       selectedData: selectMeal,
//                       onChanged: (value) {
//                         setState(() {
//                           selectMeal = value;
//                         });
//                       }),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   colloectionAndDileveryButton(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   dishServingDateFiled(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   Row(
//                     children: [
//                       Expanded(child: dishSerTimeFromFiled()),
//                       SizedBox(width: SizeConfig.getSize10(context: context)),
//                       Expanded(child: dishSerTimeToFiled()),
//                     ],
//                   ),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   SingleFoodCategoryDropDown(
//                       title: TextStrings.textKey['food_cate']!,
//                       type: 'Single Food Categories',
//                       selectedData: selectedFood,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedFood = value;
//                         });
//                       }),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   CommanDropDown(
//                       title: 'Portion per person',
//                       type: 'Portion per person',
//                       list: portionPerPersionList,
//                       selectedData: selectedPerPersion,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedPerPersion = value;
//                         });
//                       }),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   dishPriceFiled(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   CommanDropDown(
//                       title: 'Delivery Range',
//                       type: 'Delivery Range',
//                       list: deliveryRangList,
//                       selectedData: selectedDiliveryRange,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedDiliveryRange = value;
//                         });
//                       }),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   discriptionFiled(),
//                   SizedBox(height: SizeConfig.getSize50(context: context)),
//                   buttons(),
//                   SizedBox(
//                       height: SizeConfig.getSizeHeightBy(
//                           context: context, by: 0.1)),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
//
//   Widget dishNameFiled() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Dish Name',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             dishName = value;
//           });
//         });
//   }
//
//   Widget colloectionAndDileveryButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             children: <Widget>[
//               Radio(
//                 value: 'Collection',
//                 activeColor: DynamicColor.primaryColor,
//                 groupValue: collecAndDelivery,
//                 onChanged: (String? value) {
//                   setState(() {
//                     collecAndDelivery = value!;
//                   });
//                 },
//               ),
//               Text(
//                 'Collection',
//                 style: white15bold,
//               ),
//               Radio(
//                 value: 'Delivery',
//                 activeColor: DynamicColor.primaryColor,
//                 groupValue: collecAndDelivery,
//                 onChanged: (String? value) {
//                   setState(() {
//                     collecAndDelivery = value!;
//                   });
//                 },
//               ),
//               Text(
//                 'Delivery',
//                 style: white15bold,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget dishServingDateFiled() {
//     return InputFieldsWithLightWhiteColor(
//         onTap: () {
//           selectDate(context);
//         },
//         controller: dishServingDate,
//         readOnly: true,
//         labelText: 'Dish Serving Date',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {});
//         });
//   }
//
//   Widget dishSerTimeFromFiled() {
//     return InputFieldsWithLightWhiteColor(
//         onTap: () {
//           selectTime(context, 'From');
//         },
//         controller: dishServingTimeFrom,
//         readOnly: true,
//         labelText: 'Serving Time From',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {});
//         });
//   }
//
//   Widget dishSerTimeToFiled() {
//     return InputFieldsWithLightWhiteColor(
//         onTap: () {
//           selectTime(context, 'To');
//         },
//         controller: dishServingTimeTo,
//         readOnly: true,
//         labelText: 'Serving Time To',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {});
//         });
//   }
//
//   Widget dishPriceFiled() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Dish Price',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.number,
//         style: black15bold,
//         prefixIcon: SizedBox(
//           width: SizeConfig.getSize40(context: context),
//           child: Center(
//             child: Text(
//               currencySymbol,
//               style: lightGrey17bold,
//             ),
//           ),
//         ),
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             price = value;
//           });
//         });
//   }
//
//   Widget discriptionFiled() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Dish Description',
//         maxLines: 5,
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         onChanged: (value) {
//           setState(() {
//             description = value;
//           });
//         });
//   }
//
//   Widget buttons() {
//     return CommanButton(
//         heroTag: 1,
//         shap: 10.0,
//         width: MediaQuery.of(context).size.width * 0.5,
//         buttonName: TextStrings.textKey['submit']!.toUpperCase(),
//         onPressed: () {
//           if (globalKey.currentState!.validate()) {
//             if (imageFile.path.isNotEmpty &&
//                 imageFile2.path.isNotEmpty &&
//                 imageFile3.path.isNotEmpty) {
//               if (collecAndDelivery.isNotEmpty) {
//                 postDishApiCall(context);
//               } else {
//                 Utils().myToast(context, msg: 'Please select Service Type');
//               }
//             } else {
//               Utils().myToast(context, msg: 'Please select all images');
//             }
//           }
//         });
//   }
//
//   Future selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2010),
//       lastDate: DateTime(2040),
//     );
//
//     if (picked != null) {
//       setState(() {
//         dishServingDate.text = DateFormat('dd MMM yyyy').format(picked);
//         dishDate = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }
//
//   Future<void> selectTime(BuildContext context, type) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (BuildContext context, Widget? child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (type == 'From') {
//           dishServingTimeFrom.text = picked.format(context);
//
//           start24Time =
//               '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
//         } else {
//           dishServingTimeTo.text = picked.format(context);
//           end24Time =
//               '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
//         }
//       });
//     }
//   }
//
//   void postDishApiCall(context) async {
//     Utils().showSpinner(context);
//
//     dynamic body = {
//       'user_id': userData['user_id'].toString(),
//       'type': 'chef',
//       'name': dishName.trim(),
//       'meal': selectMeal.toString().toLowerCase(),
//       'service_type': collecAndDelivery.toString(),
//       'dish_date': dishDate.trim(),
//       'start_time': start24Time.trim(),
//       'end_time': end24Time.trim(),
//       'category_id': selectedFood.toString(),
//       'portion': selectedPerPersion.toString(),
//       'price': price.trim(),
//       'criteria': selectedDiliveryRange.toString(),
//       'description': description.trim(),
//     };
//
//     try {
//       await PostApiServer()
//           .postDishApi(body, imageFile, imageFile2, imageFile3)
//           .then((value) {
//         FocusScope.of(context).requestFocus(FocusNode());
//         Utils().stopSpinner(context);
//
//         if (value['success'] == 'true') {
//           imageFile = File('');
//           imageFile2 = File('');
//           imageFile3 = File('');
//           Utils().myToast(context, msg: value['msg']);
//
//           Timer(const Duration(milliseconds: 600), () {
//             PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//           });
//         }
//       });
//     } catch (e) {
//       Utils().stopSpinner(context);
//       log(e.toString());
//     }
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/custom_drodown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20image%20picker/comman_imagepicker.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

import '../../../Comman widgets/Input Fields/input_fields_with_lightwhite.dart';

class ChefPostDishForm extends StatefulWidget {
  const ChefPostDishForm({super.key});

  @override
  State<ChefPostDishForm> createState() => _ChefPostDishFormState();
}

class _ChefPostDishFormState extends State<ChefPostDishForm> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController dishServingDate = TextEditingController();
  TextEditingController dishServingTimeFrom = TextEditingController();
  TextEditingController dishServingTimeTo = TextEditingController();

  String dishName = '';
  String collecAndDelivery = 'Collection';
  String servingDate = '';
  String price = '';
  String description = '';
  String dishDate = '';
  String start24Time = '';
  String end24Time = '';

  dynamic selectMeal;
  dynamic selectedPerPersion;
  dynamic selectedDiliveryRange;
  dynamic selectedFood;

  List mealList = ['Breakfast', 'Lunch', 'Dinner'];

  List portionPerPersionList = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'
  ];
  List deliveryRangList = [
    '<1',
    ...List.generate(50, (i) => (i + 1).toString()),
  ];

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
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getSize25(context: context),
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.getSize30(context: context)),
                  CommanImagePicker(
                    networkImage1: '',
                    networkImage2: '',
                    networkImage3: '',
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
              Text('Collection', style: white15bold),
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
              Text('Delivery', style: white15bold),
            ],
          ),
        ],
      ),
    );
  }

  Widget dishServingDateFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () => selectDate(context),
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
        onChanged: (value) {});
  }

  Widget dishSerTimeFromFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () => selectTime(context, 'From'),
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
        onChanged: (value) {});
  }

  Widget dishSerTimeToFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () => selectTime(context, 'To'),
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
        onChanged: (value) {});
  }

  Widget dishPriceFiled() {
    return InputFieldsWithLightWhiteColor(
        labelText: 'Dish Price',
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        style: black15bold,
        prefixIcon: SizedBox(
          width: SizeConfig.getSize40(context: context),
          child: Center(child: Text('€', style: lightGrey17bold)),
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
          if (globalKey.currentState!.validate()) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Submitted!'),
                content: const Text('Your form was submitted successfully.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          }
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
        dishDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> selectTime(BuildContext context, type) async {
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
        if (type == 'From') {
          dishServingTimeFrom.text = picked.format(context);
          start24Time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        } else {
          dishServingTimeTo.text = picked.format(context);
          end24Time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        }
      });
    }
  }
}
