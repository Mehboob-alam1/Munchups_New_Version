import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/logout_user_popup.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:munchups_app/Screens/Buyer/Card%20Payment/card_payment_form.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/demand_food_list.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/on_demand_food_form.dart';
import 'package:munchups_app/Screens/Buyer/Following%20List/following_list.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/order_tabs.dart';
import 'package:munchups_app/Screens/Buyer/Profile/profile.dart';
import 'package:munchups_app/Screens/Buyer/Search%20All%20User/search_all_user.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Followers/chef_followers_list.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Orders/Bulk%20order/bulk_order_tabs.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Orders/chef_myorder_list.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Profile/chef_profile.dart';
import 'package:munchups_app/Screens/Chef/Posted%20Dish/post_dish_form.dart';
import 'package:munchups_app/Screens/Chef/Posted%20Dish/posted_dish_list.dart';
import 'package:munchups_app/Screens/Chef/manage_account.dart';
import 'package:munchups_app/Screens/Grocer/Grocer%20Profile/grocer_profile.dart';
import 'package:munchups_app/Screens/Grocer/Post%20item/post_item.dart';
import 'package:munchups_app/Screens/Notification/notification.dart';
import 'package:munchups_app/Screens/Setting/invite_user.dart';
import 'package:munchups_app/Screens/Setting/setting.dart';
import 'package:munchups_app/Screens/Support/support.dart';
import 'package:munchups_app/Screens/search_location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String getUserType = 'null';
  int myFollower = 0;
  dynamic userData;

  bool isLoading = false;

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("user_type") != null) {
        getUserType = prefs.getString("user_type").toString();
      }
      // userData = jsonDecode(prefs.getString('data').toString());
      myFollower = prefs.getInt('following_count')!;
    });
  }

  saveUserData(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('data', value);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
    getUsertype();
  }

  void getUserProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      await GetApiServer().getProfileApi(context).then((value) {
        if (value['success'] == 'true') {
          setState(() {
            isLoading = false;
          });
          Map<String, dynamic> profileData = value['profile_data'];
          if (profileData.containsKey('email_id')) {
            profileData['email'] = profileData['email_id'];
            profileData.remove('email_id');
          }

          setState(() {
            userData = profileData;
            saveUserData(jsonEncode(profileData));
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DynamicColor.themeColor,
      child:
          // isLoading
          //     ? const Center(
          //         child:
          //             CircularProgressIndicator(color: DynamicColor.primaryColor))
          //     :
          ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: DynamicColor.primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  minLeadingWidth: 0.0,
                  horizontalTitleGap: 10,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0.0,
                  onTap: () {
                    PageNavigateScreen().back(context);
                    if (getUserType == 'buyer') {
                      PageNavigateScreen()
                          .push(context, const BuyerProfilePage());
                    } else if (getUserType == 'chef') {
                      PageNavigateScreen().push(
                          context,
                          ChefProfilePage(
                            userId: userData['user_id'],
                            userType: getUserType,
                            currentUser: getUserType,
                          ));
                    } else {
                      PageNavigateScreen().push(
                          context,
                          GrocerProfilePage(
                            userId: userData['user_id'],
                            userType: getUserType,
                            currentUser: getUserType,
                          ));
                    }
                  },
                  leading: userData != null
                      ? SizedBox(
                          height: 45,
                          width: 45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CustomNetworkImage(
                              url: userData['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              DynamicColor.lightGrey.withOpacity(0.7),
                          backgroundImage:
                              const AssetImage('assets/images/user_icon.jpg'),
                        ),
                  title: Text(
                    userData != null ? userData['user_name'] : 'Not Found',
                    style: white15bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: userData != null
                      ? getUserType.contains('buyer')
                          ? Text('Following: $myFollower', style: secondry14w5)
                          : Text('Followers: $myFollower', style: secondry14w5)
                      : null,
                ),
                const SizedBox(height: 10),
                CommanButton(
                    heroTag: 1,
                    shap: 10.0,
                    hight: 35.0,
                    width: MediaQuery.of(context).size.width * 0.3,
                    buttonBGColor: DynamicColor.themeColor,
                    textSize: 13.0,
                    buttonName: getUserType.contains('buyer')
                        ? TextStrings.textKey['following']!
                        : 'Followers',
                    onPressed: () {
                      PageNavigateScreen().back(context);
                      if (getUserType == 'buyer') {
                        PageNavigateScreen()
                            .push(context, const FollowingList());
                      } else {
                        PageNavigateScreen()
                            .push(context, const ChefFollowersList());
                      }
                    }),
              ],
            ),
          ),
          Visibility(
              visible: getUserType == 'null',
              child: customWidget(
                  iconData: Icons.login,
                  title: 'Login',
                  onTap: () {
                    PageNavigateScreen().back(context);
                    PageNavigateScreen().push(context, const LoginPage());
                  })),
          customWidget(
              iconData:
                  getUserType == 'grocer' ? Icons.lunch_dining : Icons.home,
              title: getUserType == 'grocer' ? 'Posted Item' : 'Home',
              onTap: () {
                PageNavigateScreen().back(context);
              }),
          Visibility(
              visible: getUserType.contains('chef'),
              child: customWidget(
                  iconData: Icons.restaurant_menu,
                  title: TextStrings.textKey['psted_dish']!,
                  onTap: () {
                    PageNavigateScreen().back(context);
                    PageNavigateScreen().push(
                      context,
                      const ChefPostedDishListPage(),
                    );
                  })),
          customWidget(
              iconData: Icons.redeem,
              title: TextStrings.textKey['my_order']!,
              onTap: () {
                PageNavigateScreen().back(context);
                if (getUserType == 'buyer') {
                  PageNavigateScreen()
                      .push(context, OrderTabs(currentIndex: 0));
                } else if (getUserType == 'chef') {
                  PageNavigateScreen().push(context, const ChefOrderList());
                } else {
                  PageNavigateScreen().push(context, const ChefOrderList());
                }
              }),
          Visibility(
              visible: getUserType.contains('grocer'),
              child: customWidget(
                  iconData: Icons.lunch_dining,
                  title: TextStrings.textKey['post_item']!,
                  onTap: () {
                    PageNavigateScreen().back(context);
                    PageNavigateScreen().push(
                      context,
                      const GrocerPostItemFormPage(),
                    );
                  })),
          Visibility(
              visible: getUserType.contains('chef'),
              child: customWidget(
                  iconData: Icons.redeem,
                  title: TextStrings.textKey['my_bulk_order']!,
                  onTap: () {
                    PageNavigateScreen().back(context);
                    PageNavigateScreen().push(
                      context,
                      BulkOrderTabs(currentIndex: 0),
                    );
                  })),
          Visibility(
              visible: getUserType.contains('chef'),
              child: customWidget(
                  iconData: Icons.food_bank,
                  title: TextStrings.textKey['post_dish']!,
                  onTap: () {
                    PageNavigateScreen().back(context);
                    PageNavigateScreen().push(
                      context,
                      const ChefPostDishForm(),
                    );
                  })),
          Visibility(
              visible: getUserType.contains('buyer'),
              child: customWidget(
                  iconData: Icons.food_bank_outlined,
                  title: TextStrings.textKey['on_demand_food']!,
                  onTap: () {
                    addressController.text = '';
                    PageNavigateScreen().back(context);
                    PageNavigateScreen()
                        .push(context, const OnDemandFoodForm());
                  })),
          Visibility(
            visible: getUserType.contains('buyer'),
            child: customWidget(
                iconData: Icons.food_bank,
                title: TextStrings.textKey['posted_demand_food']!,
                onTap: () {
                  PageNavigateScreen().back(context);
                  PageNavigateScreen()
                      .push(context, const PostedDemandFoodPage());
                }),
          ),
          Visibility(
            visible: getUserType.contains('buyer'),
            child: customWidget(
                iconData: Icons.search,
                title: TextStrings.textKey['search']!,
                onTap: () {
                  PageNavigateScreen().back(context);
                  PageNavigateScreen()
                      .push(context, const SearchAllUsersList());
                }),
          ),
          Visibility(
            visible: getUserType == 'buyer' || getUserType == 'null',
            child: customWidget(
                iconData: Icons.location_on,
                title: 'Location',
                onTap: () {
                  PageNavigateScreen().back(context);
                  PageNavigateScreen()
                      .push(context, const SearchLocationPage());
                }),
          ),
          customWidget(
              iconData: Icons.notifications,
              title: TextStrings.textKey['notification']!,
              onTap: () {
                PageNavigateScreen().back(context);
                PageNavigateScreen().push(context, const NotificationList());
              }),
          customWidget(
              iconData: Icons.settings,
              title: TextStrings.textKey['setting']!,
              onTap: () {
                PageNavigateScreen().back(context);
                PageNavigateScreen().push(context, const SettingPage());
              }),
          customWidget(
              iconData: Icons.support_agent,
              title: TextStrings.textKey['support']!,
              onTap: () {
                PageNavigateScreen().back(context);
                PageNavigateScreen().push(context, const SupportPage());
              }),
          Visibility(
            visible: getUserType.contains('buyer'),
            child: customWidget(
                iconData: Icons.account_balance_wallet,
                title: 'Card Payment',
                onTap: () {
                  PageNavigateScreen().back(context);
                  PageNavigateScreen().push(
                      context,
                      CardPaymentFormPage(
                        type: 'add card',
                      ));
                }),
          ),
          Visibility(
            visible:
                getUserType.contains('chef') || getUserType.contains('grocer'),
            child: customWidget(
                iconData: Icons.account_balance_wallet,
                title: 'Manage Account',
                onTap: () {
                  PageNavigateScreen().back(context);
                  PageNavigateScreen()
                      .push(context, const ManageAccountPageForChefAndGrocer());
                }),
          ),
          Visibility(
            visible: getUserType != 'null',
            child: customWidget(
                iconData: Icons.logout,
                title: 'Logout',
                onTap: () {
                  showDialog(
                      barrierDismissible: Platform.isAndroid ? false : true,
                      context: context,
                      builder: (context) => const LogOutUserPopUp());
                }),
          ),
          customWidget(
              iconData: Icons.star,
              title: 'Rate Us',
              onTap: () {
                PageNavigateScreen().back(context);
                Utils.launchUrls('https://play.google.com/store', context);
              }),
          customWidget(
              iconData: Icons.share,
              title: 'Share App',
              onTap: () {
                PageNavigateScreen().back(context);
                Share.share('https://play.google.com/store');
              }),
          customWidget(
              iconData: Icons.group_add,
              title: TextStrings.textKey['invite_user']!,
              onTap: () {
                PageNavigateScreen().back(context);
                PageNavigateScreen().push(context, const InviteUser());
              }),
        ],
      ),
    );
  }

  Widget customWidget(
      {required IconData iconData,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 0.0,
      minVerticalPadding: 0.0,
      horizontalTitleGap: 10.0,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: DynamicColor.primaryColor,
        child: Icon(iconData, color: DynamicColor.white),
      ),
      title: Text(title, style: white17Bold),
    );
  }
}
