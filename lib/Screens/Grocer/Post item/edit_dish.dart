import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class EditGrocerPostItemFormPage extends StatefulWidget {
  dynamic dishData;
  EditGrocerPostItemFormPage({super.key, required this.dishData});

  @override
  State<EditGrocerPostItemFormPage> createState() =>
      _EditGrocerPostItemFormPageState();
}

class _EditGrocerPostItemFormPageState
    extends State<EditGrocerPostItemFormPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController formDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  String itemName = '';
  String itemPrice = '';
  String description = '';
  String pickAndDrop = '';
  String networkImage1 = '';
  String networkImage2 = '';
  String networkImage3 = '';

  dynamic userData;
  dynamic dishData;

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
    itemName = dishData['dish_name'];
    itemPrice = dishData['dish_price'];
    description = dishData['dish_description'];
    if (dishData['service_type'] != null) {
      pickAndDrop = dishData['service_type'] == 'pickup' ? 'Pickup' : 'Drop';
    }
    if (dishData['dish_images'] != 'NA') {
      if (dishData['dish_images'].length >= 1) {
        networkImage1 = dishData['dish_images'][0]['kitchen_image'];
      }
      if (dishData['dish_images'].length >= 2) {
        networkImage2 = dishData['dish_images'][1]['kitchen_image'];
      }
      if (dishData['dish_images'].length >= 3) {
        networkImage3 = dishData['dish_images'][2]['kitchen_image'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Update Posted Item')),
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
                      height: SizeConfig.getSizeHeightBy(
                          context: context, by: 0.1)),
                ],
              ),
            )),
      ),
    );
  }

  Widget itemNameFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: itemName,
        labelText: 'Name Of Item',
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
            itemName = value;
          });
        });
  }

  Widget itemPriceFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: itemPrice,
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
        },
        onChanged: (value) {
          setState(() {
            itemPrice = value;
          });
        });
  }

  Widget discriptionFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: description,
        labelText: 'Item Description',
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

  Widget pickAndDropButton() {
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
                'Drop',
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
                'Pickup',
                style: white15bold,
              ),
            ],
          ),
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
          updateDishApiCall(context);
        });
  }

  void updateDishApiCall(context) async {
    Utils().showSpinner(context);

    dynamic body = {
      'dish_id': dishData['dish_id'].toString(),
      'user_id': userData['user_id'].toString(),
      'type': 'grocer',
      'name': itemName.trim(),
      'price': itemPrice.trim(),
      'description': description.trim(),
      'service_type': pickAndDrop,
    };

    try {
      await PostApiServer()
          .updateDishApi(body, imageFile, imageFile2, imageFile3)
          .then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          imageFile = File('');
          imageFile2 = File('');
          imageFile3 = File('');

          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen()
                .pushRemovUntil(context, const GrocerHomePage());
          });
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }
}
