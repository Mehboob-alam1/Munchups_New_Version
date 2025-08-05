// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/add_to_card.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Buyer/Chefs/detail_page.dart';
// import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
// import 'package:munchups_app/Screens/Buyer/Profile/profile.dart';
// import 'package:munchups_app/Screens/Buyer/Reviews%20to%20Chef%20and%20grocer/reviews.dart';
// import 'package:munchups_app/Screens/Chef/Chef%20Profile/report_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChefProfilePage extends StatefulWidget {
//   dynamic userId;
//   String userType;
//   String currentUser;
//   ChefProfilePage(
//       {super.key,
//       required this.userId,
//       required this.userType,
//       required this.currentUser});
//
//   @override
//   State<ChefProfilePage> createState() => _ChefProfilePageState();
// }
//
// class _ChefProfilePageState extends State<ChefProfilePage> {
//   bool isLoading = false;
//   dynamic userData;
//   dynamic guestUserData;
//
//   Location location = Location();
//
//   @override
//   void initState() {
//     super.initState();
//     getLocation();
//     getUserProfile();
//     getGuestUserdata();
//   }
//
//   getGuestUserdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       guestUserData = jsonDecode(prefs.getString('data').toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//         leadingWidth: 100,
//         leading: Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   PageNavigateScreen().back(context);
//                 },
//                 icon: const Icon(Icons.arrow_back_ios,
//                     color: DynamicColor.white)),
//             const SizedBox(width: 5),
//             if (guestUserData == null)
//               InkWell(
//                   onTap: () {
//                     PageNavigateScreen()
//                         .pushRemovUntil(context, const BuyerHomePage());
//                   },
//                   child: const Icon(
//                     Icons.home,
//                     color: DynamicColor.white,
//                     size: 28,
//                   )),
//           ],
//         ),
//         actions: [
//           Row(
//             children: [
//               widget.currentUser == 'buyer'
//                   ? Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: InkWell(
//                             onTap: () {
//                               PageNavigateScreen().push(
//                                   context,
//                                   ReviewsToChefAndGrocer(
//                                     data: userData['profile_data']
//                                         ['all_review'],
//                                     totalRating: userData['profile_data']
//                                         ['avg_rating'],
//                                   ));
//                             },
//                             child: Container(
//                               height: 35,
//                               width: SizeConfig.getSizeWidthBy(
//                                   context: context, by: 0.2),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   color: DynamicColor.primaryColor,
//                                   border: Border.all(
//                                       color: DynamicColor.primaryColor),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: Text(TextStrings.textKey['reviews']!,
//                                   style: white15bold),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: InkWell(
//                             onTap: () {
//                               PageNavigateScreen()
//                                   .push(context, ReportPage(data: userData));
//                             },
//                             child: Container(
//                               height: 35,
//                               width: SizeConfig.getSizeWidthBy(
//                                   context: context, by: 0.2),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   color: DynamicColor.primaryColor,
//                                   border: Border.all(
//                                       color: DynamicColor.primaryColor),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: Text(TextStrings.textKey['report']!,
//                                   style: white15bold),
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: InkWell(
//                         onTap: () {
//                           PageNavigateScreen()
//                               .push(context, const BuyerProfilePage());
//                         },
//                         child: Container(
//                           height: 35,
//                           width: SizeConfig.getSizeWidthBy(
//                               context: context, by: 0.2),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               color: DynamicColor.primaryColor,
//                               border:
//                                   Border.all(color: DynamicColor.primaryColor),
//                               borderRadius: BorderRadius.circular(8)),
//                           child: Text('Edit', style: white15bold),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(
//               child:
//                   CircularProgressIndicator(color: DynamicColor.primaryColor))
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     left: SizeConfig.getSize20(context: context),
//                     right: SizeConfig.getSize20(context: context)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     userImage(),
//                     const SizedBox(height: 20),
//                     Text(
//                         userData != null
//                             ? userData['profile_data']['first_name'] +
//                                 ' ' +
//                                 userData['profile_data']['last_name']
//                             : '',
//                         style: white21w5),
//                     userData != null
//                         ? userData['profile_data']['category'] != 'NA'
//                             ? SizedBox(
//                                 height: 40,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Center(
//                                   child: ListView.builder(
//                                       shrinkWrap: true,
//                                       primary: false,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: userData['profile_data']
//                                               ['category']
//                                           .length,
//                                       itemBuilder: (context, index) {
//                                         return Center(
//                                           child: Container(
//                                             height: 30,
//                                             padding:
//                                                 const EdgeInsets.only(left: 5),
//                                             child: CustomNetworkImage(
//                                                 url: userData['profile_data']
//                                                         ['category'][index]
//                                                     ['category_image']),
//                                           ),
//                                         );
//                                       }),
//                                 ),
//                               )
//                             : Container()
//                         : Container(),
//                     const SizedBox(height: 20),
//                     myPost(),
//                     const Divider(color: DynamicColor.white),
//                     list()
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
//
//   Widget userImage() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//             child: Align(
//                 alignment: Alignment.center,
//                 child: userData != null
//                     ? Text('${userData['profile_data']['post_count']} Posts',
//                         style: white15bold)
//                     : Text('0 Posts', style: white15bold))),
//         Expanded(
//             child: userData != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.15,
//                       width: MediaQuery.of(context).size.width,
//                       child: CustomNetworkImage(
//                         url: userData['profile_data']['image'],
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   )
//                 : const CircleAvatar(
//                     radius: 60,
//                     backgroundColor: DynamicColor.primaryColor,
//                     backgroundImage: AssetImage('assets/images/user_icon.jpg'),
//                   )),
//         Expanded(
//             child: Align(
//                 alignment: Alignment.centerRight,
//                 child: userData != null
//                     ? Text('${userData['profile_data']['followers']} Followers',
//                         style: white15bold)
//                     : Text('0 Followers', style: white15bold))),
//       ],
//     );
//   }
//
//   Widget myPost() {
//     return Align(
//         alignment: Alignment.centerLeft,
//         child: Text('Recent Post', style: white17Bold));
//   }
//
//   Widget list() {
//     return Padding(
//       padding: EdgeInsets.only(top: SizeConfig.getSize20(context: context)),
//       child: userData == null || userData['profile_data']['all_post'] == 'NA'
//           ? Center(
//               child: Padding(
//               padding: EdgeInsets.only(
//                   top: SizeConfig.getSizeHeightBy(context: context, by: 0.2)),
//               child: Text('No Post Available', style: primary15w5),
//             ))
//           : GridView.builder(
//               shrinkWrap: true,
//               primary: false,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: MediaQuery.of(context).size.width /
//                       (MediaQuery.of(context).size.height * 0.80)),
//               itemCount: userData['profile_data']['all_post'].length,
//               itemBuilder: (context, index) {
//                 dynamic dishData = userData['profile_data']['all_post'][index];
//                 return InkWell(
//                   onTap: () {
//                     PageNavigateScreen().push(
//                         context,
//                         DetailPage(
//                           // userData: userData['profile_data'],
//                           data: dishData,
//                           // guestUserData: guestUserData,
//                         ));
//                   },
//                   child: Card(
//                     color: DynamicColor.boxColor,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: SizedBox(
//                             height: SizeConfig.getSizeHeightBy(
//                                 context: context, by: 0.18),
//                             width: SizeConfig.getSizeWidthBy(
//                                 context: context, by: 0.42),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(100),
//                               child: CustomNetworkImage(
//                                   url: dishData['dish_images'] == 'NA'
//                                       ? ''
//                                       : dishData['dish_images'][0]
//                                           ['kitchen_image']),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                             child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(dishData['dish_name'],
//                                   style: white14w5,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                               Text('$currencySymbol${dishData['dish_price']}',
//                                   style: greenColor15bold,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                               const SizedBox(height: 10),
//                               widget.currentUser == 'buyer'
//                                   ? AddToCardWidget(
//                                       data: dishData,
//                                       checkGuestUser: guestUserData,
//                                     )
//                                   : Center(
//                                       child: Text('Dish Serving time',
//                                           style: white15bold)),
//                               Center(
//                                 child: Text('9AM - 12PM', style: primary15w5),
//                               ),
//                             ],
//                           ),
//                         ))
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//     );
//   }
//
//   void getUserProfile() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       await GetApiServer()
//           .getOtherUserProfileApi(widget.userId, widget.userType)
//           .then((value) {
//         setState(() {
//           isLoading = false;
//         });
//         if (value['success'] == 'true') {
//           setState(() {
//             userData = value;
//           });
//         } else {
//           Utils().myToast(context, msg: value['msg']);
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       // log(e.toString());
//     }
//   }
//
//   saveUserLatLong(latlong) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setString('guestLatLong', jsonEncode(latlong));
//     });
//   }
//
//   Future<void> getLocation() async {
//     try {
//       await location.getLocation().then((value) {
//         var s = {
//           'lat': value.latitude.toString(),
//           'long': value.longitude.toString(),
//         };
//         saveUserLatLong(s);
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/add_to_card.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/Chefs/detail_page.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Buyer/Profile/profile.dart';
import 'package:munchups_app/Screens/Buyer/Reviews%20to%20Chef%20and%20grocer/reviews.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Profile/report_page.dart';

import '../../../Component/global_data/global_data.dart';

class ChefProfilePage extends StatefulWidget {
  final dynamic userId;
  final String userType;
  final String currentUser;

  const ChefProfilePage({
    super.key,
    required this.userId,
    required this.userType,
    required this.currentUser,
  });

  @override
  State<ChefProfilePage> createState() => _ChefProfilePageState();
}

class _ChefProfilePageState extends State<ChefProfilePage> {
  dynamic userData;
  dynamic guestUserData;

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  void loadMockData() {
    // Replace this with your mock JSON or sample data
    userData = {
      "profile_data": {
        "first_name": "John",
        "last_name": "Doe",
        "post_count": 3,
        "followers": 120,
        "image": "https://via.placeholder.com/150",
        "category": [
          {
            "category_image": "https://via.placeholder.com/30",
          }
        ],
        "all_post": [
          {
            "dish_name": "Pasta",
            "dish_price": "10.0",
            "dish_images": [
              {"kitchen_image": "https://via.placeholder.com/100"}
            ],
          },
          {
            "dish_name": "Pizza",
            "dish_price": "12.0",
            "dish_images": [
              {"kitchen_image": "https://via.placeholder.com/100"}
            ],
          },
          {
            "dish_name": "Burger",
            "dish_price": "8.0",
            "dish_images": [
              {"kitchen_image": "https://via.placeholder.com/100"}
            ],
          }
        ],
        "avg_rating": 4.5,
        "all_review": []
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                PageNavigateScreen().back(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: DynamicColor.white),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
              },
              child: const Icon(Icons.home, color: DynamicColor.white, size: 28),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              if (widget.currentUser == 'buyer') ...[
                _actionButton('Reviews', () {
                  PageNavigateScreen().push(
                    context,
                    ReviewsToChefAndGrocer(
                      data: [],
                      totalRating: userData['profile_data']['avg_rating'],
                    ),
                  );
                }),
                _actionButton('Report', () {
                  PageNavigateScreen().push(context, ReportPage(data: userData));
                }),
              ] else
                _actionButton('Edit', () {
                  // PageNavigateScreen().push(context, const BuyerProfilePage());
                }),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.getSize20(context: context)),
          child: Column(
            children: [
              userImage(),
              const SizedBox(height: 20),
              Text(
                '${userData['profile_data']['first_name']} ${userData['profile_data']['last_name']}',
                style: white21w5,
              ),
              const SizedBox(height: 10),
              _buildCategoryImages(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Recent Post', style: white17Bold),
              ),
              const Divider(color: DynamicColor.white),
              _buildPostGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 35,
          width: SizeConfig.getSizeWidthBy(context: context, by: 0.2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: DynamicColor.primaryColor,
            border: Border.all(color: DynamicColor.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: white15bold),
        ),
      ),
    );
  }

  Widget userImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Text('${userData['profile_data']['post_count']} Posts', style: white15bold))),
        Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: CustomNetworkImage(
                  url: userData['profile_data']['image'],
                  fit: BoxFit.fill,
                ),
              ),
            )),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text('${userData['profile_data']['followers']} Followers', style: white15bold))),
      ],
    );
  }

  Widget _buildCategoryImages() {
    final categories = userData['profile_data']['category'];
    if (categories == null || categories == 'NA') return const SizedBox();
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            child: CustomNetworkImage(url: categories[index]['category_image']),
          );
        },
      ),
    );
  }

  Widget _buildPostGrid() {
    final posts = userData['profile_data']['all_post'];
    if (posts == null || posts == 'NA') {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.getSizeHeightBy(context: context, by: 0.2),
          ),
          child: Text('No Post Available', style: primary15w5),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height * 0.80),
      ),
      itemBuilder: (context, index) {
        final dish = posts[index];
        return InkWell(
          onTap: () {
            PageNavigateScreen().push(
              context,
              DetailPage(data: dish),
            );
          },
          child: Card(
            color: DynamicColor.boxColor,
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.getSizeHeightBy(context: context, by: 0.18),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CustomNetworkImage(
                      url: dish['dish_images'][0]['kitchen_image'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(dish['dish_name'], style: white14w5),
                      Text('$currencySymbol${dish['dish_price']}', style: greenColor15bold),
                      const SizedBox(height: 10),
                      widget.currentUser == 'buyer'
                          ? AddToCardWidget(data: dish, checkGuestUser: guestUserData)
                          : Center(child: Text('Dish Serving time', style: white15bold)),
                      Center(child: Text('9AM - 12PM', style: primary15w5)),
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
