import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/chef_follower_profile_popup.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Followers/chef_follower_model.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class ChefFollowersList extends StatefulWidget {
  const ChefFollowersList({super.key});

  @override
  State<ChefFollowersList> createState() => _ChefFollowersListState();
}

class _ChefFollowersListState extends State<ChefFollowersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Followers')),
      body: FutureBuilder<ChefFollowingsListModel>(
          future: GetApiServer().chefFollowersListApi(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('No Followers available'));
                } else if (snapshot.data!.success != 'true') {
                  return const Center(child: Text('No Followers available'));
                } else if (snapshot.data!.followersDetails == 'NA') {
                  return const Center(child: Text('No Chefs available'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.followersDetails.length,
                        itemBuilder: (context, index) {
                          ChefFollowersDetail data =
                              snapshot.data!.followersDetails[index];
                          return InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible:
                                      Platform.isAndroid ? false : true,
                                  builder: (context) =>
                                      ChefFollowerProfilePopup(
                                          data: data.toJson()));
                              // PageNavigateScreen().push(
                              //     context, ChefFollowerProfilePage(data: data));
                            },
                            child: Card(
                              elevation: 10,
                              color: DynamicColor.boxColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        height: 45,
                                        width: 45,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              color: DynamicColor.black
                                                  .withOpacity(0.3),
                                              child: CustomNetworkImage(
                                                url: data.image,
                                                fit: BoxFit.contain,
                                              ),
                                            ))),
                                    const SizedBox(width: 5),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data.firstName} ${data.lastName}',
                                          style: white17Bold,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        // Row(
                                        //   children: [
                                        //     const Icon(Icons.location_on,
                                        //         color: DynamicColor.primaryColor,
                                        //         size: 18),
                                        //     const SizedBox(width: 2),
                                        //     Text(
                                        //       'Dewas,Madhy Pradesh',
                                        //       style: white14w5,
                                        //       maxLines: 1,
                                        //       overflow: TextOverflow.ellipsis,
                                        //     ),
                                        //   ],
                                        // ),
                                        // const SizedBox(height: 5),
                                        // Row(
                                        //   children: [
                                        //     const Icon(Icons.call,
                                        //         color: DynamicColor.green,
                                        //         size: 18),
                                        //     const SizedBox(width: 2),
                                        //     Text(
                                        //       '1234567891',
                                        //       style: white14w5,
                                        //       maxLines: 1,
                                        //       overflow: TextOverflow.ellipsis,
                                        //     ),
                                        //   ],
                                        // )
                                      ],
                                    )
                                  ],
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
