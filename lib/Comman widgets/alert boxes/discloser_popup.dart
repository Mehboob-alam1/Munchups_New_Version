import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiscloserPopup extends StatefulWidget {
  const DiscloserPopup({super.key});

  @override
  State<DiscloserPopup> createState() => _DiscloserPopupState();
}

class _DiscloserPopupState extends State<DiscloserPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Center(child: Text('Note', style: white21w5)),
      content: const Text(
        'We collect user data such as name, email address, and app usage data for account creation and analytics purposes and location. Data is transmitted off-device to third-party analytics services (Stripe) and encrypted using industry-standard TLS protocols.',
        textAlign: TextAlign.center,
      ),
      actions: [
        CommanButton(
            hight: 40.0,
            width: 120.0,
            buttonName: 'Accept',
            buttonBGColor: DynamicColor.green,
            onPressed: () {
              setdiscloser(context);
            },
            shap: 7),
      ],
    );
  }

  void setdiscloser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('discloser', 'Disclosed');
    });
    Navigator.pop(context);
  }
}
