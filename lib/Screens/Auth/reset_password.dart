// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/post_apis.dart';
// import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
// import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/images_urls.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Auth/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ResetPasswordPage extends StatefulWidget {
//   String email;
//   String otp;
//   ResetPasswordPage({
//     super.key,
//     required this.email,
//     required this.otp,
//   });
//
//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }
//
// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//   bool newPasswordVisible = false;
//   bool confirmPasswordVisible = false;
//
//   TextEditingController passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: DynamicColor.white,
//       body: SingleChildScrollView(
//         child: BackGroundWidget(
//           backgroundImage: AllImages.loginBG,
//           fit: BoxFit.fill,
//           child: Form(
//             key: globalKey,
//             child: Padding(
//               padding: EdgeInsets.only(
//                   left: SizeConfig.getSize15(context: context),
//                   right: SizeConfig.getSize15(context: context)),
//               child: Column(
//                 children: [
//                   SizedBox(height: SizeConfig.getSize55(context: context)),
//                   Center(
//                     child: Image.asset(
//                       appLogoUrl,
//                       fit: BoxFit.fitHeight,
//                       height: 200,
//                     ),
//                   ),
//                   SizedBox(height: SizeConfig.getSize40(context: context)),
//                   passwordFiled(),
//                   SizedBox(height: SizeConfig.getSize25(context: context)),
//                   confirPasswordFiled(),
//                   SizedBox(height: SizeConfig.getSize55(context: context)),
//                   buttons(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget passwordFiled() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.getSize10(context: context),
//           right: SizeConfig.getSize10(context: context)),
//       child: InputFieldsWithLightWhiteColor(
//           controller: passwordController,
//           labelText: TextStrings.textKey['new_pass'],
//           textInputAction: TextInputAction.done,
//           keyboardType: TextInputType.emailAddress,
//           style: black15bold,
//           obsecureText: !newPasswordVisible,
//           maxLines: 1,
//           suffixIcon: IconButton(
//             icon: Icon(
//               newPasswordVisible ? Icons.visibility : Icons.visibility_off,
//             ),
//             onPressed: () {
//               setState(() {
//                 newPasswordVisible = !newPasswordVisible;
//               });
//             },
//           ),
//           validator: (val) {
//             if (val.isEmpty) {
//               return TextStrings.textKey['field_req']!;
//             }
//           },
//           onChanged: (value) {
//             setState(() {});
//           }),
//     );
//   }
//
//   Widget confirPasswordFiled() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.getSize10(context: context),
//           right: SizeConfig.getSize10(context: context)),
//       child: InputFieldsWithLightWhiteColor(
//           labelText: TextStrings.textKey['confirm_pass'],
//           textInputAction: TextInputAction.done,
//           keyboardType: TextInputType.emailAddress,
//           style: black15bold,
//           obsecureText: !confirmPasswordVisible,
//           maxLines: 1,
//           suffixIcon: IconButton(
//             icon: Icon(
//               confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
//             ),
//             onPressed: () {
//               setState(() {
//                 confirmPasswordVisible = !confirmPasswordVisible;
//               });
//             },
//           ),
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return TextStrings.textKey['field_req']!;
//             }
//             if (val != passwordController.text) {
//               return 'Passwords do not match';
//             }
//             return null;
//           },
//           onChanged: (value) {
//             setState(() {});
//           }),
//     );
//   }
//
//   Widget buttons() {
//     return CommanButton(
//         heroTag: 1,
//         shap: 10.0,
//         width: MediaQuery.of(context).size.width * 0.5,
//         buttonName: 'Reset'.toUpperCase(),
//         onPressed: () {
//           if (globalKey.currentState!.validate()) {
//             resetPasswordApiCall(context);
//           }
//         });
//   }
//
//   void resetPasswordApiCall(context) async {
//     Utils().showSpinner(context);
//     dynamic body = {
//       'email': widget.email.toString(),
//       'otp': widget.otp,
//       'password': passwordController.text.trim(),
//     };
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       await PostApiServer().resetPasswordApi(body).then((value) {
//         FocusScope.of(context).requestFocus(FocusNode());
//         Utils().stopSpinner(context);
//
//         if (value['success'] == 'true') {
//           setState(() {
//             prefs.clear();
//           });
//           myDialogPopup(context);
//         } else {
//           Utils().myToast(context, msg: value['msg']);
//         }
//       });
//     } catch (e) {
//       Utils().stopSpinner(context);
//       log(e.toString());
//     }
//   }
//
//   void myDialogPopup(context) {
//     showDialog(
//         context: context,
//         barrierDismissible: Platform.isAndroid ? false : true,
//         builder: (context) {
//           return AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             title: Image.asset(
//               'assets/images/success.png',
//               height: 100,
//             ),
//             content: SizedBox(
//               height: SizeConfig.getSizeHeightBy(context: context, by: 0.17),
//               child: Column(
//                 children: [
//                   const Text(
//                     'New password generated successfully.',
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: DynamicColor.green),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 25),
//                   CommanButton(
//                       hight: 40.0,
//                       width:
//                           SizeConfig.getSizeWidthBy(context: context, by: 0.3),
//                       buttonName: 'OK',
//                       buttonBGColor: DynamicColor.primaryColor,
//                       onPressed: () {
//                         PageNavigateScreen()
//                             .pushRemovUntil(context, const LoginPage());
//                       },
//                       shap: 7)
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/images_urls.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Auth/login.dart';

import '../../Component/global_data/global_data.dart';

class ResetPasswordPage extends StatefulWidget {
  String email;
  String otp;
  ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackGroundWidget(
          backgroundImage: AllImages.loginBG,
          fit: BoxFit.fill,
          child: Form(
            key: globalKey,
            child: Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.getSize15(context: context),
                right: SizeConfig.getSize15(context: context),
              ),
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

  Widget passwordFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getSize10(context: context),
      ),
      child: InputFieldsWithLightWhiteColor(
        controller: passwordController,
        labelText: TextStrings.textKey['new_pass'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
        obsecureText: !newPasswordVisible,
        maxLines: 1,
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
          setState(() {});
        },
      ),
    );
  }

  Widget confirPasswordFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getSize10(context: context),
      ),
      child: InputFieldsWithLightWhiteColor(
        labelText: TextStrings.textKey['confirm_pass'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
        obsecureText: !confirmPasswordVisible,
        maxLines: 1,
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
          if (val == null || val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
          if (val != passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget buttons() {
    return CommanButton(
      heroTag: 1,
      shap: 10.0,
      width: MediaQuery.of(context).size.width * 0.5,
      buttonName: 'Reset'.toUpperCase(),
      onPressed: () {
        if (globalKey.currentState!.validate()) {
          myDialogPopup(context);
        }
      },
    );
  }

  void myDialogPopup(context) {
    showDialog(
      context: context,
      barrierDismissible: Platform.isAndroid ? false : true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Image.asset(
            'assets/images/success.png',
            height: 100,
          ),
          content: SizedBox(
            height: SizeConfig.getSizeHeightBy(context: context, by: 0.17),
            child: Column(
              children: [
                const Text(
                  'New password generated successfully.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: DynamicColor.green),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                CommanButton(
                  hight: 40.0,
                  width: SizeConfig.getSizeWidthBy(context: context, by: 0.3),
                  buttonName: 'OK',
                  buttonBGColor: DynamicColor.primaryColor,
                  onPressed: () {
                    PageNavigateScreen()
                        .pushRemovUntil(context, const LoginPage());
                  },
                  shap: 7,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
