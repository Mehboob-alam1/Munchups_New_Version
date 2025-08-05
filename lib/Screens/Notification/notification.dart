// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/clear_all_notification_popup.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_notification_popup.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Screens/Buyer/Demand%20Food/demand_food_list.dart';
// import 'package:munchups_app/Screens/Buyer/Demand%20Food/proposal_list.dart';
// import 'package:munchups_app/Screens/Buyer/Following%20List/following_list.dart';
// import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
// import 'package:munchups_app/Screens/Buyer/My%20Orders/order_tabs.dart';
// import 'package:munchups_app/Screens/Chef/Chef%20Followers/chef_followers_list.dart';
// import 'package:munchups_app/Screens/Chef/Chef%20Orders/Bulk%20order/bulk_order_tabs.dart';
// import 'package:munchups_app/Screens/Chef/Chef%20Orders/chef_myorder_list.dart';
// import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
// import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
// import 'package:munchups_app/Screens/Notification/notify_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationList extends StatefulWidget {
//   const NotificationList({super.key});
//
//   @override
//   State<NotificationList> createState() => _NotificationListState();
// }
//
// class _NotificationListState extends State<NotificationList> {
//   String getUserType = 'buyer';
//
//   getUsertype() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       if (prefs.getString("user_type") != null) {
//         getUserType = prefs.getString("user_type").toString();
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getUsertype();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(
//             title: TextStrings.textKey['notification']!,
//             isDeleteNotification: true,
//             onTap: () {
//               showDialog(
//                 context: context,
//                 barrierDismissible: Platform.isAndroid ? false : true,
//                 builder: (context) => ClearAllNotificationPopUp(),
//               ).then((value) {
//                 setState(() {});
//               });
//             },
//           )),
//       body: FutureBuilder<NotoficationListModel>(
//           future: GetApiServer().notificationListApi(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return const Center(
//                     child: CircularProgressIndicator(
//                   color: DynamicColor.primaryColor,
//                 ));
//               default:
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('No Notification available'));
//                 } else if (snapshot.data!.success != 'true') {
//                   return const Center(child: Text('No Notification available'));
//                 } else if (snapshot.data!.notificationDetails == 'NA') {
//                   return const Center(child: Text('No Chefs available'));
//                 } else {
//                   return ListView.separated(
//                       shrinkWrap: true,
//                       primary: false,
//                       itemCount: snapshot.data!.notificationDetails.length,
//                       separatorBuilder: (context, index) =>
//                           const Divider(height: 0, color: DynamicColor.white),
//                       itemBuilder: (context, index) {
//                         NotificationDetail data =
//                             snapshot.data!.notificationDetails[index];
//                         return ListTile(
//                           onTap: () {
//                             if (getUserType == 'buyer') {
//                               onBuyerNavigation(data.action, data);
//                             } else if (getUserType == 'chef') {
//                               onChefNavigation(data.action, data);
//                             } else if (getUserType == 'grocer') {
//                               onGrocerNavigation(data.action, data);
//                             }
//                           },
//                           contentPadding: const EdgeInsets.only(
//                               left: 10, right: 10, bottom: 8),
//                           minLeadingWidth: 0.0,
//                           minVerticalPadding: 0.0,
//                           leading: CircleAvatar(
//                             backgroundColor: DynamicColor.white,
//                             child: Image.asset(
//                               'assets/images/bell.png',
//                               height: 35,
//                             ),
//                           ),
//                           title: Text(data.title, style: white17Bold),
//                           subtitle: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(data.message,
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color:
//                                           Color.fromARGB(255, 230, 230, 230))),
//                               Text(data.inserttime,
//                                   style: const TextStyle(
//                                       fontSize: 13,
//                                       color:
//                                           Color.fromARGB(255, 230, 230, 230))),
//                             ],
//                           ),
//                           trailing: InkWell(
//                             onTap: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible:
//                                       Platform.isAndroid ? false : true,
//                                   builder: (context) => NotificationDeletePopUp(
//                                         id: data.notificationId.toString(),
//                                       )).then((value) {
//                                 setState(() {});
//                               });
//                             },
//                             child: const Icon(
//                               Icons.close,
//                               color: Colors.red,
//                               size: 30,
//                             ),
//                           ),
//                         );
//                       });
//                 }
//             }
//           }),
//     );
//   }
//
//   void onBuyerNavigation(String action, NotificationDetail data) {
//     switch (action) {
//       case 'food_order':
//         PageNavigateScreen().push(context, const PostedDemandFoodPage());
//         break;
//       case 'order_place':
//         PageNavigateScreen().push(context, OrderTabs(currentIndex: 0));
//         break;
//       case 'dish_update':
//         PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
//         break;
//       case 'follow':
//         PageNavigateScreen().push(context, const FollowingList());
//         break;
//       case 'proposal_status':
//         var s = jsonDecode(data.messageJson);
//
//         PageNavigateScreen().push(
//             context,
//             ProposalFoodListPage(
//               buyerID: data.userId,
//               foodID: s['food_id'],
//             ));
//         break;
//       case 'dish_repost':
//         PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
//         break;
//       case 'broadcast':
//         PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
//         break;
//       case 'order_status':
//         PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
//         break;
//       default:
//         PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
//     }
//   }
//
//   void onChefNavigation(String action, NotificationDetail data) {
//     switch (action) {
//       case 'food_order':
//         PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//         break;
//       case 'order_place':
//         PageNavigateScreen().push(context, const ChefOrderList());
//         break;
//       case 'dish_update':
//         PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//         break;
//       case 'follow':
//         PageNavigateScreen().push(context, const ChefFollowersList());
//         break;
//       case 'proposal_status':
//         //var s = jsonDecode(data.messageJson);
//         PageNavigateScreen().push(context, BulkOrderTabs(currentIndex: 1));
//         // PageNavigateScreen().push(
//         //     context,
//         //     ProposalFoodListPage(
//         //       buyerID: data.userId,
//         //       foodID: s['food_id'],
//         //     ));
//         break;
//       case 'dish_repost':
//         PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//         break;
//       case 'broadcast':
//         PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//         break;
//       case 'order_status':
//         PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//         break;
//       default:
//         PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
//     }
//   }
//
//   void onGrocerNavigation(String action, NotificationDetail data) {
//     switch (action) {
//       case 'food_order':
//         PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
//         break;
//       case 'order_place':
//         PageNavigateScreen().push(context, const ChefOrderList());
//         break;
//       case 'dish_update':
//         PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
//         break;
//       case 'follow':
//         PageNavigateScreen().push(context, const ChefFollowersList());
//         break;
//       case 'proposal_status':
//         //var s = jsonDecode(data.messageJson);
//         PageNavigateScreen().push(context, BulkOrderTabs(currentIndex: 1));
//         // PageNavigateScreen().push(
//         //     context,
//         //     ProposalFoodListPage(
//         //       buyerID: data.userId,
//         //       foodID: s['food_id'],
//         //     ));
//         break;
//       case 'dish_repost':
//         PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
//         break;
//       case 'broadcast':
//         PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
//         break;
//       case 'order_status':
//         PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
//         break;
//       default:
//         PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
//     }
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  String getUserType = 'buyer';

  final List<Map<String, dynamic>> mockNotifications = [
    {
      'title': 'Order Placed',
      'message': 'Your order has been successfully placed.',
      'time': '2025-08-06 12:45 PM',
      'action': 'order_place',
    },
    {
      'title': 'New Follower',
      'message': 'You have a new follower.',
      'time': '2025-08-05 09:15 AM',
      'action': 'follow',
    },
    {
      'title': 'Dish Update',
      'message': 'A dish you like has been updated.',
      'time': '2025-08-04 03:30 PM',
      'action': 'dish_update',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(
          title: TextStrings.textKey['notification']!,
          isDeleteNotification: true,
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: Platform.isAndroid ? false : true,
              builder: (context) => AlertDialog(
                title: const Text("Clear All Notifications"),
                content: const Text("Are you sure you want to clear all notifications?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("Clear"),
                    onPressed: () {
                      setState(() => mockNotifications.clear());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: mockNotifications.isEmpty
          ? const Center(child: Text('No Notification available'))
          : ListView.separated(
        itemCount: mockNotifications.length,
        separatorBuilder: (context, index) => const Divider(height: 0, color: DynamicColor.white),
        itemBuilder: (context, index) {
          final data = mockNotifications[index];
          return ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navigate to: ${data['action']}')),
              );
            },
            contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            leading: CircleAvatar(
              backgroundColor: DynamicColor.white,
              child: Image.asset('assets/images/bell.png', height: 35),
            ),
            title: Text(data['title'], style: white17Bold),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['message'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 230, 230, 230)),
                ),
                Text(
                  data['time'],
                  style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 230, 230, 230)),
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: Platform.isAndroid ? false : true,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Notification"),
                    content: const Text("Are you sure you want to delete this notification?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("Delete"),
                        onPressed: () {
                          setState(() => mockNotifications.removeAt(index));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.close, color: Colors.red, size: 30),
            ),
          );
        },
      ),
    );
  }
}
