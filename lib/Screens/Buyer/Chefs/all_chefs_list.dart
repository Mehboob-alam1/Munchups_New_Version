// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Screens/Chef/Chef%20Profile/chef_profile.dart';
//
// class AllChefsList extends StatefulWidget {
//   const AllChefsList({super.key});
//
//   @override
//   State<AllChefsList> createState() => _AllChefsListState();
// }
//
// class _AllChefsListState extends State<AllChefsList> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: GetApiServer().buyerHomeDemoApi(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return const Center(
//                   child: CircularProgressIndicator(
//                 color: DynamicColor.primaryColor,
//               ));
//             default:
//               if (snapshot.hasError) {
//                 return const Center(child: Text('No Chefs available'));
//               } else if (snapshot.data!['success'] != 'true') {
//                 return const Center(child: Text('No Chefs available'));
//               } else if (snapshot.data!['all_chef'] == 'NA') {
//                 return const Center(child: Text('No Chefs available'));
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ValueListenableBuilder(
//                       valueListenable: homeSearchTextController,
//                       builder: (context, o, w) {
//                         return ListView.builder(
//                             shrinkWrap: true,
//                             primary: false,
//                             //  reverse: true,
//                             itemCount: snapshot.data!['all_chef'].length,
//                             itemBuilder: (context, index) {
//                               dynamic data = snapshot.data!['all_chef'][index];
//                               if (listFlitter(data)) {
//                                 return InkWell(
//                                   onTap: () {
//                                     PageNavigateScreen().push(
//                                         context,
//                                         ChefProfilePage(
//                                           userId: data['user_id'],
//                                           userType: data['user_type'],
//                                           currentUser: 'buyer',
//                                         ));
//                                   },
//                                   child: Card(
//                                     elevation: 10,
//                                     color: DynamicColor.boxColor,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                             child: Stack(
//                                           alignment: Alignment.bottomRight,
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               child: Container(
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   height: SizeConfig
//                                                       .getSizeHeightBy(
//                                                           context: context,
//                                                           by: 0.1),
//                                                   color: DynamicColor.black
//                                                       .withOpacity(0.3),
//                                                   child: CustomNetworkImage(
//                                                     url: data['chef_image'],
//                                                     fit: BoxFit.contain,
//                                                   )),
//                                             ),
//                                             data['online_offline_flag'] ==
//                                                     'online'
//                                                 ? Image.asset(
//                                                     'assets/images/green_flame.png',
//                                                     height: 20,
//                                                     width: 20,
//                                                   )
//                                                 : Image.asset(
//                                                     'assets/images/gray_flame.png',
//                                                     height: 20,
//                                                     width: 20,
//                                                   )
//                                             // CircleAvatar(
//                                             //     radius: 8,
//                                             //     backgroundColor:
//                                             //         data['online_offline_flag'] ==
//                                             //                 'online'
//                                             //             ? DynamicColor.green
//                                             //             : DynamicColor
//                                             //                 .redColor),
//                                           ],
//                                         )),
//                                         Expanded(
//                                             flex: 3,
//                                             child: ListTile(
//                                                 minLeadingWidth: 0.0,
//                                                 horizontalTitleGap: 10,
//                                                 contentPadding:
//                                                     const EdgeInsets.only(
//                                                         left: 5,
//                                                         right: 5,
//                                                         top: 8),
//                                                 minVerticalPadding: 0.0,
//                                                 title: Text(data['full_name'],
//                                                     style: white17Bold,
//                                                     maxLines: 1,
//                                                     overflow:
//                                                         TextOverflow.ellipsis),
//                                                 subtitle: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const SizedBox(height: 3),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text('Rating: ',
//                                                             style:
//                                                                 lightWhite14Bold,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                         Text(
//                                                             data['avg_rating']
//                                                                 .toString(),
//                                                             style: primary15w5,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                         const SizedBox(
//                                                             width: 5),
//                                                         const Icon(Icons.star,
//                                                             color: DynamicColor
//                                                                 .primaryColor,
//                                                             size: 20)
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 3),
//                                                     Row(
//                                                       children: [
//                                                         Text('Miles: ',
//                                                             style:
//                                                                 lightWhite14Bold,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                         Text(
//                                                             '${data['distance_float']}',
//                                                             style: green14w5,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 trailing: const Icon(
//                                                   Icons.arrow_forward_ios,
//                                                   size: 28,
//                                                 )))
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return Container();
//                               }
//                             });
//                       }),
//                 );
//               }
//           }
//         });
//   }
//
//   bool listFlitter(dynamic data) {
//     // Normalize the search text for case-insensitive comparison
//     String normalizedSearchText = homeSearchTextController.text.toLowerCase();
//
//     // Check if full_name matches the search text
//     if (data['full_name']
//         .toString()
//         .toLowerCase()
//         .contains(normalizedSearchText)) {
//       return true;
//     }
//
//     // Check if user_name matches the search text
//     if (data['user_name']
//         .toString()
//         .toLowerCase()
//         .contains(normalizedSearchText)) {
//       return true;
//     }
//
//     // Check if any category_name in the category_detail list matches the search text
//     if (data['category_detail'] is List) {
//       for (var category in data['category_detail']) {
//         if (category['category_name']
//             .toString()
//             .toLowerCase()
//             .contains(normalizedSearchText)) {
//           return true;
//         }
//       }
//     }
//
//     // If no matches found, return false
//     return false;
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Profile/chef_profile.dart';

class AllChefsList extends StatefulWidget {
  const AllChefsList({super.key});

  @override
  State<AllChefsList> createState() => _AllChefsListState();
}

class _AllChefsListState extends State<AllChefsList> {
  final List<Map<String, dynamic>> mockChefList = [
    {
      "user_id": "1",
      "user_type": "chef",
      "full_name": "Chef Ayesha",
      "user_name": "ayesha_cook",
      "chef_image": "https://via.placeholder.com/150",
      "avg_rating": 4.5,
      "distance_float": "2.3",
      "online_offline_flag": "online",
      "category_detail": [
        {"category_name": "Indian"},
        {"category_name": "Vegan"},
      ]
    },
    {
      "user_id": "2",
      "user_type": "chef",
      "full_name": "Chef John",
      "user_name": "john_grill",
      "chef_image": "https://via.placeholder.com/150",
      "avg_rating": 4.0,
      "distance_float": "3.7",
      "online_offline_flag": "offline",
      "category_detail": [
        {"category_name": "BBQ"},
        {"category_name": "Fast Food"},
      ]
    }
  ];

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filteredList = mockChefList
        .where((data) => listFilter(data, searchController.text))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search chefs...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredList.isEmpty
              ? const Center(child: Text('No Chefs available'))
              : ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final data = filteredList[index];

              return InkWell(
                onTap: () {
                  PageNavigateScreen().push(
                    context,
                    ChefProfilePage(
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
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: SizeConfig.getSizeHeightBy(
                                    context: context, by: 0.1),
                                color: DynamicColor.black
                                    .withOpacity(0.3),
                                child: CustomNetworkImage(
                                  url: data['chef_image'],
                                  fit: BoxFit.cover,
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
                          title: Text(data['full_name'],
                              style: white17Bold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text('Rating: ',
                                      style: lightWhite14Bold),
                                  Text('${data['avg_rating']}',
                                      style: primary15w5),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.star,
                                      size: 20,
                                      color: DynamicColor.primaryColor),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text('Miles: ',
                                      style: lightWhite14Bold),
                                  Text('${data['distance_float']}',
                                      style: green14w5),
                                ],
                              )
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
          ),
        ),
      ],
    );
  }

  bool listFilter(Map<String, dynamic> data, String searchText) {
    final lowerText = searchText.toLowerCase();

    return data['full_name'].toString().toLowerCase().contains(lowerText) ||
        data['user_name'].toString().toLowerCase().contains(lowerText) ||
        (data['category_detail'] as List).any((category) =>
            category['category_name']
                .toString()
                .toLowerCase()
                .contains(lowerText));
  }
}
