import 'package:flutter/material.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';

import '../../Component/color_class/color_class.dart';

class WithoutBackIconCustomAppBar extends StatefulWidget {
  String title;

  WithoutBackIconCustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _WithoutBackIconCustomAppBarState createState() =>
      _WithoutBackIconCustomAppBarState();
}

class _WithoutBackIconCustomAppBarState
    extends State<WithoutBackIconCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: DynamicColor.primaryColor,
      title:
          widget.title.isNotEmpty ? Text(widget.title, style: white21w5) : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: InkWell(
            onTap: () {
              PageNavigateScreen()
                  .pushRemovUntil(context, const BuyerHomePage());
            },
            child: const Icon(
              Icons.home,
              color: DynamicColor.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
