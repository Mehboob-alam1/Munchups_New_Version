import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Screens/Setting/Models/termsAndCond.dart';

class TermsAndConditonPage extends StatefulWidget {
  TermsAndConditonPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditonPage> createState() => _TermsAndConditonPageState();
}

class _TermsAndConditonPageState extends State<TermsAndConditonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['terms&con']!)),
      body: FutureBuilder<TermsAndConditionsModel>(
          future: GetApiServer().trmsAndCondiApi(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('No Terms And Conditions available'));
                } else if (snapshot.data!.success != 'true') {
                  return const Center(
                      child: Text('No Terms And Conditions available'));
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.data!.termsConditions),
                    ),
                  );
                }
            }
          }),
    );
  }
}
