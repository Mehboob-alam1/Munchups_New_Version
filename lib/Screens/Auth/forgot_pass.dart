// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
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
// import 'package:munchups_app/Screens/Auth/otp.dart';
//
// class ForgetPasswordPage extends StatefulWidget {
//   const ForgetPasswordPage({super.key});
//
//   @override
//   State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
// }
//
// class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//   TextEditingController emilController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//                   emialFiled(),
//                   SizedBox(height: SizeConfig.getSize25(context: context)),
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
//   Widget emialFiled() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.getSize10(context: context),
//           right: SizeConfig.getSize10(context: context)),
//       child: InputFieldsWithLightWhiteColor(
//           controller: emilController,
//           labelText: TextStrings.textKey['email_add'],
//           textInputAction: TextInputAction.next,
//           keyboardType: TextInputType.emailAddress,
//           style: black15bold,
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
//   Widget buttons() {
//     return CommanButton(
//         heroTag: 1,
//         shap: 10.0,
//         width: MediaQuery.of(context).size.width * 0.5,
//         buttonName: TextStrings.textKey['reset_pass']!.toUpperCase(),
//         onPressed: () {
//           forgetPasswordApiCall(context);
//         });
//   }
//
//   void forgetPasswordApiCall(context) async {
//     Utils().showSpinner(context);
//
//     try {
//       await GetApiServer()
//           .forgetPasswordApi(emilController.text.trim())
//           .then((value) {
//         FocusScope.of(context).requestFocus(FocusNode());
//         Utils().stopSpinner(context);
//
//         if (value['success'] == 'true') {
//           myDialogPopup(context, value['msg']);
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
//   void myDialogPopup(context, msg) {
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
//                   Text(
//                     msg.toString(),
//                     style: const TextStyle(
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
//                         PageNavigateScreen().push(
//                             context,
//                             OtpPage(
//                               emailId: emilController.text.trim(),
//                               type: 'forget Pass',
//                             ));
//                       },
//                       shap: 7)
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }

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
import 'package:munchups_app/Screens/Auth/otp.dart';

import '../../Component/global_data/global_data.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController emilController = TextEditingController();

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
                horizontal: SizeConfig.getSize15(context: context),
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
                  emialFiled(),
                  SizedBox(height: SizeConfig.getSize25(context: context)),
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

  Widget emialFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getSize10(context: context),
      ),
      child: InputFieldsWithLightWhiteColor(
        controller: emilController,
        labelText: TextStrings.textKey['email_add'],
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
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

  Widget buttons() {
    return CommanButton(
      heroTag: 1,
      shap: 10.0,
      width: MediaQuery.of(context).size.width * 0.5,
      buttonName: TextStrings.textKey['reset_pass']!.toUpperCase(),
      onPressed: () {
        if (globalKey.currentState?.validate() ?? false) {
          _showMockDialog(context);
        }
      },
    );
  }

  void _showMockDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Image.asset('assets/images/success.png', height: 100),
          content: SizedBox(
            height: SizeConfig.getSizeHeightBy(context: context, by: 0.17),
            child: Column(
              children: [
                const Text(
                  'Mock password reset successful.\n(Static frontend only)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DynamicColor.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                CommanButton(
                  hight: 40.0,
                  width: SizeConfig.getSizeWidthBy(context: context, by: 0.3),
                  buttonName: 'OK',
                  buttonBGColor: DynamicColor.primaryColor,
                  onPressed: () {
                    PageNavigateScreen().push(
                      context,
                      OtpPage(
                        emailId: emilController.text.trim(),
                        type: 'forget Pass',
                      ),
                    );
                  },
                  shap: 7,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
