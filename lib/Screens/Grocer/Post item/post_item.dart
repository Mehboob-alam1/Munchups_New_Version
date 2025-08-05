// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/post_apis.dart';
// import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Comman%20widgets/comman%20image%20picker/comman_imagepicker.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GrocerPostItemFormPage extends StatefulWidget {
//   const GrocerPostItemFormPage({super.key});
//
//   @override
//   State<GrocerPostItemFormPage> createState() => _GrocerPostItemFormPageState();
// }
//
// class _GrocerPostItemFormPageState extends State<GrocerPostItemFormPage> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//
//   TextEditingController formDate = TextEditingController();
//   TextEditingController toDate = TextEditingController();
//
//   String itemName = '';
//   String itemPrice = '';
//   String description = '';
//   String pickAndDrop = '';
//
//   dynamic userData;
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
//               BackIconCustomAppBar(title: TextStrings.textKey['post_item']!)),
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
//                   itemNameFiled(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   itemPriceFiled(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   discriptionFiled(),
//                   SizedBox(height: SizeConfig.getSize10(context: context)),
//                   pickAndDropButton(),
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
//   Widget itemNameFiled() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Name Of Item',
//         textInputAction: TextInputAction.next,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             itemName = value;
//           });
//         });
//   }
//
//   Widget itemPriceFiled() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Item Price',
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
//             itemPrice = value;
//           });
//         });
//   }
//
//   Widget discriptionFiled() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Item Description',
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
//   Widget pickAndDropButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             children: <Widget>[
//               Radio(
//                 value: 'Drop',
//                 activeColor: DynamicColor.primaryColor,
//                 groupValue: pickAndDrop,
//                 onChanged: (String? value) {
//                   setState(() {
//                     pickAndDrop = value!;
//                   });
//                 },
//               ),
//               Text(
//                 'Drop',
//                 style: white15bold,
//               ),
//               Radio(
//                 value: 'Pickup',
//                 activeColor: DynamicColor.primaryColor,
//                 groupValue: pickAndDrop,
//                 onChanged: (String? value) {
//                   setState(() {
//                     pickAndDrop = value!;
//                   });
//                 },
//               ),
//               Text(
//                 'Pickup',
//                 style: white15bold,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
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
//               if (pickAndDrop.isNotEmpty) {
//                 postDishApiCall(context);
//               } else {
//                 Utils().myToast(context, msg: 'Please select Pick or Drop');
//               }
//             } else {
//               Utils().myToast(context, msg: 'Please select all images');
//             }
//           }
//         });
//   }
//
//   void postDishApiCall(context) async {
//     Utils().showSpinner(context);
//
//     dynamic body = {
//       'user_id': userData['user_id'].toString(),
//       'type': 'grocer',
//       'name': itemName.trim(),
//       'price': itemPrice.trim(),
//       'description': description.trim(),
//       'service_type': pickAndDrop,
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
//             PageNavigateScreen()
//                 .pushRemovUntil(context, const GrocerHomePage());
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman%20image%20picker/comman_imagepicker.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';

// Mocked image files (you can replace with real image pick logic)
File imageFile = File('');
File imageFile2 = File('');
File imageFile3 = File('');

class GrocerPostItemFormPage extends StatefulWidget {
  const GrocerPostItemFormPage({super.key});

  @override
  State<GrocerPostItemFormPage> createState() => _GrocerPostItemFormPageState();
}

class _GrocerPostItemFormPageState extends State<GrocerPostItemFormPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String itemName = '';
  String itemPrice = '';
  String description = '';
  String pickAndDrop = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['post_item']!),
      ),
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
                itemNameFiled(),
                SizedBox(height: SizeConfig.getSize10(context: context)),
                itemPriceFiled(),
                SizedBox(height: SizeConfig.getSize10(context: context)),
                discriptionFiled(),
                SizedBox(height: SizeConfig.getSize10(context: context)),
                pickAndDropButton(),
                SizedBox(height: SizeConfig.getSize50(context: context)),
                buttons(),
                SizedBox(
                  height: SizeConfig.getSizeHeightBy(context: context, by: 0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemNameFiled() {
    return InputFieldsWithLightWhiteColor(
      labelText: 'Name Of Item',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      style: black15bold,
      validator: (val) {
        if (val.isEmpty) {
          return TextStrings.textKey['field_req']!;
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          itemName = value;
        });
      },
    );
  }

  Widget itemPriceFiled() {
    return InputFieldsWithLightWhiteColor(
      labelText: 'Item Price',
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
        return null;
      },
      onChanged: (value) {
        setState(() {
          itemPrice = value;
        });
      },
    );
  }

  Widget discriptionFiled() {
    return InputFieldsWithLightWhiteColor(
      labelText: 'Item Description',
      maxLines: 5,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      style: black15bold,
      onChanged: (value) {
        setState(() {
          description = value;
        });
      },
    );
  }

  Widget pickAndDropButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<String>(
            value: 'Drop',
            activeColor: DynamicColor.primaryColor,
            groupValue: pickAndDrop,
            onChanged: (value) {
              setState(() {
                pickAndDrop = value!;
              });
            },
          ),
          Text('Drop', style: white15bold),
          Radio<String>(
            value: 'Pickup',
            activeColor: DynamicColor.primaryColor,
            groupValue: pickAndDrop,
            onChanged: (value) {
              setState(() {
                pickAndDrop = value!;
              });
            },
          ),
          Text('Pickup', style: white15bold),
        ],
      ),
    );
  }

  Widget buttons() {
    return CommanButton(
      heroTag: 1,
      shap: 10.0,
      width: MediaQuery.of(context).size.width * 0.5,
      buttonName: TextStrings.textKey['submit']!.toUpperCase(),
      onPressed: () {
        if (globalKey.currentState!.validate()) {
          if (imageFile.path.isNotEmpty &&
              imageFile2.path.isNotEmpty &&
              imageFile3.path.isNotEmpty) {
            if (pickAndDrop.isNotEmpty) {
              simulateSubmit();
            } else {
              Utils().myToast(context, msg: 'Please select Pick or Drop');
            }
          } else {
            Utils().myToast(context, msg: 'Please select all images');
          }
        }
      },
    );
  }

  void simulateSubmit() {
    Utils().myToast(context, msg: 'Submitted Successfully (Mock)');

    setState(() {
      imageFile = File('');
      imageFile2 = File('');
      imageFile3 = File('');
      itemName = '';
      itemPrice = '';
      description = '';
      pickAndDrop = '';
    });

    Timer(const Duration(milliseconds: 600), () {
      PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
    });
  }
}
