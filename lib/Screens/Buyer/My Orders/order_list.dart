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
// import 'package:munchups_app/Screens/Buyer/My%20Orders/order_detail.dart';
//
// class MyOrderList extends StatefulWidget {
//   const MyOrderList({super.key});
//
//   @override
//   State<MyOrderList> createState() => _MyOrderListState();
// }
//
// class _MyOrderListState extends State<MyOrderList> {
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
//               } else if (snapshot.data!['data'] == 'NA') {
//                 return const Center(child: Text('No order available'));
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       itemCount: snapshot.data['data'].length,
//                       itemBuilder: (context, index) {
//                         dynamic data = snapshot.data['data'][index];
//
//                         return InkWell(
//                           onTap: () {
//                             PageNavigateScreen().push(
//                                 context,
//                                 OrderDetailPage(
//                                   data: data,
//                                   userType: 'Buyer',
//                                 ));
//                           },
//                           child: Card(
//                             color: DynamicColor.boxColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                     child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Container(
//                                     height: SizeConfig.getSizeHeightBy(
//                                         context: context, by: 0.1),
//                                     color: DynamicColor.black.withOpacity(0.3),
//                                     child: CustomNetworkImage(
//                                       url:
//                                           data['item'][0]['dish_images'] == 'NA'
//                                               ? ""
//                                               : data['item'][0]['dish_images']
//                                                   [0]['kitchen_image'],
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
//                                               Text(data['item'][0]['name'],
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
//                                               Text(
//                                                   'Ouantity: ${data['item'][0]['quantity']}',
//                                                   style: white14w5,
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                               const SizedBox(height: 3),
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
//                                                       data['delivery_status'] ==
//                                                               'delivered'
//                                                           ? data['delivery_status']
//                                                               .toString()
//                                                               .toUpperCase()
//                                                           : data['status']
//                                                               .toString()
//                                                               .toUpperCase(),
//                                                       style: TextStyle(
//                                                           fontSize: 14.0,
//                                                           color: data['delivery_status'] ==
//                                                                   'delivered'
//                                                               ? DynamicColor
//                                                                   .green
//                                                               : data['status'] ==
//                                                                       'pending'
//                                                                   ? DynamicColor
//                                                                       .primaryColor
//                                                                   : data['status'] ==
//                                                                           'accept'
//                                                                       ? DynamicColor
//                                                                           .green
//                                                                       : DynamicColor
//                                                                           .redColor,
//                                                           fontWeight:
//                                                               FontWeight.bold),
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
//                                                                     'Order Delete',
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
//                                                       '$currencySymbol${data['item'][0]['total_amount']}',
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
import 'package:munchups_app/Screens/Buyer/My%20Orders/order_detail.dart';

class MyOrderList extends StatelessWidget {
  final List<dynamic> orderData;
  final VoidCallback onRefresh;

  const MyOrderList({
    super.key,
    required this.orderData,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (orderData.isEmpty) {
      return const Center(child: Text('No orders available'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: orderData.length,
        itemBuilder: (context, index) {
          final data = orderData[index];

          return InkWell(
            onTap: () {
              PageNavigateScreen().push(
                context,
                OrderDetailPage(data: data, userType: 'Buyer'),
              );
            },
            child: Card(
              color: DynamicColor.boxColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  // Image Preview
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: SizeConfig.getSizeHeightBy(
                            context: context, by: 0.1),
                        color: DynamicColor.black.withOpacity(0.3),
                        child: CustomNetworkImage(
                          url: data['item'][0]['dish_images'] == 'NA'
                              ? ""
                              : data['item'][0]['dish_images'][0]
                          ['kitchen_image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Details
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
                              Text(data['item'][0]['name'],
                                  style: white17Bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 3),
                              Text(
                                  'Order ID: ${data['order_unique_number']}',
                                  style: white14w5),
                              const SizedBox(height: 3),
                              Text(
                                  'Quantity: ${data['item'][0]['quantity']}',
                                  style: white14w5),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text('Status: ', style: white14w5),
                                  Text(
                                    data['delivery_status'] == 'delivered'
                                        ? data['delivery_status']
                                        .toString()
                                        .toUpperCase()
                                        : data['status']
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: _getStatusColor(data),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                            ],
                          ),
                          // Price & Delete
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
                                      barrierDismissible: !Platform.isAndroid,
                                      builder: (context) => DeleteOrderPopUp(
                                        id: data['order_unique_number'],
                                        orderType: 'Order Delete',
                                      ),
                                    ).then((value) => onRefresh());
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: DynamicColor.primaryColor,
                                    child: Icon(Icons.close,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$currencySymbol${data['item'][0]['total_amount']}',
                                  style: greenColor15bold,
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

  Color _getStatusColor(dynamic data) {
    if (data['delivery_status'] == 'delivered') {
      return DynamicColor.green;
    } else if (data['status'] == 'pending') {
      return DynamicColor.primaryColor;
    } else if (data['status'] == 'accept') {
      return DynamicColor.green;
    } else {
      return DynamicColor.redColor;
    }
  }
}
