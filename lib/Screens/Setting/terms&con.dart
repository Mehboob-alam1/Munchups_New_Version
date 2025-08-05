// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Screens/Setting/Models/termsAndCond.dart';
//
// class TermsAndConditonPage extends StatefulWidget {
//   TermsAndConditonPage({Key? key}) : super(key: key);
//
//   @override
//   State<TermsAndConditonPage> createState() => _TermsAndConditonPageState();
// }
//
// class _TermsAndConditonPageState extends State<TermsAndConditonPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child:
//               BackIconCustomAppBar(title: TextStrings.textKey['terms&con']!)),
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
//                       child: Text('No Terms And Conditions available'));
//                 } else if (snapshot.data!.success != 'true') {
//                   return const Center(
//                       child: Text('No Terms And Conditions available'));
//                 } else {
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(snapshot.data!.termsConditions),
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

class TermsAndConditonPage extends StatelessWidget {
  const TermsAndConditonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['terms&con']!),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.getSize20(context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms & Conditions', style: primary25bold),
            const SizedBox(height: 20),
            Text(
              _termsAndConditionsText,
              style: white15Normal,
            ),
          ],
        ),
      ),
    );
  }
}

const String _termsAndConditionsText = '''
These are sample Terms & Conditions. Replace this content with your actual terms.

1. **Acceptance of Terms**
   By using this application, you agree to these Terms and Conditions.

2. **User Conduct**
   Users are expected to behave respectfully and not misuse the platform.

3. **Limitation of Liability**
   The app is not responsible for any damages or losses arising from use.

4. **Modifications**
   We reserve the right to update or modify these terms at any time.

5. **Termination**
   Violation of these terms may result in account suspension or termination.

For questions or clarifications, contact our support team.

Last updated: August 6, 2025
''';
