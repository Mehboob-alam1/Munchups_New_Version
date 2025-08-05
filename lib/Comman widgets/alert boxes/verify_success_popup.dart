import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Auth/login.dart';

class VerifyOtpPopup extends StatefulWidget {
  const VerifyOtpPopup({super.key});

  @override
  State<VerifyOtpPopup> createState() => _VerifyOtpPopupState();
}

class _VerifyOtpPopupState extends State<VerifyOtpPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Image.asset(
        'assets/images/success.png',
        height: 100,
      ),
      content: SizedBox(
        height: SizeConfig.getSizeHeightBy(context: context, by: 0.17),
        child: Column(
          children: [
            const Text('Your Account is Activated',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DynamicColor.green)),
            const SizedBox(height: 10),
            const Text(
              'Successfully.',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: DynamicColor.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            CommanButton(
                hight: 40.0,
                width: SizeConfig.getSizeWidthBy(context: context, by: 0.3),
                buttonName: 'OK',
                buttonBGColor: DynamicColor.primaryColor,
                onPressed: () {
                  PageNavigateScreen()
                      .pushRemovUntil(context, const LoginPage());
                },
                shap: 7)
          ],
        ),
      ),
    );
  }
}
