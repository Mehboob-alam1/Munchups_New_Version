import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_dish_popup.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Chef/Posted%20Dish/edit_dish_form.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Component/Strings/strings.dart';

class ChefPostedDishListPage extends StatefulWidget {
  const ChefPostedDishListPage({super.key});

  @override
  State<ChefPostedDishListPage> createState() => _ChefPostedDishListPageState();
}

class _ChefPostedDishListPageState extends State<ChefPostedDishListPage> {
  bool isLoading = false;
  List dishList = [];
  dynamic userData;

  String getUserType = 'buyer';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['psted_dish']!)),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: DynamicColor.primaryColor))
          : dishList.isEmpty
              ? const Center(child: Text('No dish available'))
              : Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getSize20(context: context)),
                  child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height * 0.75)),
                      itemCount: dishList.length,
                      itemBuilder: (context, index) {
                        dynamic data = dishList[index];
                        return Card(
                          color: DynamicColor.boxColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                        url: data['dish_images'] == 'NA'
                                            ? ''
                                            : data['dish_images'][0]
                                                ['kitchen_image'],
                                      ),
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
                                    Text(data['dish_name'],
                                        style: white14w5,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text('$currencySymbol${data['dish_price']}',
                                        style: greenColor15bold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 10),
                                    Center(
                                        child: Text('Dish Serving time',
                                            style: white15bold)),
                                    Center(
                                      child: Text(
                                          '${data['start_time']} - ${data['end_time']}',
                                          style: primary15w5),
                                    ),
                                  ],
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Share.share(
                                            'https://play.google.com/store');
                                      },
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            DynamicColor.primaryColor,
                                        child: Icon(Icons.share,
                                            size: 20,
                                            color: DynamicColor.white),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        PageNavigateScreen().push(
                                            context,
                                            EditChefPostDishForm(
                                                dishData: data));
                                      },
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            DynamicColor.secondryColor,
                                        child: Icon(Icons.edit,
                                            size: 20,
                                            color: DynamicColor.white),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible:
                                                Platform.isAndroid
                                                    ? false
                                                    : true,
                                            builder: (context) =>
                                                DeleteDishPopUp(
                                                  dishID: data['dish_id'],
                                                  userType: 'chef',
                                                )).then((value) {});
                                      },
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.delete,
                                            size: 20,
                                            color: DynamicColor.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })),
    );
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
}
