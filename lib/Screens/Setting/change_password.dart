// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
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
// import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
// import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
// import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});
//
//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }
//
// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//
//   dynamic userData;
//
//   String getUserType = 'buyer';
//   String oldPassword = '';
//   String newPassword = '';
//   String conFNewPassword = '';
//
//   bool oldPasswordVisible = false;
//   bool newPasswordVisible = false;
//   bool confirmPasswordVisible = false;
//
//   getUsertype() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       if (prefs.getString("user_type") != null) {
//         getUserType = prefs.getString("user_type").toString();
//       }
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
//                   SizedBox(height: SizeConfig.getSize50(context: context)),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: IconButton(
//                         onPressed: () {
//                           PageNavigateScreen().back(context);
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           color: DynamicColor.white,
//                         )),
//                   ),
//                   // SizedBox(height: SizeConfig.getSize55(context: context)),
//                   Center(
//                     child: Image.asset(
//                       appLogoUrl,
//                       fit: BoxFit.fitHeight,
//                       height: 200,
//                     ),
//                   ),
//                   SizedBox(height: SizeConfig.getSize40(context: context)),
//                   oldPasswordFiled(),
//                   SizedBox(height: SizeConfig.getSize25(context: context)),
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
//   Widget oldPasswordFiled() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.getSize10(context: context),
//           right: SizeConfig.getSize10(context: context)),
//       child: InputFieldsWithLightWhiteColor(
//           labelText: TextStrings.textKey['old_pass'],
//           textInputAction: TextInputAction.done,
//           keyboardType: TextInputType.emailAddress,
//           obsecureText: !oldPasswordVisible,
//           maxLines: 1,
//           style: black15bold,
//           suffixIcon: IconButton(
//             icon: Icon(
//               oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
//             ),
//             onPressed: () {
//               setState(() {
//                 oldPasswordVisible = !oldPasswordVisible;
//               });
//             },
//           ),
//           validator: (val) {
//             if (val.isEmpty) {
//               return TextStrings.textKey['field_req']!;
//             }
//           },
//           onChanged: (value) {
//             setState(() {
//               oldPassword = value;
//             });
//           }),
//     );
//   }
//
//   Widget passwordFiled() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.getSize10(context: context),
//           right: SizeConfig.getSize10(context: context)),
//       child: InputFieldsWithLightWhiteColor(
//           labelText: TextStrings.textKey['new_pass'],
//           textInputAction: TextInputAction.done,
//           keyboardType: TextInputType.emailAddress,
//           obsecureText: !newPasswordVisible,
//           maxLines: 1,
//           style: black15bold,
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
//             setState(() {
//               newPassword = value;
//             });
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
//           obsecureText: !confirmPasswordVisible,
//           maxLines: 1,
//           style: black15bold,
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
//             if (val.isEmpty) {
//               return TextStrings.textKey['field_req']!;
//             } else {
//               if (conFNewPassword != newPassword) {
//                 return 'Password not match!';
//               }
//               return null;
//             }
//           },
//           onChanged: (value) {
//             setState(() {
//               conFNewPassword = value;
//             });
//           }),
//     );
//   }
//
//   Widget buttons() {
//     return CommanButton(
//         heroTag: 1,
//         shap: 10.0,
//         width: MediaQuery.of(context).size.width * 0.5,
//         buttonName: TextStrings.textKey['save']!.toUpperCase(),
//         onPressed: () {
//           if (globalKey.currentState!.validate()) {
//             changePasswordApiCall(context);
//           }
//           //  PageNavigateScreen().pushRemovUntil(context, const LoginPage());
//         });
//   }
//
//   void changePasswordApiCall(context) async {
//     Utils().showSpinner(context);
//
//     dynamic body = {
//       'user_id': userData['user_id'].toString(),
//       'old_password': oldPassword.trim(),
//       'new_password': newPassword.trim(),
//       'player_id': playerID,
//       'device_type': deviceType,
//     };
//
//     try {
//       await PostApiServer().changePasswordApi(body).then((value) {
//         FocusScope.of(context).requestFocus(FocusNode());
//         Utils().stopSpinner(context);
//
//         if (value['success'] == 'true') {
//           Utils().myToast(context, msg: value['msg']);
//           if (getUserType == 'buyer') {
//             Timer(const Duration(milliseconds: 600), () {
//               PageNavigateScreen()
//                   .pushRemovUntil(context, const BuyerHomePage());
//             });
//           } else if (getUserType == 'chef') {
//             Timer(const Duration(milliseconds: 600), () {
//               PageNavigateScreen()
//                   .pushRemovUntil(context, const ChefHomePage());
//             });
//           } else {
//             Timer(const Duration(milliseconds: 600), () {
//               PageNavigateScreen()
//                   .pushRemovUntil(context, const GrocerHomePage());
//             });
//           }
//         } else {
//           Utils().myToast(context, msg: value['msg']);
//         }
//       });
//     } catch (e) {
//       Utils().stopSpinner(context);
//       log(e.toString());
//     }
//   }
// }



import 'dart:convert';
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
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Component/global_data/global_data.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String getUserType = 'buyer';
  String oldPassword = '';
  String newPassword = '';
  String conFNewPassword = '';
  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      getUserType = prefs.getString("user_type") ?? 'buyer';
    });
  }

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
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getSize15(context: context)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.getSize50(context: context)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => PageNavigateScreen().back(context),
                      icon: const Icon(Icons.arrow_back_ios, color: DynamicColor.white),
                    ),
                  ),
                  Center(
                    child: Image.asset(appLogoUrl, height: 200),
                  ),
                  SizedBox(height: SizeConfig.getSize40(context: context)),
                  _oldPasswordField(),
                  SizedBox(height: SizeConfig.getSize25(context: context)),
                  _newPasswordField(),
                  SizedBox(height: SizeConfig.getSize25(context: context)),
                  _confirmPasswordField(),
                  SizedBox(height: SizeConfig.getSize55(context: context)),
                  _saveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _oldPasswordField() {
    return _passwordField(
      label: TextStrings.textKey['old_pass']!,
      isVisible: oldPasswordVisible,
      onVisibilityToggle: () {
        setState(() => oldPasswordVisible = !oldPasswordVisible);
      },
      onChanged: (val) => oldPassword = val,
    );
  }

  Widget _newPasswordField() {
    return _passwordField(
      label: TextStrings.textKey['new_pass']!,
      isVisible: newPasswordVisible,
      onVisibilityToggle: () {
        setState(() => newPasswordVisible = !newPasswordVisible);
      },
      onChanged: (val) => newPassword = val,
    );
  }

  Widget _confirmPasswordField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getSize10(context: context),
      ),
      child: InputFieldsWithLightWhiteColor(
        labelText: TextStrings.textKey['confirm_pass'],
        obsecureText: !confirmPasswordVisible,
        maxLines: 1,
        style: black15bold,
        keyboardType: TextInputType.visiblePassword,
        suffixIcon: IconButton(
          icon: Icon(confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() => confirmPasswordVisible = !confirmPasswordVisible);
          },
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
          if (val != newPassword) {
            return 'Passwords do not match!';
          }
          return null;
        },
        onChanged: (val) => conFNewPassword = val,
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getSize10(context: context)),
      child: InputFieldsWithLightWhiteColor(
        labelText: label,
        obsecureText: !isVisible,
        maxLines: 1,
        style: black15bold,
        keyboardType: TextInputType.visiblePassword,
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onVisibilityToggle,
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
          if (val.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget _saveButton() {
    return CommanButton(
      heroTag: 1,
      shap: 10.0,
      width: MediaQuery.of(context).size.width * 0.5,
      buttonName: TextStrings.textKey['save']!.toUpperCase(),
      onPressed: () {
        if (globalKey.currentState!.validate()) {
          Utils().myToast(context, msg: "Password changed successfully!");
          _navigateHome();
        }
      },
    );
  }

  void _navigateHome() {
    Widget home;
    switch (getUserType) {
      case 'chef':
        home = const ChefHomePage();
        break;
      case 'grocer':
        home = const GrocerHomePage();
        break;
      default:
        home = const BuyerHomePage();
    }

    PageNavigateScreen().pushRemovUntil(context, home);
  }
}
