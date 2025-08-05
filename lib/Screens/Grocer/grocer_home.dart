import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_dish_popup.dart';
import 'package:munchups_app/Comman%20widgets/exit_page.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/notify_count.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Grocer/Grocer%20Profile/grocer_item_detail.dart';
import 'package:munchups_app/Screens/Grocer/Post%20item/edit_dish.dart';
import 'package:munchups_app/Screens/Notification/notification.dart';
import 'package:munchups_app/Screens/drawer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrocerHomePage extends StatefulWidget {
  const GrocerHomePage({super.key});

  @override
  State<GrocerHomePage> createState() => _GrocerHomePageState();
}

class _GrocerHomePageState extends State<GrocerHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  TextEditingController textEditingController = TextEditingController();
  final NotificationController notificationController =
      NotificationController();

  bool isLoading = false;

  List dishList = [];
  List searchList = [];

  dynamic userData;
  dynamic grocerData;

  String getUserType = 'grocer';

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("user_type") != null) {
        getUserType = prefs.getString("user_type").toString();
      }
      userData = jsonDecode(prefs.getString('data').toString());
    });
    getPostedDish();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    notificationController.startTimer(context);
  }

  @override
  void dispose() {
    super.dispose();
    notificationController.closeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        key: globalKey,
        drawerEnableOpenDragGesture: false,
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: const DrawerPage()),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: InkWell(
                onTap: () {
                  globalKey.currentState!.openDrawer();
                },
                child: const Icon(Icons.menu,
                    color: DynamicColor.white, size: 35)),
            title: Text(TextStrings.textKey['home']!, style: primary25bold),
            centerTitle: true,
            actions: [
              ValueListenableBuilder(
                  valueListenable: notificationController.totalCount,
                  builder: (context, count, child) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 5, right: 10),
                          child: InkWell(
                              onTap: () {
                                PageNavigateScreen()
                                    .push(context, const NotificationList());
                              },
                              child: const Icon(
                                Icons.notifications,
                                color: DynamicColor.white,
                                size: 35,
                              )),
                        ),
                        count == 0
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  PageNavigateScreen()
                                      .push(context, const NotificationList());
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Text(count.toString(),
                                        style: white14w5),
                                  ),
                                ))
                      ],
                    );
                  })
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: serchBox(),
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(color: DynamicColor.primaryColor))
            : dishList.isEmpty
                ? const Center(child: Text('No dish available'))
                : grocerItemList(),
      ),
    );
  }

  Widget serchBox() {
    return InputFieldsWithLightWhiteColor(
        controller: textEditingController,
        labelText: TextStrings.textKey['serch'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
        onChanged: (value) {
          final String queryString = textEditingController.text;
          setState(() {
            if (queryString.isNotEmpty) {
              searchList.clear();
              for (final item in dishList) {
                if (item['dish_name']
                        .toString()
                        .toLowerCase()
                        .contains(queryString) ||
                    item['dish_name']
                        .toString()
                        .toUpperCase()
                        .contains(queryString)) {
                  searchList.add(item);
                } else {
                  searchList.remove(item);
                }
              }
            } else {
              searchList.clear();
            }
          });
        });
  }

  Widget grocerItemList() {
    return Padding(
        padding: EdgeInsets.only(top: SizeConfig.getSize20(context: context)),
        child: GridView.builder(
            shrinkWrap: true,
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height * 0.70)),
            itemCount: textEditingController.text.isEmpty
                ? dishList.length
                : searchList.length,
            itemBuilder: (context, index) {
              dynamic dishData = textEditingController.text.isEmpty
                  ? dishList[index]
                  : searchList[index];
              if (listFlitter(dishData)) {
                return InkWell(
                  onTap: () {
                    PageNavigateScreen().push(
                        context,
                        GrocerItemDetailPage(
                          userdata: grocerData,
                          dishData: dishData,
                        ));
                  },
                  child: Card(
                    color: DynamicColor.boxColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 25,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: DynamicColor.green.withOpacity(0.3)),
                            child: Text("Special Offer's", style: green13bold)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: SizeConfig.getSizeHeightBy(
                                  context: context, by: 0.154),
                              width: SizeConfig.getSizeWidthBy(
                                  context: context, by: 0.37),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomNetworkImage(
                                    url: dishData['dish_images'] == 'NA'
                                        ? ''
                                        : dishData['dish_images'][0]
                                            ['kitchen_image']),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dishData['dish_name'],
                                  style: white14w5,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text('$currencySymbol${dishData['dish_price']}',
                                  style: greenColor15bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Share.share('https://play.google.com/store');
                                },
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: DynamicColor.primaryColor,
                                  child: Icon(Icons.share,
                                      size: 20, color: DynamicColor.white),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  PageNavigateScreen().push(
                                      context,
                                      EditGrocerPostItemFormPage(
                                          dishData: dishData));
                                },
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: DynamicColor.secondryColor,
                                  child: Icon(Icons.edit,
                                      size: 20, color: DynamicColor.white),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible:
                                          Platform.isAndroid ? false : true,
                                      builder: (context) => DeleteDishPopUp(
                                            dishID: dishData['dish_id'],
                                            userType: 'grocer',
                                          )).then((value) {});
                                },
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.delete,
                                      size: 20, color: DynamicColor.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }));
  }

  void getPostedDish() async {
    setState(() {
      isLoading = true;
    });
    try {
      await GetApiServer()
          .getOtherUserProfileApi(userData['user_id'], getUserType)
          .then((value) {
        if (value['success'] == 'true') {
          setState(() {
            isLoading = false;
            grocerData = value['profile_data'];
            if (value['profile_data']['all_post'] != 'NA') {
              dishList = value['profile_data']['all_post'];
            }
          });
        }
      });
    } catch (e) {
      setState(() {
        dishList = [];
        isLoading = false;
      });
      log(e.toString());
    }
  }

  bool listFlitter(dynamic data) {
    if (data['dish_name']
        .toString()
        .toLowerCase()
        .contains(textEditingController.text.toLowerCase())) {
      return true;
    }
    return false;
  }
}
