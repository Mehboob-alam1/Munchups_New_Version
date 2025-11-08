import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:munchups_app/Screens/Grocer/Grocer Profile/grocer_item_detail.dart';
import 'package:munchups_app/Screens/Grocer/Post item/edit_dish.dart';
import 'package:munchups_app/Screens/Notification/notification.dart';
import 'package:munchups_app/Screens/drawer.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:munchups_app/presentation/providers/data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrocerHomePage extends StatefulWidget {
  const GrocerHomePage({super.key});

  @override
  State<GrocerHomePage> createState() => _GrocerHomePageState();
}

class _GrocerHomePageState extends State<GrocerHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  final TextEditingController textEditingController = TextEditingController();
  final NotificationController notificationController =
      NotificationController();

  String getUserType = 'grocer';

  Map<String, dynamic> _mapFromAny(Map source) {
    return source.map((key, value) => MapEntry(key.toString(), value));
  }

  Map<String, dynamic> _extractProfileData(Map<String, dynamic> source) {
    if (source['profile_data'] is Map) {
      return _mapFromAny(source['profile_data'] as Map);
    }
    if (source['data'] is Map) {
      return _mapFromAny(source['data'] as Map);
    }
    return _mapFromAny(source);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataProvider = context.read<DataProvider>();
      await dataProvider.fetchUserProfile(forceRefresh: true);
      notificationController.startTimer(context);
      _loadUserType();
    });
  }

  Future<void> _loadUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        if (prefs.getString('user_type') != null) {
          getUserType = prefs.getString('user_type')!.toString();
        }
      });
    } catch (e) {
      print('GrocerHome: Error loading user type: $e');
    }
  }

  @override
  void dispose() {
    notificationController.closeTimer(context);
    textEditingController.dispose();
    super.dispose();
  }

  List<dynamic> _filteredDishes(List<dynamic> dishes) {
    final query = textEditingController.text.trim();
    if (query.isEmpty) return dishes;
    final lower = query.toLowerCase();
    return dishes
        .where((item) => item['dish_name']
            .toString()
            .toLowerCase()
            .contains(lower))
        .toList();
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
        body: Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            final profile = _extractProfileData(dataProvider.userProfile);
            final isLoading = dataProvider.isLoading && profile.isEmpty;
            final hasError = dataProvider.error.isNotEmpty;

            if (isLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(color: DynamicColor.primaryColor),
              );
            }

            if (hasError && profile.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dataProvider.error,
                      style: white15bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          dataProvider.fetchUserProfile(forceRefresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final grocerData = profile;
            final List<dynamic> dishList =
                profile['all_post'] == 'NA'
                    ? []
                    : List<dynamic>.from(profile['all_post'] ?? []);

            final displayList = _filteredDishes(dishList);

            if (dishList.isEmpty) {
              return const Center(child: Text('No dish available'));
            }

            return grocerItemList(grocerData, dishList, displayList);
          },
        ),
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
          setState(() {});
        });
  }

  Widget grocerItemList(
    Map<String, dynamic> grocerData,
    List<dynamic> dishList,
    List<dynamic> filtered,
  ) {
    final listToUse = textEditingController.text.isEmpty ? dishList : filtered;

    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.getSize20(context: context)),
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height * 0.70),
        ),
        itemCount: listToUse.length,
        itemBuilder: (context, index) {
          final dishData = listToUse[index];
          if (!listFlitter(dishData)) {
            return Container();
          }

          return InkWell(
            onTap: () {
              PageNavigateScreen().push(
                context,
                GrocerItemDetailPage(
                  userdata: grocerData,
                  dishData: dishData,
                ),
              );
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
                      color: DynamicColor.green.withOpacity(0.3),
                    ),
                    child: Text("Special Offer's", style: green13bold),
                  ),
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
                                : dishData['dish_images'][0]['kitchen_image'],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dishData['dish_name'],
                            style: white14w5,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$currencySymbol${dishData['dish_price']}',
                            style: greenColor15bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                              EditGrocerPostItemFormPage(dishData: dishData),
                            );
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
                                userType: getUserType,
                              ),
                            ).then((value) {});
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
