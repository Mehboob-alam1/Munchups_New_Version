import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Card%20Payment/Credit%20Card%20Formats/card_number_formats.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class CardPaymentFormPage extends StatefulWidget {
  String type;
  String? notes;
  dynamic dishData;

  CardPaymentFormPage(
      {super.key, required this.type, this.notes, this.dishData});
  @override
  _CardPaymentFormPageState createState() => _CardPaymentFormPageState();
}

class _CardPaymentFormPageState extends State<CardPaymentFormPage> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  bool showBackView = false;
  bool isSavedCard = false;

  String formattedCardNumber = '';
  String formattedDate = '';
  String stripeToken = '';

  int expairyMonth = 0;
  int expairyYear = 0;

  dynamic userData;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  saveCardDetail(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('card_detail', jsonEncode(data)).toString();
    });
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Account Information')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CardNumberFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  counterText: '',
                ),
                maxLength: 19,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        selectMonth(context);
                      },
                      controller: expiryMonthController,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Month',
                        hintText: 'MM',
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        selectYear(context);
                      },
                      controller: expiryYearController,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          labelText: 'Expiry Year',
                          hintText: 'YY',
                          suffixIcon: Icon(Icons.calendar_month)),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  counterText: '',
                ),
                maxLength: 3,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: DynamicColor.green),
                  onPressed: cardNumberController.text.isEmpty ||
                          expiryMonthController.text.isEmpty ||
                          expiryYearController.text.isEmpty ||
                          cvvController.text.isEmpty
                      ? null
                      : () {
                          if (cardNumberController.text.isNotEmpty &&
                              expiryMonthController.text.isNotEmpty &&
                              expiryYearController.text.isNotEmpty &&
                              cvvController.text.isNotEmpty) {
                            setState(() {
                              isSavedCard = true;
                            });
                            getStripeToken(context);
                          } else {
                            Utils().myToast(context,
                                msg: 'All fields are required.');
                          }
                        },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectMonth(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final int? pickedMonth = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return MonthPickerDialog(
          initialMonth: expairyMonth == 0 ? DateTime.now().month : expairyMonth,
        );
      },
    );

    if (pickedMonth != null) {
      setState(() {
        expiryMonthController.text =
            pickedMonth > 9 ? pickedMonth.toString() : '0$pickedMonth';
        expairyMonth = pickedMonth;
      });
    }
  }

  Future<void> selectYear(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final int? pickedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return YearPickerDialog(
          initialYear: expairyYear == 0 ? DateTime.now().year : expairyYear,
        );
      },
    );

    if (pickedYear != null) {
      setState(() {
        expiryYearController.text = pickedYear.toString();
        expairyYear = pickedYear;
      });
    }
  }

  void getStripeToken(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      Utils().showSpinner(context);

      final cardDetails = CardDetails(
        number: cardNumberController.text.trim(),
        expirationMonth: expairyMonth,
        expirationYear: expairyYear,
        cvc: cvvController.text,
      );
      saveCardDetail(cardDetails.toJson());
      Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

      final billingDetails = BillingDetails(
        email: userData['email'],
        name: userData['user_name'],
        phone: userData['phone'],
        address: Address(
          country: '',
          //userData['country'],
          state: userData['state'],
          city: userData['city'],
          line1: userData['address'],
          line2: '',
          postalCode: userData['postal_code'],
        ),
      );

      /// create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData:
                  PaymentMethodData(billingDetails: billingDetails)));
      setState(() {
        stripeToken = paymentMethod.id;
      });
      customerTokenAPiCall(context, paymentMethod.id);
    } catch (e) {
      Utils().stopSpinner(context);
      Utils().myToast(context, msg: e.toString());
      log(e.toString());
    }
  }

  void customerTokenAPiCall(context, token) async {
    try {
      await PostApiServer().customerTokenTestApi(token).then((value) {
        Utils().stopSpinner(context);
        //Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          if (widget.type == 'order') {
            orderPlaceApiCall(context);
          } else {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const BuyerHomePage());
            });
          }
        }
      });
    } catch (e) {
      log(e.toString());
      Utils().stopSpinner(context);
    }
  }

  void orderPlaceApiCall(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScope.of(context).requestFocus(FocusNode());
    Utils().showSpinner(context);
    try {
      dynamic body = {
        'user_id': userData['user_id'].toString(),
        'chef_grocer_id': widget.dishData['chef_grocer_id'].toString(),
        'dish_id': widget.dishData['dish_id'].toString(),
        'dish_name': widget.dishData['dish_name'].toString(),
        'dish_image': widget.dishData['dish_image'].toString(),
        'quantity': widget.dishData['quantity'].toString(),
        'dish_price': widget.dishData['dish_price'].toString(),
        'total_price': widget.dishData['total_price'].toString(),
        'grand_total': widget.dishData['total_price'].toString(),
        'note': widget.notes.toString(),
      };
      await PostApiServer().orderPlaceApi(body).then((value) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          prefs.remove('cart');

          Timer(const Duration(milliseconds: 600), () {
            prefs.remove('cart');
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          });
        }
      });
    } catch (e) {
      log('cart error = ' + e.toString());
      Utils().stopSpinner(context);
    }
  }
}

class MonthPickerDialog extends StatelessWidget {
  final int initialMonth;

  MonthPickerDialog({required this.initialMonth});
  List months = [
    {'name': 'January', 'value': 01},
    {'name': 'February', 'value': 02},
    {'name': 'March', 'value': 03},
    {'name': 'April', 'value': 04},
    {'name': 'May', 'value': 05},
    {'name': 'June', 'value': 06},
    {'name': 'July', 'value': 07},
    {'name': 'August', 'value': 08},
    {'name': 'September', 'value': 09},
    {'name': 'October', 'value': 10},
    {'name': 'November', 'value': 11},
    {'name': 'December', 'value': 12},
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Month'),
      content: SizedBox(
        width: double.minPositive,
        height: 300,
        child: Wrap(
          children: List.generate(
              months.length,
              (index) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context, months[index]['value']);
                        },
                        child: Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: DynamicColor.lightGrey),
                                color: initialMonth == months[index]['value']
                                    ? Colors.blue
                                    : null,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              months[index]['name'].toString(),
                              style: white14w5,
                            ))),
                  )),
        ),
      ),
    );
  }
}

class YearPickerDialog extends StatelessWidget {
  final int initialYear;

  YearPickerDialog({required this.initialYear});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Year'),
      content: SizedBox(
        width: double.minPositive,
        height: 300,
        child: YearPicker(
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
          currentDate: DateTime(initialYear),
          selectedDate: DateTime(initialYear),
          onChanged: (DateTime dateTime) {
            Navigator.pop(context, dateTime.year);
          },
        ),
      ),
    );
  }
}
