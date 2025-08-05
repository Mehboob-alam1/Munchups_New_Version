import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateChefPage extends StatefulWidget {
  String chefID;
  String orderID;
  RateChefPage({
    super.key,
    required this.chefID,
    required this.orderID,
  });
  @override
  _RateChefPageState createState() => _RateChefPageState();
}

class _RateChefPageState extends State<RateChefPage> {
  double _rating = 0.0;
  TextEditingController commentController = TextEditingController();

  dynamic userData;

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = jsonDecode(prefs.getString('data').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getUsertype();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Chef Rating')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rate this Chef',
              style: primary25bold,
            ),
            const SizedBox(height: 20.0),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: commentController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Write your comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 50.0),
            CommanButton(
                heroTag: 1,
                shap: 10.0,
                hight: 40.0,
                width: MediaQuery.of(context).size.width * 0.4,
                buttonName: TextStrings.textKey['submit']!.toUpperCase(),
                onPressed: () {
                  chefRateApicall(context);
                })
          ],
        ),
      ),
    );
  }

  void chefRateApicall(context) async {
    Utils().showSpinner(context);
    dynamic body = {
      'from_user_id': userData['user_id'].toString(),
      'to_user_id': widget.chefID,
      'order_id': widget.orderID,
      'review': commentController.text.trim(),
      'rating': _rating.toStringAsFixed(0),
    };
    try {
      await PostApiServer().chefRatingApi(body).then((value) {
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: value['msg']);
        if (value['success'] == 'true') {
          PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
        }
      });
    } catch (e) {
      Utils().stopSpinner(context);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
