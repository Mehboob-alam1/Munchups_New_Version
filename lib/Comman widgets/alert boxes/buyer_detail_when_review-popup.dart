import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';

class BuyerDetailWhenReviewPopup extends StatefulWidget {
  dynamic userId;
  BuyerDetailWhenReviewPopup({super.key, required this.userId});

  @override
  State<BuyerDetailWhenReviewPopup> createState() =>
      _BuyerDetailWhenReviewPopupState();
}

class _BuyerDetailWhenReviewPopupState
    extends State<BuyerDetailWhenReviewPopup> {
  bool isLoading = false;
  dynamic userData;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Center(
              child: Text('User Detail', style: primary17w6),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        color: DynamicColor.black.withOpacity(0.3),
                        child: CustomNetworkImage(
                          url: userData['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(userData['first_name'] + ' ' + userData['last_name'],
                      style: white17Bold),
                  const SizedBox(height: 5),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0.0,
                    horizontalTitleGap: 8.0,
                    minVerticalPadding: 0.0,
                    leading: const Icon(
                      Icons.person,
                      color: DynamicColor.lightGrey,
                      size: 22,
                    ),
                    title: Text(
                      userData['address'],
                      style: primary13bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 5),
                  //   child: Row(
                  //     children: [
                  //       const Icon(
                  //         Icons.call,
                  //         color: DynamicColor.lightGrey,
                  //         size: 22,
                  //       ),
                  //       const SizedBox(width: 5),
                  //       Text(formatMobileNumber(userData['phone']), style: green13bold),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            actions: [
              CommanButton(
                  hight: 40.0,
                  width: 100.0,
                  buttonName: 'Ok',
                  buttonBGColor: DynamicColor.primaryColor,
                  onPressed: () {
                    PageNavigateScreen().back(context);
                  },
                  shap: 100),
            ],
          );
  }

  void getUserProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      await GetApiServer()
          .getOtherUserProfileApi(widget.userId, 'buyer')
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value['success'] == 'true') {
          setState(() {
            userData = value;
          });
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log(e.toString());
    }
  }
}
