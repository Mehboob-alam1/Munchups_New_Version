import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/post_apis.dart';
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
import 'package:munchups_app/Screens/Auth/forgot_pass.dart';
import 'package:munchups_app/Screens/Auth/register.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:munchups_app/Screens/Setting/privacy&policy.dart';
import 'package:munchups_app/Screens/Setting/terms&con.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool isRemember = false;
  bool passwordVisible = false;

  String emailID = '';
  String password = '';

  saveUserType(value, userTyepe, myFollowers, currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('data', value);
      prefs.setString("user_type", userTyepe);
      prefs.setInt('following_count', myFollowers);
      prefs.setString('country_symbol', currency);
    });
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
                  SizedBox(height: SizeConfig.getSize55(context: context)),
                  Center(
                    child: Image.asset(
                      appLogoUrl,
                      fit: BoxFit.fitHeight,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getSize40(context: context)),
                  emialFiled(),
                  SizedBox(height: SizeConfig.getSize25(context: context)),
                  passwordFiled(),
                  SizedBox(height: SizeConfig.getSize20(context: context)),
                  rememberAndForgetPass(),
                  SizedBox(height: SizeConfig.getSize55(context: context)),
                  buttons(),
                  SizedBox(height: SizeConfig.getSize55(context: context)),
                  dontAcunt(),
                  SizedBox(height: SizeConfig.getSize10(context: context)),
                  termsAndCondi()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emialFiled() {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.getSize10(context: context),
          right: SizeConfig.getSize10(context: context)),
      child: InputFieldsWithLightWhiteColor(
          labelText: TextStrings.textKey['email_add'],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          style: black15bold,
          validator: (val) {
            if (val.isEmpty) {
              return TextStrings.textKey['field_req']!;
            }
          },
          onChanged: (value) {
            setState(() {
              emailID = value;
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
          labelText: TextStrings.textKey['password'],
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          style: black15bold,
          obsecureText: !passwordVisible,
          maxLines: 1,
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
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
              password = value;
            });
          }),
    );
  }

  Widget rememberAndForgetPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                checkColor: DynamicColor.white,
                focusColor: DynamicColor.white,
                hoverColor: DynamicColor.white,
                fillColor: MaterialStateProperty.all(DynamicColor.primaryColor),
                activeColor: DynamicColor.primaryColor,
                value: isRemember,
                onChanged: (value) {
                  setState(() {
                    isRemember = value!;
                  });
                }),
            Text(
              TextStrings.textKey['remember']!,
              style: white14w5,
            ),
          ],
        ),
        TextButton(
            onPressed: () {
              PageNavigateScreen().push(context, const ForgetPasswordPage());
            },
            child: Text(TextStrings.textKey['forgetPass']!, style: white14w5)),
      ],
    );
  }

  Widget buttons() {
    return CommanButton(
        heroTag: 1,
        shap: 10.0,
        width: MediaQuery.of(context).size.width * 0.5,
        buttonName: TextStrings.textKey['login']!.toUpperCase(),
        onPressed: () {
          loginApiCall(context);
        });
  }

  Widget dontAcunt() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(TextStrings.textKey['dont_account']!, style: white14w5),
      GestureDetector(
          onTap: () {
            addressController.text = '';
            PageNavigateScreen().push(context, RegisterPage());
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(TextStrings.textKey['signup']!, style: primary15w5),
          ))
    ]);
  }

  Widget termsAndCondi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            PageNavigateScreen().push(context, PrivacyPolicyPage());
            // Utils.launchUrls(context, 'https://standardjcm.com/privacy.html');
          },
          child: Text(
            TextStrings.textKey['policy']!,
            style: primary15boldWithUnderline,
          ),
        ),
        Text(
          ' & ',
          style: white14w5,
        ),
        GestureDetector(
          onTap: () {
            PageNavigateScreen().push(context, TermsAndConditonPage());
            // Utils.launchUrls(
            //     context, 'https://standardjcm.com/terms-condition.html');
          },
          child: Text(
            TextStrings.textKey['terms&con']!,
            style: primary15boldWithUnderline,
          ),
        ),
      ],
    );
  }

  void loginApiCall(context) async {
    Utils().showSpinner(context);

    dynamic body = {
      'email': emailID.trim(),
      'password': password.trim(),
      'player_id': playerID,
      'device_type': deviceType,
    };

    try {
      await PostApiServer().loginApi(body).then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);

        if (value['success'] == 'true') {
          saveUserType(
              jsonEncode(value),
              value['user_type'],
              value['my_followers'],
              (value['currency'] == null) ? '£' : value['currency']);
          setState(() {
            currencySymbol =
                (value['currency'] == null) ? '£' : value['currency'];
          });
          Utils().myToast(context, msg: value['msg']);
          if (value['user_type'] == 'buyer') {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const BuyerHomePage());
            });
          } else if (value['user_type'] == 'chef') {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const ChefHomePage());
            });
          } else {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const GrocerHomePage());
            });
          }
        } else {
          Utils().myToast(context, msg: value['msg']);
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }
}
