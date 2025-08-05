import 'package:flutter/material.dart';

import '../../Component/color_class/color_class.dart';

class HomeCustomAppBar extends StatefulWidget {
  dynamic backicon;
  String? back;
  GlobalKey<ScaffoldState> globalKey;
  HomeCustomAppBar({
    Key? key,
    this.backicon,
    this.back,
    required this.globalKey,
  }) : super(key: key);

  @override
  _HomeCustomAppBarState createState() => _HomeCustomAppBarState();
}

class _HomeCustomAppBarState extends State<HomeCustomAppBar> {
  String title = '';
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DynamicColor.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: widget.backicon != null
          ? widget.back == 'login'
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (widget.back == 'back') {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: DynamicColor.primaryColor,
                  ))
          : IconButton(
              onPressed: () {
                widget.globalKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: DynamicColor.primaryColor,
              )),
      title: Image.asset(
        'assets/images/logo.png',
        height: 45,
      ),
      // Column(
      //   children: [
      //     Text(
      //       TextStrings.textKey['appName']!,
      //       style: black30,
      //     ),
      //     Text(
      //       TextStrings.textKey['title']!,
      //       style: lightBleck13TextStyle,
      //       maxLines: 1,
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //   ],
      // ),
      actions: [
        widget.backicon != null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => const LogOutUserPopUp());
                  },
                  child: const CircleAvatar(
                      backgroundColor: DynamicColor.primaryColor,
                      radius: 20,
                      child: Icon(
                        Icons.logout,
                        color: DynamicColor.white,
                        size: 30,
                      )),
                ),
              ),
      ],
    );
  }
}
