import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/verify_success_popup.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/images_urls.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/reset_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Component/Strings/strings.dart';
import '../../Component/color_class/color_class.dart';
import '../../Component/providers/auth_flow_provider.dart';
import 'package:provider/provider.dart';
import '../Buyer/Home/buyer_home.dart';
import 'login.dart';

class OtpPage extends StatefulWidget {
  dynamic emailId;
  dynamic type;

  OtpPage({Key? key, this.emailId, required this.type}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
//  LocalStorage storage = LocalStorage('user');
  // final server = GetApiServer();
  // final postServer = PostApiService();
  bool isLoading = false;

  String otpCode = '';

  @override
  void initState() {
    super.initState();
    listenOtp();
    
    // Automatically send OTP when screen opens for login verification
    if (widget.type == 'login') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        resendOTPApiCall(context);
      });
    }
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  saveUserType(value, userTyepe, myFollowers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('data', value);
      prefs.setString("user_type", userTyepe);
      prefs.setInt('following_count', myFollowers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackGroundWidget(
      backgroundImage: AllImages.loginBG,
      fit: BoxFit.fill,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            back(),
            Center(
              child: Image.asset(
                appLogoUrl,
                fit: BoxFit.fitHeight,
                height: 150,
              ),
            ),
            const SizedBox(height: 40),
            loginText(),
            const SizedBox(height: 50),
            otp(),
            const SizedBox(height: 50),
            resendOtp(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            buttons(),
          ],
        ),
      ),
    ));
  }

  Widget back() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 15),
        child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: DynamicColor.white,
            )));
  }

  Widget loginText() {
    return Container(
        child: ListTile(
            title: Container(
              alignment: Alignment.center,
              child: Text(
                TextStrings.textKey['verify_text']!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text('We have sent the verification code',
                      style: white17Bold),
                  Text('to your email address', style: white17Bold),
                ],
              ),
            )));
  }

  Widget otp() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: PinFieldAutoFill(
        codeLength: 6,
        controller: _otpController,
        autoFocus: false,
        decoration: UnderlineDecoration(
          textStyle: const TextStyle(fontSize: 20, color: DynamicColor.black),
          colorBuilder: const FixedColorBuilder(Colors.white),
          bgColorBuilder: const FixedColorBuilder(Colors.white),
        ),
        currentCode: otpCode,
        onCodeSubmitted: (code) {},
        onCodeChanged: (code) {
          if (code != null && code.length == 6) {
            setState(() {
              otpCode = code;
            });
            // Auto-verify when 6 digits are entered (optional)
            // Timer(const Duration(seconds: 1), () {
            //   onPressedToNaxt();
            // });
          }
        },
      ),
    );
  }

  Widget resendOtp() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.getSize30(context: context)),
        child: InkWell(
          onTap: () {
            if (widget.type == 'register') {
              resendOTPApiCall(context);
            } else {
              resendOTPForgetPasswordApiCall(context);
            }
          },
          child: Text(
            'Resend OTP',
            style: white17Bold,
          ),
        ),
      ),
    );
  }

  Widget buttons() {
    return CommanButton(
      heroTag: 1,
      shap: 10.0,
      width: MediaQuery.of(context).size.width * 0.5,
      buttonName: TextStrings.textKey['verify']!,
      onPressed: onPressedToNaxt,
    );
  }

  void onPressedToNaxt() {
    // Get OTP from both the controller and the otpCode variable
    String currentOtp = _otpController.text.isNotEmpty ? _otpController.text : otpCode;
    
    print('Current OTP from controller: ${_otpController.text}');
    print('Current OTP from variable: $otpCode');
    print('Using OTP: $currentOtp');
    
    if (currentOtp.isNotEmpty && currentOtp.length == 6) {
      // Update otpCode to ensure we have the latest value
      otpCode = currentOtp;
      
      if (widget.type == 'register') {
        verifyApiCall(context);
      } else if (widget.type == 'login') {
        verifyLoginApiCall(context);
      } else {
        verifyForgetPasswordApiCall(context);
      }
    } else {
      Utils().myToast(context, msg: 'Please enter a valid 6-digit OTP');
    }
  }

//For Register Process
void verifyApiCall(context) async {
  Utils().showSpinner(context);

  try {
    final authFlowProvider = context.read<AuthFlowProvider>();
    await GetApiServer()
        .verifyOtpApi(otpCode, widget.emailId.toString())
        .then((value) {
      log(value.toString());
      FocusScope.of(context).requestFocus(FocusNode());
      Utils().stopSpinner(context);

      if (value['success'] == 'true') {
        // Mark account as verified
        authFlowProvider.saveVerificationStatus('verified');
        
        // Complete registration
        authFlowProvider.completeRegistration();
        
        Utils().myToast(context, msg: 'Account verified successfully!');
        
        // Navigate to login
        Timer(const Duration(milliseconds: 600), () {
          PageNavigateScreen().pushRemovUntil(context, LoginPage());
        });
      } else {
        Utils().myToast(context, msg: value['msg']);
      }
    });
  } catch (e) {
    Utils().stopSpinner(context);
    Utils().myToast(context, msg: 'Verification failed. Please try again.');
  }
}

  void resendOTPApiCall(context) async {
    Utils().showSpinner(context);

    try {
      final authFlowProvider = context.read<AuthFlowProvider>();
      await GetApiServer()
          .resendOtpApi(widget.emailId.toString())
          .then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }

  void myDialogPopup(context) {
    showDialog(
        context: context,
        barrierDismissible: Platform.isAndroid ? false : true,
        builder: (context) {
          return const VerifyOtpPopup();
        });
  }

// For Forget Passwoord Process
  void verifyForgetPasswordApiCall(context) async {
    Utils().showSpinner(context);
    final authFlowProvider = context.read<AuthFlowProvider>();
    dynamic body = {
      'email': widget.emailId.toString(),
      'otp': otpCode,
    };
    try {
      await PostApiServer().resetPasswordApi(body).then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);

        if (value['success'] == 'true') {
          myResetDialogPopup(context, 'OTP verification successfully');
        } else {
          Utils().myToast(context, msg: value['msg']);
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }

  void resendOTPForgetPasswordApiCall(context) async {
    Utils().showSpinner(context);

    try {
      final authFlowProvider = context.read<AuthFlowProvider>();
      await GetApiServer()
          .forgetPasswordApi(widget.emailId.toString())
          .then((value) {
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);
        Utils().myToast(context,
            msg: 'OTP resent successfully. Please check your mail!');
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log(e.toString());
    }
  }

  void myResetDialogPopup(context, msg) {
    showDialog(
        context: context,
        barrierDismissible: Platform.isAndroid ? false : true,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Image.asset(
              'assets/images/success.png',
              height: 100,
            ),
            content: SizedBox(
              height: SizeConfig.getSizeHeightBy(context: context, by: 0.17),
              child: Column(
                children: [
                  Text(
                    msg.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: DynamicColor.green),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  CommanButton(
                      hight: 40.0,
                      width:
                          SizeConfig.getSizeWidthBy(context: context, by: 0.3),
                      buttonName: 'OK',
                      buttonBGColor: DynamicColor.primaryColor,
                      onPressed: () {
                        PageNavigateScreen().push(
                            context,
                            ResetPasswordPage(
                              email: widget.emailId,
                              otp: otpCode,
                            ));
                      },
                      shap: 7)
                ],
              ),
            ),
          );
        });
  }

  // Add this new method for login verification
  void verifyLoginApiCall(context) async {
    Utils().showSpinner(context);

    try {
      print('Verifying OTP for login: ${widget.emailId} with code: $otpCode');
      
      final authFlowProvider = context.read<AuthFlowProvider>();
      await GetApiServer()
          .verifyOtpApi(otpCode, widget.emailId.toString())
          .then((value) {
        print('=== OTP VERIFICATION RESPONSE ===');
        print('Full response: $value');
        print('Response type: ${value.runtimeType}');
        print('Success field: ${value['success']}');
        print('Message field: ${value['msg']}');
        print('================================');
        
        FocusScope.of(context).requestFocus(FocusNode());
        Utils().stopSpinner(context);

        if (value['success'] == 'true' || value['success'] == true) {
          // Mark account as verified
          authFlowProvider.saveVerificationStatus('verified');
          
          Utils().myToast(context, msg: 'Account verified successfully!');
          
          // Navigate to appropriate home screen
          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, BuyerHomePage());
          });
        } else {
          print('OTP verification failed: ${value['msg']}');
          Utils().myToast(context, msg: value['msg'] ?? 'Verification failed');
        }
      }).catchError((error) {
        print('OTP verification catchError: $error');
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: 'Verification failed. Please try again.');
      });
    } catch (e) {
      print('OTP verification error: $e');
      Utils().stopSpinner(context);
      Utils().myToast(context, msg: 'Verification failed. Please try again.');
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }
}
