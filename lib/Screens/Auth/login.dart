import 'dart:async';
import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/images_urls.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Auth/forgot_pass.dart';
import 'package:munchups_app/Screens/Auth/register.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:munchups_app/Screens/Setting/privacy&policy.dart';
import 'package:munchups_app/Screens/Setting/terms&con.dart';
import 'package:provider/provider.dart';
import '../../Apis/get_apis.dart';
import '../../presentation/providers/app_provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../Component/providers/auth_flow_provider.dart';
import 'otp.dart';

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

  @override
  void initState() {
    super.initState();
    // listenOtp(); // This line is removed as per the new_code, as the OTP screen will handle its own state.
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to safely access AppProvider
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
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
                          appProvider.appLogoUrl, // Use the provider from Consumer
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
      },
    );
  }

  Widget emialFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getSize10(context: context)),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        style: white15bold,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: white15bold,
          filled: true,
          // fillColor: DynamicColor.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DynamicColor.lightBlack),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DynamicColor.lightBlack),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DynamicColor.primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            emailID = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget passwordFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getSize10(context: context)),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
        style: white15bold,
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: white15bold,
          filled: true,
          // fillColor: DynamicColor.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DynamicColor.lightBlack),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DynamicColor.lightBlack),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: DynamicColor.primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: DynamicColor.primaryColor,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget rememberAndForgetPass() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getSize10(context: context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: isRemember,
                onChanged: (value) {
                  setState(() {
                    isRemember = value ?? false;
                  });
                },
                fillColor: MaterialStateProperty.all(DynamicColor.primaryColor),
                checkColor: DynamicColor.white,
              ),
              Text('Remember me', style: white15bold),
            ],
          ),
          TextButton(
            onPressed: () {
              PageNavigateScreen().push(context, const ForgetPasswordPage());
            },
            child: Text('Forgot Password?', style: white15bold),
          ),
        ],
      ),
    );
  }

  Widget buttons() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            // Show error if any
            if (authProvider.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  authProvider.error,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            // Login button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getSize10(context: context)),
              child: CommanButton(
                buttonName: authProvider.isLoading ? 'Logging in...' : 'Login',
                onPressed: authProvider.isLoading
                    ? () {} // Empty function when loading
                    : () => _handleLogin(),
                textColor: DynamicColor.white,
                shap: 12,
              ),
            ),

            // Show loading indicator
            if (authProvider.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (globalKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final authFlowProvider = context.read<AuthFlowProvider>();

      final success = await authProvider.login(emailID, password);

      if (success && mounted) {
        // Login successful, proceed to home screen
        final userType = authProvider.userType;
        Widget nextScreen;

        switch (userType) {
          case 'buyer':
            nextScreen = const BuyerHomePage();
            break;
          case 'chef':
            nextScreen = const ChefHomePage();
            break;
          case 'grocer':
            nextScreen = const GrocerHomePage();
            break;
          default:
            nextScreen = const BuyerHomePage();
        }

        PageNavigateScreen().normalpushReplesh(context, nextScreen);
      } else {
        // Login failed, check if it's because account is not verified
        String errorMessage = authProvider.error;
        
        if (errorMessage.contains('Please activate your account') || 
            errorMessage.contains('not_activated')) {
          print('Account not activated, starting OTP verification');
          
          // Start login verification flow
          final authFlowProvider = Provider.of<AuthFlowProvider>(context, listen: false);
          await authFlowProvider.startLoginVerification(emailID);
          
          // Send OTP for login verification
          await _sendOtpForLoginVerification();
          
          // Navigate to OTP screen
          PageNavigateScreen().push(
            context,
            OtpPage(
              emailId: emailID,
              type: 'login',
            ),
          );
        }
        // If it's a different error, the authProvider.error will be shown
      }
    }
  }

  // Add this method to send OTP for login verification
  Future<void> _sendOtpForLoginVerification() async {
    try {
      await GetApiServer().resendOtpApi(emailID);
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      // Don't show error to user here, let OTP screen handle it
    }
  }

  Widget dontAcunt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: white15bold),
        TextButton(
          onPressed: () {
            PageNavigateScreen().push(context, RegisterPage());
          },
          child: Text('Sign Up', style: white15bold),
        ),
      ],
    );
  }


  Widget termsAndCondi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('By continuing, you agree to our', style: white13w5),
          TextButton(
            onPressed: () {
              PageNavigateScreen().push(context, TermsAndConditonPage());
            },
            child: Text('Terms & Conditions', style: green14w5),
          ),
          Text(' and ', style: white13w5),
          TextButton(
            onPressed: () {
              PageNavigateScreen().push(context, PrivacyPolicyPage());
            },
            child: Text('Privacy Policy', style: green14w5),
          ),
        ],
      ),
    );
  }
}