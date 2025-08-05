// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Screens/Setting/Models/termsAndCond.dart';
//
// class PrivacyPolicyPage extends StatefulWidget {
//   PrivacyPolicyPage({Key? key}) : super(key: key);
//
//   @override
//   State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
// }
//
// class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['policy']!)),
//       body: FutureBuilder<TermsAndConditionsModel>(
//           future: GetApiServer().trmsAndCondiApi(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return const Center(
//                     child: CircularProgressIndicator(
//                   color: DynamicColor.primaryColor,
//                 ));
//               default:
//                 if (snapshot.hasError) {
//                   return const Center(
//                       child: Text('No Privacy Policy available'));
//                 } else if (snapshot.data!.success != 'true') {
//                   return const Center(
//                       child: Text('No Privacy Policy available'));
//                 } else {
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(snapshot.data!.privacyPolicy),
//                     ),
//                   );
//                 }
//             }
//           }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['policy']!),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.getSize20(context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: primary25bold),
            const SizedBox(height: 20),
            Text(
              _privacyPolicyText,
              style: white15Normal,
            ),
          ],
        ),
      ),
    );
  }
}

const String _privacyPolicyText = '''
This is a sample privacy policy. Please replace this text with your app's actual privacy policy content.

We value your privacy and are committed to protecting your personal information. This policy outlines how we collect, use, and protect your data.

1. **Information Collection**: We do not collect personal information without your consent.
2. **Usage of Information**: Your data is used only to improve user experience.
3. **Third-Party Services**: We do not share your data with third parties.
4. **Data Retention**: We retain data only as long as necessary.
5. **Security**: We implement strong safeguards to protect your data.

For more information, please contact our support team.

Last updated: August 6, 2025
''';
