// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ManageAccountPageForChefAndGrocer extends StatefulWidget {
//   const ManageAccountPageForChefAndGrocer({super.key});
//
//   @override
//   State<ManageAccountPageForChefAndGrocer> createState() =>
//       _ManageAccountPageForChefAndGrocerState();
// }
//
// class _ManageAccountPageForChefAndGrocerState
//     extends State<ManageAccountPageForChefAndGrocer> {
//   dynamic userData;
//
//   @override
//   void initState() {
//     super.initState();
//     getUserDetail();
//   }
//
//   getUserDetail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userData = jsonDecode(prefs.getString('data').toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: 'Manage Account')),
//       body: Column(
//         children: [
//           SizedBox(height: SizeConfig.getSize30(context: context)),
//           Text('Please connect your payment account', style: white15bold),
//           Text('After connecting your account you will redirect to',
//               style: white15bold),
//           Text('the stripe.com', style: white15bold),
//           SizedBox(height: SizeConfig.getSize30(context: context)),
//           Center(
//             child: ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: DynamicColor.green),
//               onPressed: () {
//                 startPayment();
//               },
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 10, right: 10),
//                 child: Text('Connect'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> startPayment() async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': ((int.parse('10')) * 100).toString(),
//         'currency': 'usd',
//         'payment_method_types[]': 'card',
//       };
//       // 1. Create payment intent on your server
//       //https://your-server.com/create-payment-intent
//       final response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer $screteKey',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//
//       final paymentIntentData = jsonDecode(response.body);
//       //pi_3PU2TtAtdu7mEd0n1NIcYNsc_secret_mSijeiIRMum4jZ3vzecVdscu6
//       // 2. Initialize payment sheet
//       if (Platform.isAndroid) {
//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: paymentIntentData['client_secret'],
//             googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
//             style: ThemeMode.light,
//             merchantDisplayName: userData != null
//                 ? userData['first_name'] + ' ' + userData['last_name']
//                 : 'Munchups',
//           ),
//         );
//       } else {
//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: paymentIntentData['client_secret'],
//             applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
//             style: ThemeMode.light,
//             merchantDisplayName: userData != null
//                 ? userData['first_name'] + ' ' + userData['last_name']
//                 : 'Munchups',
//           ),
//         );
//       }
//
//       // 3. Display payment sheet
//       await Stripe.instance.presentPaymentSheet();
//
//       // 4. Handle payment success
//     } catch (e) {
//       log(e.toString());
//       // Handle error
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class ManageAccountPageForChefAndGrocer extends StatefulWidget {
  const ManageAccountPageForChefAndGrocer({super.key});

  @override
  State<ManageAccountPageForChefAndGrocer> createState() => _ManageAccountPageForChefAndGrocerState();
}

class _ManageAccountPageForChefAndGrocerState extends State<ManageAccountPageForChefAndGrocer> {
  get white18bold => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Manage Account')),
      body: Column(
        children: [
          SizedBox(height: SizeConfig.getSize30(context: context)),
          Text('Please connect your payment account', style: white15bold),
          Text('After connecting your account you will redirect to', style: white15bold),
          Text('the stripe.com', style: white15bold),
          SizedBox(height: SizeConfig.getSize30(context: context)),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: DynamicColor.green),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: DynamicColor.boxColor,
                      title: Text('Stripe Connection', style: white18bold),
                      content: Text(
                          'This is a UI-only version. Payment integration is disabled for demo purposes.',
                          style: white14w5),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'))
                      ],
                    ));
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text('Connect'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
