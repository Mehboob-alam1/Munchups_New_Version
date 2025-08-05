import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/add_to_cart_popup.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/terms_popup.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCardWidget extends StatefulWidget {
  dynamic data;
  dynamic checkGuestUser;
  AddToCardWidget({
    super.key,
    required this.data,
    this.checkGuestUser,
  });

  @override
  State<AddToCardWidget> createState() => _AddToCardWidgetState();
}

class _AddToCardWidgetState extends State<AddToCardWidget> {
  dynamic showTerms;

  @override
  void initState() {
    super.initState();
    getTermsdata();
  }

  getTermsdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showTerms = jsonDecode(prefs.getString('show_terms').toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    getTermsdata();
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (widget.checkGuestUser != null) {
            if (showTerms != null) {
              if (showTerms) {
                showDialog(
                    barrierDismissible: Platform.isAndroid ? false : true,
                    context: context,
                    builder: (context) => AddToCartPopup(data: widget.data));
              } else {
                showDialog(
                    barrierDismissible: Platform.isAndroid ? false : true,
                    context: context,
                    builder: (context) => TermsPoupup(
                          msg:
                              "I Herby accept full responsibility legally and morally that I am sharing food only that I am eating first. All and everything is my responsibility in terms of hygiene safety and quality of food shared. Food shared will be in accordance of F&B safety and in accordance with the law of any country it's being shared in. I held munchups absolutely not responsible of anything what's so ever known or unknown legal or moral grounds challenged effected or are in question. munchups ltd is only platform where sharer is responsible of A-Z matters and munchups ltd will not be accountable of any legal or compliance matters. I share with full responsibility and take full responsibility of my sharing food.",
                        )).then((value) {
                  setState(() {
                    getTermsdata();
                  });
                });
              }
            } else {
              showDialog(
                  barrierDismissible: Platform.isAndroid ? false : true,
                  context: context,
                  builder: (context) => TermsPoupup(
                        msg:
                            "I Herby accept full responsibility legally and morally that I am sharing food only that I am eating first. All and everything is my responsibility in terms of hygiene safety and quality of food shared. Food shared will be in accordance of F&B safety and in accordance with the law of any country it's being shared in. I held munchups absolutely not responsible of anything what's so ever known or unknown legal or moral grounds challenged effected or are in question. munchups ltd is only platform where sharer is responsible of A-Z matters and munchups ltd will not be accountable of any legal or compliance matters. I share with full responsibility and take full responsibility of my sharing food.",
                      )).then((value) {
                setState(() {
                  getTermsdata();
                });
              });
            }
          } else {
            PageNavigateScreen().push(context, const LoginPage());
          }
        },
        child: Container(
          height: 25,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          width: SizeConfig.getSizeWidthBy(context: context, by: 0.3),
          padding: const EdgeInsets.only(left: 8, right: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: DynamicColor.primaryColor,
              border: Border.all(color: DynamicColor.primaryColor),
              borderRadius: BorderRadius.circular(8)),
          child: Text('Add to Cart', style: white13w5),
        ),
      ),
    );
  }
}
