import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/images_urls.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/settings_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  dynamic userData;

  String getUserType = 'buyer';
  String oldPassword = '';
  String newPassword = '';
  String conFNewPassword = '';

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("user_type") != null) {
        getUserType = prefs.getString("user_type").toString();
      }
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getUsertype();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: DynamicColor.white,
      body: SingleChildScrollView(
        child: BackGroundWidget(
          backgroundImage: AllImages.loginBG,
          fit: BoxFit.fill,
          child: Form(
            key: globalKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.getSize15(context: context),
                  right: SizeConfig.getSize15(context: context)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.getSize50(context: context)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          PageNavigateScreen().back(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: DynamicColor.white,
                        )),
                  ),
                  // SizedBox(height: SizeConfig.getSize55(context: context)),
                  Center(
                    child: Image.asset(
                      appLogoUrl,
                      fit: BoxFit.fitHeight,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getSize40(context: context)),
                  oldPasswordFiled(),
                  SizedBox(height: SizeConfig.getSize25(context: context)),
                  passwordFiled(),
                  SizedBox(height: SizeConfig.getSize25(context: context)),
                  confirPasswordFiled(),
                  SizedBox(height: SizeConfig.getSize55(context: context)),
                  buttons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget oldPasswordFiled() {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.getSize10(context: context),
          right: SizeConfig.getSize10(context: context)),
      child: InputFieldsWithLightWhiteColor(
          labelText: TextStrings.textKey['old_pass'],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          obsecureText: !oldPasswordVisible,
          maxLines: 1,
          style: black15bold,
          suffixIcon: IconButton(
            icon: Icon(
              oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                oldPasswordVisible = !oldPasswordVisible;
              });
            },
          ),
          validator: (val) {
            if (val.isEmpty) {
              return TextStrings.textKey['field_req']!;
            }
          },
          onChanged: (value) {
            setState(() {
              oldPassword = value;
            });
          }),
    );
  }

  Widget passwordFiled() {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.getSize10(context: context),
          right: SizeConfig.getSize10(context: context)),
      child: InputFieldsWithLightWhiteColor(
          labelText: TextStrings.textKey['new_pass'],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          obsecureText: !newPasswordVisible,
          maxLines: 1,
          style: black15bold,
          suffixIcon: IconButton(
            icon: Icon(
              newPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                newPasswordVisible = !newPasswordVisible;
              });
            },
          ),
          validator: (val) {
            if (val.isEmpty) {
              return TextStrings.textKey['field_req']!;
            }
          },
          onChanged: (value) {
            setState(() {
              newPassword = value;
            });
          }),
    );
  }

  Widget confirPasswordFiled() {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.getSize10(context: context),
          right: SizeConfig.getSize10(context: context)),
      child: InputFieldsWithLightWhiteColor(
          labelText: TextStrings.textKey['confirm_pass'],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          obsecureText: !confirmPasswordVisible,
          maxLines: 1,
          style: black15bold,
          suffixIcon: IconButton(
            icon: Icon(
              confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                confirmPasswordVisible = !confirmPasswordVisible;
              });
            },
          ),
          validator: (val) {
            if (val.isEmpty) {
              return TextStrings.textKey['field_req']!;
            } else {
              if (conFNewPassword != newPassword) {
                return 'Password not match!';
              }
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              conFNewPassword = value;
            });
          }),
    );
  }

  Widget buttons() {
    return CommanButton(
        heroTag: 1,
        shap: 10.0,
        width: MediaQuery.of(context).size.width * 0.5,
        buttonName: TextStrings.textKey['save']!.toUpperCase(),
        onPressed: () {
          if (globalKey.currentState!.validate()) {
            changePasswordApiCall(context);
          }
          //  PageNavigateScreen().pushRemovUntil(context, const LoginPage());
        });
  }

  void changePasswordApiCall(context) async {
    Utils().showSpinner(context);

    final body = {
      'user_id': userData['user_id'].toString(),
      'old_password': oldPassword.trim(),
      'new_password': newPassword.trim(),
      'confirm_password': conFNewPassword.trim(),
      'player_id': playerID,
      'device_type': deviceType,
    };

    final settingsProvider = context.read<SettingsProvider>();

    try {
      final success = await settingsProvider.changePassword(body);
      Utils().stopSpinner(context);

      if (success) {
        final message = settingsProvider.submitMessage.isNotEmpty
            ? settingsProvider.submitMessage
            : 'Password updated successfully';
        Utils().myToast(context, msg: message);

        Timer(const Duration(milliseconds: 600), () {
          if (getUserType == 'buyer') {
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          } else if (getUserType == 'chef') {
            PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
          } else {
            PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
          }
        });
      } else {
        final error = settingsProvider.submitError.isNotEmpty
            ? settingsProvider.submitError
            : 'Unable to update password';
        Utils().myToast(context, msg: error);
      }
    } catch (e) {
      Utils().stopSpinner(context);
      Utils().myToast(context, msg: e.toString());
      log(e.toString());
    } finally {
      settingsProvider.clearSubmitState();
    }
  }
}
