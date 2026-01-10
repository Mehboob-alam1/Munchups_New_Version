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

      // Initialize Stripe right before use to ensure theme is ready
      try {
        await Stripe.instance.applySettings();
        log('✅ Stripe initialized successfully for card payment');
      } catch (stripeInitError) {
        log('❌ Stripe initialization error: $stripeInitError');
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: 'Stripe initialization failed. Please restart the app.');
        return;
      }

      log('📝 Creating card details...');
      log('Card number length: ${cardNumberController.text.trim().length}');
      log('Expiry month: $expairyMonth, Year: $expairyYear');
      log('CVV length: ${cvvController.text.length}');

      // Validate card details before proceeding
      if (cardNumberController.text.trim().isEmpty) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: 'Please enter card number');
        log('❌ Card number is empty');
        return;
      }

      if (expairyMonth == 0 || expairyYear == 0) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: 'Please select expiry date');
        log('❌ Expiry date not selected');
        return;
      }

      if (cvvController.text.isEmpty || cvvController.text.length < 3) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: 'Please enter valid CVV');
        log('❌ CVV is invalid');
        return;
      }

      final cardDetails = CardDetails(
        number: cardNumberController.text.trim().replaceAll(' ', ''),
        expirationMonth: expairyMonth,
        expirationYear: expairyYear,
        cvc: cvvController.text,
      );
      
      log('📝 Card details created, saving...');
      saveCardDetail(cardDetails.toJson());
      
      log('📝 Updating Stripe with card details...');
      Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

      log('📝 Creating billing details...');
      final billingDetails = BillingDetails(
        email: userData['email'] ?? '',
        name: userData['user_name'] ?? '',
        phone: userData['phone'] ?? '',
        address: Address(
          country: '',
          //userData['country'],
          state: userData['state'] ?? '',
          city: userData['city'] ?? '',
          line1: userData['address'] ?? '',
          line2: '',
          postalCode: userData['postal_code'] ?? '',
        ),
      );

      log('📝 Creating payment method with Stripe...');
      /// create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData:
                  PaymentMethodData(billingDetails: billingDetails)));
      
      log('✅ Payment method created: ${paymentMethod.id}');
      setState(() {
        stripeToken = paymentMethod.id;
      });
      
      log('📝 Calling customerTokenAPiCall with token: ${paymentMethod.id}');
      customerTokenAPiCall(context, paymentMethod.id);
    } catch (e, stackTrace) {
      Utils().stopSpinner(context);
      log('❌ Error in getStripeToken: $e');
      log('❌ Stack trace: $stackTrace');
      Utils().myToast(context, msg: 'Error: ${e.toString()}');
    }
  }

  void customerTokenAPiCall(context, token) async {
    try {
      log('📞 Calling customerTokenTestApi with token: $token');
      log('📞 API URL: ${Utils.baseUrl()}customer_token_test.php');
      
      await PostApiServer().customerTokenTestApi(token).then((value) {
        log('📥 API Response received: $value');
        Utils().stopSpinner(context);
        
        if (value != null && value['success'] == 'true') {
          log('✅ API returned success=true, proceeding to next screen');
          
          // Show success message if available
          if (value['msg'] != null) {
            Utils().myToast(context, msg: value['msg']);
          }
          
          if (widget.type == 'order') {
            orderPlaceApiCall(context);
          } else {
            Timer(const Duration(milliseconds: 600), () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const BuyerHomePage());
            });
          }
        } else {
          // API returned an error - show proper error dialog
          log('⚠️ API did not return success=true');
          log('⚠️ Response value: $value');
          
          String errorMessage = value != null && value['msg'] != null 
              ? value['msg'] 
              : 'Failed to save card details. Please try again.';
          
          // Show error dialog with proper message
          _showErrorDialog(context, errorMessage);
        }
      }).catchError((error, stackTrace) {
        log('❌ API call failed with error: $error');
        log('❌ Stack trace: $stackTrace');
        Utils().stopSpinner(context);
        
        // Show error dialog for API call failure
        String errorMessage = 'Network error occurred. Please check your connection and try again.';
        if (error.toString().contains('SocketException') || 
            error.toString().contains('TimeoutException')) {
          errorMessage = 'Connection timeout. Please check your internet connection and try again.';
        }
        
        _showErrorDialog(context, errorMessage);
      });
    } catch (e, stackTrace) {
      log('❌ Exception in customerTokenAPiCall: $e');
      log('❌ Stack trace: $stackTrace');
      Utils().stopSpinner(context);
      
      _showErrorDialog(context, 'An unexpected error occurred. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Card Error',
                  style: TextStyle(
                    color: DynamicColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (message.toLowerCase().contains('real card') ||
                    message.toLowerCase().contains('test card')) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Solution:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'You are using a real card in test mode. Please use one of Stripe\'s test cards:',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Success: 4242 4242 4242 4242\n• Decline: 4000 0000 0000 0002\n• Use any future expiry date and any 3-digit CVV',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // You can add URL launcher here if needed
                            log('Visit: https://stripe.com/docs/testing');
                          },
                          child: Text(
                            'Learn more: https://stripe.com/docs/testing',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: DynamicColor.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
