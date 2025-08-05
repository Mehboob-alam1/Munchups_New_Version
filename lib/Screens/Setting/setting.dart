import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_account_popup.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:munchups_app/Screens/Buyer/Profile/profile.dart';
import 'package:munchups_app/Screens/Setting/change_password.dart';
import 'package:munchups_app/Screens/Setting/privacy&policy.dart';
import 'package:munchups_app/Screens/Setting/terms&con.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Comman widgets/app_bar/back_icon_appbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  dynamic userData;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: TextStrings.textKey['setting']!)),
      body: Column(
        children: [
          const SizedBox(height: 10),
          customWidget(
              iconData: Icons.lock,
              title: 'Change Password',
              onTap: () {
                if (userData != null) {
                  PageNavigateScreen()
                      .push(context, const ChangePasswordPage());
                } else {
                  PageNavigateScreen().push(context, const LoginPage());
                }
              }),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
              iconData: Icons.account_circle,
              title: 'Update Profile',
              onTap: () {
                if (userData != null) {
                  PageNavigateScreen().push(context, const BuyerProfilePage());
                } else {
                  PageNavigateScreen().push(context, const LoginPage());
                }
              }),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
              iconData: Icons.verified_user,
              title: TextStrings.textKey['terms&con']!,
              onTap: () {
                PageNavigateScreen().push(context, TermsAndConditonPage());
              }),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
              iconData: Icons.security,
              title: TextStrings.textKey['policy']!,
              onTap: () {
                PageNavigateScreen().push(context, PrivacyPolicyPage());
              }),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
              iconData: Icons.delete,
              title: TextStrings.textKey['delete_account']!,
              onTap: () {
                if (userData != null) {
                  showDialog(
                      barrierDismissible: Platform.isAndroid ? false : true,
                      context: context,
                      builder: (context) => const DeleteAccountPopUp());
                } else {
                  PageNavigateScreen().push(context, const LoginPage());
                }
              }),
          const Divider(height: 10, color: DynamicColor.white),
        ],
      ),
    );
  }

  Widget customWidget(
      {required IconData iconData,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 0.0,
      minVerticalPadding: 0.0,
      horizontalTitleGap: 10.0,
      contentPadding: const EdgeInsets.only(left: 10, right: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: DynamicColor.primaryColor,
        child: Icon(iconData, color: DynamicColor.white),
      ),
      title: Text(title, style: white17Bold),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: DynamicColor.white,
      ),
    );
  }
}
