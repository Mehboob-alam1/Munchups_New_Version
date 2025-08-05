import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/follow_unfollow_popup.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Screens/Buyer/Following%20List/following_model.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Profile/chef_profile.dart';
import 'package:munchups_app/Screens/Grocer/Grocer%20Profile/grocer_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  int myFollower = 0;

  getFollowingCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myFollower = prefs.getInt('following_count')!;
    });
  }

  saveFollowingCount(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setInt("following_count", value);
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowingCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['following']!)),
      body: FutureBuilder<MyFollowingsListModel>(
          future: GetApiServer().myFollowersListApi(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('No Following available'));
                } else if (snapshot.data!.success != 'true') {
                  return const Center(child: Text('No Following available'));
                } else if (snapshot.data!.followreDetails == 'NA') {
                  return const Center(child: Text('No Following available'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.followreDetails.length,
                        itemBuilder: (context, index) {
                          MyFollowreDetail data =
                              snapshot.data!.followreDetails[index];
                          return Card(
                            elevation: 10,
                            color: DynamicColor.boxColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onTap: () {
                                if (data.userType == 'chef') {
                                  PageNavigateScreen().push(
                                      context,
                                      ChefProfilePage(
                                        userId: data.userId,
                                        userType: data.userType,
                                        currentUser: 'buyer',
                                      ));
                                } else {
                                  PageNavigateScreen().push(
                                      context,
                                      GrocerProfilePage(
                                        userId: data.userId,
                                        userType: data.userType,
                                        currentUser: 'buyer',
                                      ));
                                }
                              },
                              minLeadingWidth: 0.0,
                              horizontalTitleGap: 10,
                              contentPadding:
                                  const EdgeInsets.only(left: 5, right: 5),
                              minVerticalPadding: 0.0,
                              leading: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:
                                          CustomNetworkImage(url: data.image))),
                              title: Text(
                                '${data.firstName} ${data.lastName}',
                                style: white15bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Type: ${data.userType}',
                                style: secondry14bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible:
                                          Platform.isAndroid ? false : true,
                                      builder: (context) => FollowUnfollowPopUp(
                                            toUserID: data.userId.toString(),
                                            currentStatus: 'Unfollow',
                                          )).then((value) {
                                    setState(() {
                                      myFollower--;
                                      saveFollowingCount(myFollower);
                                    });
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: DynamicColor.primaryColor,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Text('Unfollow', style: white15bold),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
            }
          }),
    );
  }
}
