// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Screens/Buyer/My%20Orders/live_order_detail.dart';
//
// class ChefActiveBulkOrderList extends StatefulWidget {
//   const ChefActiveBulkOrderList({super.key});
//
//   @override
//   State<ChefActiveBulkOrderList> createState() =>
//       _ChefActiveBulkOrderListState();
// }
//
// class _ChefActiveBulkOrderListState extends State<ChefActiveBulkOrderList> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: GetApiServer().myChefOrderListApi(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return const Center(
//                   child: CircularProgressIndicator(
//                 color: DynamicColor.primaryColor,
//               ));
//             default:
//               if (snapshot.hasError) {
//                 return const Center(child: Text('No orders available'));
//               } else if (snapshot.data['success'] != 'true') {
//                 return const Center(child: Text('No orders available'));
//               } else if (snapshot.data!['oc_active_order_arr'] == 'NA') {
//                 return const Center(child: Text('No order available'));
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       itemCount: snapshot.data['oc_active_order_arr'].length,
//                       itemBuilder: (context, index) {
//                         dynamic data =
//                             snapshot.data['oc_active_order_arr'][index];
//                         return InkWell(
//                           onTap: () {
//                             PageNavigateScreen().push(
//                                 context,
//                                 LiveOrderDetailPage(
//                                     data: data, fromuserName: 'Buyer'));
//                           },
//                           child: Card(
//                             color: DynamicColor.boxColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                     child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Container(
//                                     height: SizeConfig.getSizeHeightBy(
//                                         context: context, by: 0.1),
//                                     color: DynamicColor.black.withOpacity(0.3),
//                                     child: CustomNetworkImage(
//                                       url: data['image'],
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 )),
//                                 Expanded(
//                                     flex: 3,
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left: 8.0),
//                                       child: Stack(
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const SizedBox(height: 5),
//                                               Text(
//                                                   '${data['first_name']} ${data['last_name']}',
//                                                   style: white17Bold,
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                               const SizedBox(height: 3),
//                                               Text(
//                                                   'Order ID: ${data['order_unique_number']}',
//                                                   style: white14w5,
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                               const SizedBox(height: 3),
//                                               // Text(
//                                               //     'Ouantity: ${data['item'][0]['quantity']}',
//                                               //     style: white14w5,
//                                               //     maxLines: 1,
//                                               //     overflow:
//                                               //         TextOverflow.ellipsis),
//                                               // const SizedBox(height: 3),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text('Status: ',
//                                                       style: white14w5,
//                                                       maxLines: 1,
//                                                       overflow: TextOverflow
//                                                           .ellipsis),
//                                                   Text(
//                                                       data['order_status']
//                                                           .toString()
//                                                           .toUpperCase(),
//                                                       style: green14w5,
//                                                       maxLines: 1,
//                                                       overflow: TextOverflow
//                                                           .ellipsis),
//                                                 ],
//                                               ),
//                                               const SizedBox(height: 3),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Align(
//                                               alignment: Alignment.topRight,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.end,
//                                                 children: [
//                                                   InkWell(
//                                                     onTap: () {
//                                                       showDialog(
//                                                           context: context,
//                                                           barrierDismissible:
//                                                               Platform.isAndroid
//                                                                   ? false
//                                                                   : true,
//                                                           builder: (context) =>
//                                                               DeleteOrderPopUp(
//                                                                 id: data[
//                                                                     'order_unique_number'],
//                                                                 orderType:
//                                                                     'Bulk',
//                                                               )).then((value) {
//                                                         setState(() {});
//                                                       });
//                                                     },
//                                                     child: const CircleAvatar(
//                                                         radius: 12,
//                                                         backgroundColor:
//                                                             DynamicColor
//                                                                 .primaryColor,
//                                                         child: Icon(
//                                                           Icons.close,
//                                                           color: DynamicColor
//                                                               .white,
//                                                           size: 20,
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   Text(
//                                                       '$currencySymbol${data['budget']}',
//                                                       style: greenColor15bold,
//                                                       maxLines: 1,
//                                                       overflow: TextOverflow
//                                                           .ellipsis),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ))
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                 );
//               }
//           }
//         });
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/live_order_detail.dart';

class ChefActiveBulkOrderList extends StatefulWidget {
  const ChefActiveBulkOrderList({super.key});

  @override
  State<ChefActiveBulkOrderList> createState() => _ChefActiveBulkOrderListState();
}

class _ChefActiveBulkOrderListState extends State<ChefActiveBulkOrderList> {
  // Mock data for frontend
  List<Map<String, dynamic>> mockOrderList = [
    {
      'first_name': 'John',
      'last_name': 'Doe',
      'order_unique_number': 'ORD123456',
      'image': '', // Add image URL or leave empty
      'order_status': 'active',
      'budget': '120'
    },
    {
      'first_name': 'Emma',
      'last_name': 'Smith',
      'order_unique_number': 'ORD123457',
      'image': '', // Add image URL or leave empty
      'order_status': 'preparing',
      'budget': '180'
    },
    {
      'first_name': 'Liam',
      'last_name': 'Williams',
      'order_unique_number': 'ORD123458',
      'image': '',
      'order_status': 'completed',
      'budget': '250'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mockOrderList.length,
        itemBuilder: (context, index) {
          final data = mockOrderList[index];

          return InkWell(
            onTap: () {
              PageNavigateScreen().push(
                context,
                LiveOrderDetailPage(data: data, fromuserName: 'Buyer'),
              );
            },
            child: Card(
              color: DynamicColor.boxColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: SizeConfig.getSizeHeightBy(context: context, by: 0.1),
                        color: DynamicColor.black.withOpacity(0.3),
                        child: CustomNetworkImage(
                          url: data['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                '${data['first_name']} ${data['last_name']}',
                                style: white17Bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Order ID: ${data['order_unique_number']}',
                                style: white14w5,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text('Status: ', style: white14w5),
                                  Text(
                                    data['order_status'].toString().toUpperCase(),
                                    style: green14w5,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: Platform.isAndroid ? false : true,
                                      builder: (context) => DeleteOrderPopUp(
                                        id: data['order_unique_number'],
                                        orderType: 'Bulk',
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        // Optional: Remove item after delete in frontend
                                        // mockOrderList.removeAt(index);
                                      });
                                    });
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: DynamicColor.primaryColor,
                                    child: Icon(Icons.close, color: DynamicColor.white, size: 20),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$currencySymbol${data['budget']}',
                                  style: greenColor15bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
