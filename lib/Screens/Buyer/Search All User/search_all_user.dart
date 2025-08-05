// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/follow_unfollow_popup.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Screens/Buyer/Search%20All%20User/search_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../Comman widgets/app_bar/back_icon_appbar.dart';
//
// class SearchAllUsersList extends StatefulWidget {
//   const SearchAllUsersList({super.key});
//
//   @override
//   State<SearchAllUsersList> createState() => _SearchAllUsersListState();
// }
//
// class _SearchAllUsersListState extends State<SearchAllUsersList> {
//   TextEditingController textEditingController = TextEditingController();
//
//   int myFollower = 0;
//
//   getFollowingCount() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       myFollower = prefs.getInt('following_count')!;
//     });
//   }
//
//   saveFollowingCount(value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       prefs.setInt("following_count", value);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getFollowingCount();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['search']!)),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Expanded(child: serchBox()),
//             Expanded(
//               flex: 12,
//               child: FutureBuilder<AllChefGrocerListModel>(
//                   future: GetApiServer().allChefAndGrocerListApi(),
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                         return const Center(
//                             child: CircularProgressIndicator(
//                           color: DynamicColor.primaryColor,
//                         ));
//                       default:
//                         if (snapshot.hasError) {
//                           return const Center(
//                               child: Text('No users available'));
//                         } else if (snapshot.data!.success != 'true') {
//                           return const Center(
//                               child: Text('No users available'));
//                         } else if (snapshot.data!.followingsDetails == 'NA') {
//                           return const Center(
//                               child: Text('No Chefs available'));
//                         } else {
//                           return ValueListenableBuilder(
//                               valueListenable: textEditingController,
//                               builder: (context, o, w) {
//                                 return ListView.builder(
//                                     shrinkWrap: true,
//                                     primary: false,
//                                     itemCount:
//                                         snapshot.data!.followingsDetails.length,
//                                     itemBuilder: (context, index) {
//                                       FollowingsDetail data = snapshot
//                                           .data!.followingsDetails[index];
//                                       if (listFlitter(data)) {
//                                         return Card(
//                                           elevation: 10,
//                                           color: DynamicColor.boxColor,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: ListTile(
//                                             minLeadingWidth: 0.0,
//                                             horizontalTitleGap: 10,
//                                             contentPadding:
//                                                 const EdgeInsets.only(
//                                                     left: 5, right: 5),
//                                             minVerticalPadding: 0.0,
//                                             leading: SizedBox(
//                                               height: 45,
//                                               width: 45,
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(50),
//                                                 child: CustomNetworkImage(
//                                                     url: data.image),
//                                               ),
//                                             ),
//                                             title: Text(
//                                               data.userName,
//                                               style: white15bold,
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             subtitle: Text(
//                                               'Type: ${data.userType}',
//                                               style: secondry14bold,
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             trailing: InkWell(
//                                               onTap: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     barrierDismissible:
//                                                         Platform.isAndroid
//                                                             ? false
//                                                             : true,
//                                                     builder: (context) =>
//                                                         FollowUnfollowPopUp(
//                                                           toUserID: data.userId
//                                                               .toString(),
//                                                           currentStatus: data
//                                                               .currentStatus,
//                                                         )).then((value) {
//                                                   setState(() {
//                                                     if (data.currentStatus ==
//                                                         'Unfollow') {
//                                                       myFollower--;
//                                                     } else {
//                                                       myFollower++;
//                                                     }
//
//                                                     saveFollowingCount(
//                                                         myFollower);
//                                                   });
//                                                 });
//                                               },
//                                               child: Container(
//                                                 height: 35,
//                                                 width: 100,
//                                                 alignment: Alignment.center,
//                                                 decoration: BoxDecoration(
//                                                     color: DynamicColor
//                                                         .primaryColor,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8.0)),
//                                                 child: Text(data.currentStatus,
//                                                     style: white15bold),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         return Container();
//                                       }
//                                     });
//                               });
//                         }
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget serchBox() {
//     return InputFieldsWithLightWhiteColor(
//         labelText: 'Search by Username, Name',
//         controller: textEditingController,
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.emailAddress,
//         prefixIcon: const Icon(
//           Icons.search,
//           color: DynamicColor.primaryColor,
//         ),
//         style: black15bold,
//         onChanged: (value) {
//           // setState(() {});
//         });
//   }
//
//   bool listFlitter(FollowingsDetail data) {
//     if (data.userName
//             .toString()
//             .toLowerCase()
//             .contains(textEditingController.text.toLowerCase()) ||
//         data.firstName
//             .toString()
//             .toUpperCase()
//             .contains(textEditingController.text.toUpperCase())) {
//       return true;
//     }
//     return false;
//   }
// }

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import '../../../Comman widgets/app_bar/back_icon_appbar.dart';

class SearchAllUsersList extends StatefulWidget {
  const SearchAllUsersList({super.key});

  @override
  State<SearchAllUsersList> createState() => _SearchAllUsersListState();
}

class _SearchAllUsersListState extends State<SearchAllUsersList> {
  TextEditingController textEditingController = TextEditingController();

  List<Map<String, dynamic>> mockUserList = [
    {
      'userName': 'chef_john',
      'firstName': 'John',
      'userType': 'Chef',
      'image': 'https://via.placeholder.com/150',
      'currentStatus': 'Follow',
    },
    {
      'userName': 'grocer_amy',
      'firstName': 'Amy',
      'userType': 'Grocer',
      'image': 'https://via.placeholder.com/150',
      'currentStatus': 'Unfollow',
    },
    {
      'userName': 'chef_emma',
      'firstName': 'Emma',
      'userType': 'Chef',
      'image': 'https://via.placeholder.com/150',
      'currentStatus': 'Follow',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredUsers = mockUserList.where((user) {
      final query = textEditingController.text.toLowerCase();
      return user['userName'].toLowerCase().contains(query) ||
          user['firstName'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['search']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 🔍 Search Box
            InputFieldsWithLightWhiteColor(
              labelText: 'Search by Username, Name',
              controller: textEditingController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(Icons.search, color: DynamicColor.primaryColor),
              style: black15bold,
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 12),

            // 👤 List of Users
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    elevation: 10,
                    color: DynamicColor.boxColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CustomNetworkImage(
                          url: user['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        user['userName'],
                        style: white15bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Type: ${user['userType']}',
                        style: secondry14bold,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          setState(() {
                            user['currentStatus'] =
                            user['currentStatus'] == 'Follow'
                                ? 'Unfollow'
                                : 'Follow';
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DynamicColor.primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            user['currentStatus'],
                            style: white15bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
