import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Grocer/Grocer%20Profile/grocer_profile.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/data_provider.dart';

class AllGrocerList extends StatefulWidget {
  const AllGrocerList({super.key});

  @override
  State<AllGrocerList> createState() => _AllGrocerListState();
}

class _AllGrocerListState extends State<AllGrocerList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final dataProvider = context.read<DataProvider>();
      if (!dataProvider.isLoading && dataProvider.grocersList.isEmpty) {
        dataProvider.fetchHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        if (dataProvider.isLoading && dataProvider.grocersList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: DynamicColor.primaryColor,
            ),
          );
        }

        if (dataProvider.error.isNotEmpty &&
            dataProvider.grocersList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load grocers',
                  style: white15bold,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => dataProvider.fetchHomeData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (dataProvider.grocersList.isEmpty) {
          return const Center(child: Text('No Grocers available'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: homeSearchTextController,
            builder: (context, o, w) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: dataProvider.grocersList.length,
                itemBuilder: (context, index) {
                  final dynamic data = dataProvider.grocersList[index];

                  if (!listFlitter(data)) {
                    return const SizedBox.shrink();
                  }

                  return InkWell(
                    onTap: () {
                      PageNavigateScreen().push(
                        context,
                        GrocerProfilePage(
                          userId: data['user_id'],
                          userType: data['user_type'],
                          currentUser: 'buyer',
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      color: DynamicColor.boxColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: SizeConfig.getSizeHeightBy(
                                      context: context,
                                      by: 0.1,
                                    ),
                                    color: DynamicColor.black.withOpacity(0.3),
                                    child: CustomNetworkImage(
                                      url: data['chef_image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  data['online_offline_flag'] == 'online'
                                      ? 'assets/images/green_flame.png'
                                      : 'assets/images/gray_flame.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              minLeadingWidth: 0.0,
                              horizontalTitleGap: 10,
                              contentPadding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 8,
                              ),
                              minVerticalPadding: 0.0,
                              title: Text(
                                data['full_name'],
                                style: white17Bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rating: ',
                                        style: lightWhite14Bold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        data['avg_rating'].toString(),
                                        style: primary15w5,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.star,
                                        color: DynamicColor.primaryColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Text(
                                        'Miles: ',
                                        style: lightWhite14Bold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${data['distance']}',
                                        style: green14w5,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 28,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  bool listFlitter(dynamic data) {
    if ((data['full_name']
                .toString()
                .toLowerCase()
                .contains(homeSearchTextController.text.toLowerCase()) ||
            data['full_name']
                .toString()
                .toUpperCase()
                .contains(homeSearchTextController.text.toUpperCase())) ||
        (data['user_name']
                .toString()
                .toUpperCase()
                .contains(homeSearchTextController.text.toUpperCase()) ||
            data['user_name']
                .toString()
                .toLowerCase()
                .contains(homeSearchTextController.text.toLowerCase())) ||
        (data['all_dish_grocer'] != 'NA' &&
                data['all_dish_grocer'][0]['dish_name']
                    .toString()
                    .toUpperCase()
                    .contains(homeSearchTextController.text.toUpperCase()) ||
            data['all_dish_grocer'] != 'NA' &&
                data['all_dish_grocer'][0]['dish_name']
                    .toString()
                    .toLowerCase()
                    .contains(homeSearchTextController.text.toLowerCase()))) {
      return true;
    }
    return false;
  }
}
