// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Screens/Setting/Models/termsAndCond.dart';
//
// class AboutUsPage extends StatefulWidget {
//   const AboutUsPage({super.key});
//
//   @override
//   State<AboutUsPage> createState() => _AboutUsPageState();
// }
//
// class _AboutUsPageState extends State<AboutUsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['aboutus']!)),
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
//                   return const Center(child: Text('No About Us available'));
//                 } else if (snapshot.data!.success != 'true') {
//                   return const Center(child: Text('No About Us available'));
//                 } else {
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(snapshot.data!.aboutUs),
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

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['aboutus']!),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.getSize20(context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About Us', style: primary25bold),
            const SizedBox(height: 20),
            Text(
              _aboutUsText,
              style: white15Normal,
            ),
          ],
        ),
      ),
    );
  }
}

  const String _aboutUsText = '''
Welcome to MunchUps – your trusted food companion!

At MunchUps, our mission is to bring delicious, nutritious, and convenient meals to your fingertips. Whether you're ordering for yourself or sharing with friends, we believe every bite should be full of joy.

**What we do:**
- Curated food experiences tailored to your taste.
- Seamless ordering and delivery.
- Partnerships with top local vendors.

**Our Promise:**
We’re committed to providing a platform that is reliable, easy to use, and customer-focused.

Thank you for choosing MunchUps. Let’s munch better together!

— The MunchUps Team
''';
