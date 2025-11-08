import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/chef_follower_profile_popup.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Followers/chef_follower_model.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/chef_provider.dart';

import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class ChefFollowersList extends StatefulWidget {
  const ChefFollowersList({super.key});

  @override
  State<ChefFollowersList> createState() => _ChefFollowersListState();
}

class _ChefFollowersListState extends State<ChefFollowersList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChefProvider>().loadFollowers();
    });
  }

  void _refresh(BuildContext context) {
    context.read<ChefProvider>().loadFollowers(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: 'Followers'),
      ),
      body: Consumer<ChefProvider>(
        builder: (context, chefProvider, child) {
          if (chefProvider.isFollowersLoading &&
              chefProvider.followers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          if (chefProvider.followersError.isNotEmpty &&
              chefProvider.followers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chefProvider.followersError,
                    style: white15bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _refresh(context),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final List<ChefFollowersDetail> followers =
              chefProvider.followers;

          if (followers.isEmpty) {
            return const Center(child: Text('No Followers available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final data = followers[index];
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: Platform.isAndroid ? false : true,
                      builder: (context) =>
                          ChefFollowerProfilePopup(data: data.toJson()),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    color: DynamicColor.boxColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                color: DynamicColor.black.withOpacity(0.3),
                                child: CustomNetworkImage(
                                  url: data.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.firstName} ${data.lastName}',
                                style: white17Bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data.address,
                                style: white14w5,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
