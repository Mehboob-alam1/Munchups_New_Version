import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsPoupup extends StatefulWidget {
  String msg;
  TermsPoupup({super.key, required this.msg});

  @override
  State<TermsPoupup> createState() => _TermsPoupupState();
}

class _TermsPoupupState extends State<TermsPoupup> {
  bool isOk = false;
  saveTermdata(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('show_terms', value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.only(left: 15, right: 15),
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.only(left: 20, right: 20),
      title: const Center(
          child: Text(
        'Checkbox on the Cart',
        // style: primary17w6,
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Customers must accept the terms and conditions to Add to Cart',
            textAlign: TextAlign.center,
            style: TextStyle(color: DynamicColor.borderline),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                  checkColor: DynamicColor.white,
                  focusColor: DynamicColor.white,
                  hoverColor: DynamicColor.white,
                  // fillColor: MaterialStateProperty.all(DynamicColor.green),
                  activeColor: DynamicColor.green,
                  value: isOk,
                  onChanged: (value) {
                    setState(() {
                      isOk = value!;
                      saveTermdata(value);
                    });
                  }),
              RichText(
                text: TextSpan(
                  text: 'I accept the ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: TextStrings.textKey['terms&con']!.toLowerCase(),
                      style: primary15boldWithUnderline,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          PageNavigateScreen()
                              .push(context, const NewTremsOage());
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommanButton(
                  hight: 40.0,
                  width: MediaQuery.of(context).size.width - 100,
                  buttonName: 'Accept',
                  buttonBGColor: DynamicColor.green,
                  onPressed: () {
                    if (isOk) {
                      PageNavigateScreen().back(context);
                    } else {
                      Utils().myToast(context,
                          msg: 'Please select terms and conditions');
                    }
                  },
                  shap: 7),
            ],
          ),
        )
      ],
    );
  }
}

class NewTremsOage extends StatefulWidget {
  const NewTremsOage({super.key});

  @override
  State<NewTremsOage> createState() => _NewTremsOageState();
}

class _NewTremsOageState extends State<NewTremsOage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['terms&con']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adding a header with a different style
              const Text(
                'Food Sharing Responsibility Agreement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              // Adding the first section of the paragraph
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  children: [
                    TextSpan(text: 'I hereby accept '),
                    TextSpan(
                      text: 'full responsibility legally and morally',
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ' that I am sharing food only that I am eating first. All and everything is my responsibility in terms of hygiene, safety, and quality of food shared. '
                          'Food shared will be in accordance with F&B safety and in accordance with the law of any country it\'s being shared in. ',
                    ),
                    TextSpan(
                      text: 'I hold Munchups absolutely not responsible ',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text:
                          'for anything whatsoever, known or unknown, legal or moral grounds challenged, affected, or are in question.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Divider for better sectioning
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              // Adding the second section of the paragraph
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  children: [
                    TextSpan(
                      text:
                          'Munchups Ltd is only a platform where the sharer is responsible for ',
                    ),
                    TextSpan(
                      text: 'A-Z matters, ',
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'and Munchups Ltd will not be accountable for any legal or compliance matters.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              // Final declaration with bold styling
              const Text(
                'I share with full responsibility and take full responsibility for my sharing food.',
                style: TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
