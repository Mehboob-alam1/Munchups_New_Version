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
// class CompleteOrderList extends StatefulWidget {
//   const CompleteOrderList({super.key});
//
//   @override
//   State<CompleteOrderList> createState() => _CompleteOrderListState();
// }
//
// class _CompleteOrderListState extends State<CompleteOrderList> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: GetApiServer().myOrderListApi(),
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
//               } else if (snapshot.data!['oc_complete_order_arr'] == 'NA') {
//                 return const Center(child: Text('No order available'));
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       itemCount: snapshot.data['oc_complete_order_arr'].length,
//                       itemBuilder: (context, index) {
//                         dynamic data =
//                             snapshot.data['oc_complete_order_arr'][index];
//                         return InkWell(
//                           onTap: () {
//                             PageNavigateScreen().push(
//                                 context,
//                                 LiveOrderDetailPage(
//                                     data: data, fromuserName: 'Chef'));
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
//                                         url: data['image'],
//                                         fit: BoxFit.contain),
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
//                                               Text(data['last_name'],
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

class CompleteOrderList extends StatelessWidget {
  const CompleteOrderList({super.key});

  // Mock data replacing API response
  final List<Map<String, dynamic>> mockOrders = const [
    {
      'last_name': 'Smith',
      'order_unique_number': 'ORD123456',
      'order_status': 'completed',
      'budget': '25.50',
      'image':
      'https://via.placeholder.com/150', // Replace with your image URL
    },
    {
      'last_name': 'Johnson',
      'order_unique_number': 'ORD654321',
      'order_status': 'completed',
      'budget': '42.00',
      'image':
      'https://via.placeholder.com/150',
    },
    // Add more mock items if needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mockOrders.length,
      itemBuilder: (context, index) {
        final data = mockOrders[index];
        return InkWell(
          onTap: () {
            PageNavigateScreen().push(
              context,
              LiveOrderDetailPage(data: data, fromuserName: 'Chef'),
            );
          },
          child: Card(
            color: DynamicColor.boxColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: SizeConfig.getSizeHeightBy(
                          context: context, by: 0.1),
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
                              data['last_name'],
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
                                Text(
                                  'Status: ',
                                  style: white14w5,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  data['order_status'].toString().toUpperCase(),
                                  style: green14w5,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                      Platform.isAndroid ? false : true,
                                      builder: (context) => DeleteOrderPopUp(
                                        id: data['order_unique_number'],
                                        orderType: 'Bulk',
                                      ),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: DynamicColor.primaryColor,
                                    child: Icon(
                                      Icons.close,
                                      color: DynamicColor.white,
                                      size: 20,
                                    ),
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
                        ),
                      ],
                    ),
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
