import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/providers/main_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Component/providers/app_provider.dart';
import '../../Component/providers/auth_provider.dart';

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
                  right: SizeConfig.getSize15(context: context)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.getSize55(context: context)),
                  Center(
                    child: Image.asset(
                      context.read<AppProvider>().appLogoUrl,
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
        labelText: 'Email',
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        style: white15bold,
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
      padding: EdgeInsets.only(
          left: SizeConfig.getSize10(context: context),
          right: SizeConfig.getSize10(context: context)),
      child: InputFieldsWithLightWhiteColor(
        labelText: 'Password',
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
        style: white15bold,
        obsecureText: !passwordVisible,
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: DynamicColor.white,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
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
      padding: EdgeInsets.only(
          left: SizeConfig.getSize10(context: context),
          right: SizeConfig.getSize10(context: context)),
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
              padding: EdgeInsets.only(
                  left: SizeConfig.getSize10(context: context),
                  right: SizeConfig.getSize10(context: context)),
                              child: CommanButton(
                  buttonName: authProvider.isLoading ? 'Logging in...' : 'Login',
                  onPressed: authProvider.isLoading 
                    ? () {} // Empty function when loading
                    : () => _handleLogin(),
                  // backgroundColor: DynamicColor.primaryColor,
                  textColor: DynamicColor.white, shap: 12,
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
      
      final success = await authProvider.login(emailID, password);
      
      if (success && mounted) {
        // Navigate based on user type
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
      }
    }
  }

  Widget dontAcunt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: white15bold),
        TextButton(
          onPressed: () {
            PageNavigateScreen().push(context,  RegisterPage());
          },
          child: Text('Sign Up', style: white15bold),
        ),
      ],
    );
  }

  Widget termsAndCondi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('By continuing, you agree to our ', style: white15bold),
        TextButton(
          onPressed: () {
            PageNavigateScreen().push(context,  TermsAndConditonPage());
          },
          child: Text('Terms & Conditions', style: white15bold),
        ),
        Text(' and ', style: white15bold),
        TextButton(
          onPressed: () {
            PageNavigateScreen().push(context,  PrivacyPolicyPage());
          },
          child: Text('Privacy Policy', style: white15bold),
        ),
      ],
    );
  }
}
