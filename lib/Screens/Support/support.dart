// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Screens/Auth/login.dart';
// import 'package:munchups_app/Screens/Buyer/Contact%20Us/contact_us.dart';
// import 'package:munchups_app/Screens/Setting/faq.dart';
// import 'package:munchups_app/Screens/Support/about_us.dart';
// import 'package:munchups_app/Screens/Support/tutorial.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../Comman widgets/app_bar/back_icon_appbar.dart';
//
// class SupportPage extends StatefulWidget {
//   const SupportPage({super.key});
//
//   @override
//   State<SupportPage> createState() => _SupportPageState();
// }
//
// class _SupportPageState extends State<SupportPage> {
//   dynamic userData;
//
//   getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userData = jsonDecode(prefs.getString('data').toString());
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['support']!)),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           customWidget(
//               iconData: Icons.contacts,
//               title: TextStrings.textKey['contact_us']!,
//               onTap: () {
//                 if (userData != null) {
//                   PageNavigateScreen().push(context, const ContactUsFormPage());
//                 } else {
//                   PageNavigateScreen().push(context, const LoginPage());
//                 }
//               }),
//           const Divider(height: 10, color: DynamicColor.white),
//           customWidget(
//               iconData: Icons.info_outlined,
//               title: 'About Us',
//               onTap: () {
//                 PageNavigateScreen().push(context, const AboutUsPage());
//               }),
//           const Divider(height: 10, color: DynamicColor.white),
//           customWidget(
//               iconData: Icons.subscriptions,
//               title: 'Tutorial',
//               onTap: () {
//                 PageNavigateScreen().push(context, const TutorialPage());
//               }),
//           const Divider(height: 10, color: DynamicColor.white),
//           customWidget(
//               iconData: Icons.contact_support,
//               title: TextStrings.textKey['faq']!,
//               onTap: () {
//                 PageNavigateScreen().push(context, const FAQPage());
//               }),
//           const Divider(height: 10, color: DynamicColor.white),
//         ],
//       ),
//     );
//   }
//
//   Widget customWidget(
//       {required IconData iconData,
//       required String title,
//       required VoidCallback onTap}) {
//     return ListTile(
//       onTap: onTap,
//       minLeadingWidth: 0.0,
//       minVerticalPadding: 0.0,
//       horizontalTitleGap: 10.0,
//       leading: CircleAvatar(
//         radius: 20,
//         backgroundColor: DynamicColor.primaryColor,
//         child: Icon(iconData, color: DynamicColor.white),
//       ),
//       title: Text(title, style: white17Bold),
//       trailing: const Icon(
//         Icons.arrow_forward_ios,
//         color: DynamicColor.white,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:munchups_app/Screens/Buyer/Contact%20Us/contact_us.dart';
import 'package:munchups_app/Screens/Setting/faq.dart';
import 'package:munchups_app/Screens/Support/about_us.dart';
import 'package:munchups_app/Screens/Support/tutorial.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['support']!),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          customWidget(
            context,
            iconData: Icons.contacts,
            title: TextStrings.textKey['contact_us']!,
            onTap: () {
              // Just navigate — no login check
              PageNavigateScreen().push(context, const ContactUsFormPage());
            },
          ),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
            context,
            iconData: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              PageNavigateScreen().push(context, const AboutUsPage());
            },
          ),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
            context,
            iconData: Icons.subscriptions,
            title: 'Tutorial',
            onTap: () {
              PageNavigateScreen().push(context, const TutorialPage());
            },
          ),
          const Divider(height: 10, color: DynamicColor.white),
          customWidget(
            context,
            iconData: Icons.contact_support,
            title: TextStrings.textKey['faq']!,
            onTap: () {
              PageNavigateScreen().push(context, const FAQPage());
            },
          ),
          const Divider(height: 10, color: DynamicColor.white),
        ],
      ),
    );
  }

  Widget customWidget(BuildContext context,
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
      trailing: const Icon(Icons.arrow_forward_ios, color: DynamicColor.white),
    );
  }
}
