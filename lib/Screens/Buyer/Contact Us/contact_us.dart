import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/settings_provider.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class ContactUsFormPage extends StatefulWidget {
  const ContactUsFormPage({super.key});

  @override
  State<ContactUsFormPage> createState() => _ContactUsFormPageState();
}

class _ContactUsFormPageState extends State<ContactUsFormPage> {
  TextEditingController textEditingController = TextEditingController();

  dynamic userData;

  String getUserType = 'buyer';

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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['contact_us']!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.getSize30(context: context),
                  left: SizeConfig.getSize20(context: context),
                  right: SizeConfig.getSize20(context: context)),
              child: InputFieldsWithLightWhiteColor(
                  controller: textEditingController,
                  labelText: 'Please describe your problem',
                  textInputAction: TextInputAction.done,
                  maxLines: 8,
                  keyboardType: TextInputType.emailAddress,
                  style: black15bold,
                  onChanged: (value) {
                    setState(() {});
                  }),
            ),
            SizedBox(height: SizeConfig.getSize60(context: context)),
            CommanButton(
                heroTag: 1,
                shap: 10.0,
                width: MediaQuery.of(context).size.width * 0.5,
                buttonName: TextStrings.textKey['submit']!.toUpperCase(),
                onPressed: () {
                  if (textEditingController.text.isNotEmpty) {
                    contactUsApiCall(context);
                  } else {
                    Utils().myToast(context, msg: 'Please enter some text');
                  }
                })
          ],
        ),
      ),
    );
  }

  void contactUsApiCall(context) async {
    Utils().showSpinner(context);

    final body = {
      'user_id': userData['user_id'].toString(),
      'description': textEditingController.text.trim(),
      'player_id': playerID,
      'device_type': deviceType,
    };

    final settingsProvider = context.read<SettingsProvider>();

    try {
      final success = await settingsProvider.submitContact(body);
      Utils().stopSpinner(context);

      if (success) {
        final message = settingsProvider.submitMessage.isNotEmpty
            ? settingsProvider.submitMessage
            : 'Feedback sent successfully';
        Utils().myToast(context, msg: message);
        if (getUserType == 'buyer') {
          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          });
        } else if (getUserType == 'chef') {
          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
          });
        } else {
          Timer(const Duration(milliseconds: 600), () {
            PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
          });
        }
      } else {
        final error = settingsProvider.submitError.isNotEmpty
            ? settingsProvider.submitError
            : 'Unable to send request';
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
