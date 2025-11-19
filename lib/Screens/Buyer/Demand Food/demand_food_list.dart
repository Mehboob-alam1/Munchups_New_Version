import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_item_popup.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/demanded_food_list_model.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/edit_demand_food_form.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/proposal_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostedDemandFoodPage extends StatefulWidget {
  const PostedDemandFoodPage({super.key});

  @override
  State<PostedDemandFoodPage> createState() => _PostedDemandFoodPageState();
}

class _PostedDemandFoodPageState extends State<PostedDemandFoodPage> {
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
          child: BackIconCustomAppBar(
              title: TextStrings.textKey['posted_demand_food']!)),
      body: FutureBuilder<PostedDemandFoodListModel>(
          future: GetApiServer().postedDemandFoodListApi(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('No Posted Food available'));
                } else if (snapshot.data!.success != 'true') {
                  return const Center(child: Text('No Posted Food available'));
                } else if (snapshot.data!.ocCategoryOrderArr == 'NA') {
                  return const Center(child: Text('No Posted Food available'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: snapshot.data!.ocCategoryOrderArr.length,
                    itemBuilder: (context, index) {
                      PostedOcCategoryOrderArr data =
                          snapshot.data!.ocCategoryOrderArr[index];
                      return InkWell(
                        onTap: () {
                          PageNavigateScreen().push(
                              context,
                              ProposalFoodListPage(
                                  buyerID: userData['user_id'].toString(),
                                  foodID: data.foodId.toString()));
                        },
                        child: Card(
                          elevation: 10,
                          color: DynamicColor.boxColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 70, top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/on-demand-food.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              data.occasionCategoryName,
                                              style: white17Bold,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
                                          const SizedBox(height: 3),
                                          Text(
                                              '$currencySymbol${data.budget}',
                                              style: green14w5,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
                                          const SizedBox(height: 3),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    '${TextStrings.textKey['no_of_people']!}: ',
                                                    style: lightWhite14Bold,
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                              Flexible(
                                                child: Text(
                                                    data.noOfPeople
                                                        .toString(),
                                                    style: primary15w5,
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 5,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            PageNavigateScreen().push(
                                                context,
                                                EdtiDemandFoodForm(
                                                    foodID: data.foodId
                                                        .toString()));
                                          },
                                          child: const Icon(
                                            Icons.draw,
                                            size: 22,
                                            color: DynamicColor.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible:
                                                    Platform.isAndroid
                                                        ? false
                                                        : true,
                                                builder: (context) =>
                                                    DeleteItemPopUp(
                                                      id: data.foodId
                                                          .toString(),
                                                    )).then((value) {
                                              setState(() {});
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            size: 22,
                                            color:
                                                DynamicColor.redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor:
                                          DynamicColor.secondryColor,
                                      child: Text(
                                        data.totalProposal == 'NA'
                                            ? '0'
                                            : data.totalProposal
                                                .toString(),
                                        style: white14w5,
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
                  );
                }
            }
          }),
    );
  }
}
