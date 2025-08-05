import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Screens/Buyer/Card%20Payment/card_payment_form.dart';

class InsuficiantAmountPopup extends StatefulWidget {
  String msg;
  String notes;
  dynamic dishData;
  InsuficiantAmountPopup({
    super.key,
    required this.msg,
    required this.dishData,
    required this.notes,
  });

  @override
  State<InsuficiantAmountPopup> createState() => _InsuficiantAmountPopupState();
}

class _InsuficiantAmountPopupState extends State<InsuficiantAmountPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          'Munchups Information!',
          style: TextStyle(
              color: DynamicColor.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        widget.msg,
        textAlign: TextAlign.center,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CommanButton(
              //     hight: 40.0,
              //     width: 60.0,
              //     buttonName: TextStrings.textKey['no']!,
              //     buttonBGColor: DynamicColor.green,
              //     onPressed: () {
              //       PageNavigateScreen().back(context);
              //     },
              //     shap: 7),
              CommanButton(
                  hight: 40.0,
                  width: 100.0,
                  buttonName: 'Ok',
                  buttonBGColor: DynamicColor.primaryColor,
                  onPressed: () {
                    PageNavigateScreen().back(context);
                    PageNavigateScreen().push(
                        context,
                        CardPaymentFormPage(
                          type: 'order',
                          dishData: widget.dishData,
                          notes: widget.notes,
                        ));
                  },
                  shap: 50)
            ],
          ),
        )
      ],
    );
  }
}
