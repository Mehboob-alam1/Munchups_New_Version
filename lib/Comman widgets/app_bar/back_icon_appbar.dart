import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Component/color_class/color_class.dart';
import '../../Component/styles/styles.dart';

class BackIconCustomAppBar extends StatefulWidget {
  String title;
  dynamic isDeleteNotification;
  dynamic userID;
  Function()? onTap;
  BackIconCustomAppBar({
    Key? key,
    required this.title,
    this.isDeleteNotification,
    this.userID,
    this.onTap,
  }) : super(key: key);

  @override
  _BackIconCustomAppBarState createState() => _BackIconCustomAppBarState();
}

class _BackIconCustomAppBarState extends State<BackIconCustomAppBar> {
  String getUserType = 'buyer';

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("user_type") != null) {
        getUserType = prefs.getString("user_type").toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUsertype();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: DynamicColor.primaryColor,
      leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: DynamicColor.white,
              ))),
      title:
          widget.title.isNotEmpty ? Text(widget.title, style: white21w5) : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: InkWell(
            onTap: () {
              // if (getUserType == 'buyer') {
              //   Timer(const Duration(milliseconds: 600), () {
              //     PageNavigateScreen()
              //         .pushReplesh(context, const BuyerHomePage());
              //   });
              // } else if (getUserType == 'chef') {
              //   Timer(const Duration(milliseconds: 600), () {
              //     PageNavigateScreen()
              //         .pushReplesh(context, const ChefHomePage());
              //   });
              // } else {
              //   Timer(const Duration(milliseconds: 600), () {
              //     PageNavigateScreen()
              //         .pushReplesh(context, const GrocerHomePage());
              //   });
              // }

              if (getUserType == 'buyer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BuyerHomePage()),
                );
              }

              if (getUserType == 'buyer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BuyerHomePage()),
                );
                // PageNavigateScreen().pushReplesh(context, const BuyerHomePage());
              } else if (getUserType == 'chef') {
                PageNavigateScreen().pushReplesh(context, const ChefHomePage());
              } else {
                PageNavigateScreen().pushReplesh(context, const GrocerHomePage());
              }


            },
            child: const Icon(
              Icons.home,
              color: DynamicColor.white,
              size: 30,
            ),
          ),
        ),
        if (widget.isDeleteNotification == true)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: widget.onTap,
              child: const Icon(
                Icons.delete,
                color: DynamicColor.white,
                size: 30,
              ),
            ),
          ),
      ],
    );
  }
}
