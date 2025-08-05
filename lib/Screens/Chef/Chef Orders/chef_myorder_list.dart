// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/accept_reject_complete_order_popup.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Screens/Buyer/My%20Orders/order_detail.dart';
//
// class ChefOrderList extends StatefulWidget {
//   const ChefOrderList({super.key});
//
//   @override
//   State<ChefOrderList> createState() => _ChefOrderListState();
// }
//
// class _ChefOrderListState extends State<ChefOrderList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['my_order']!)),
//       body: FutureBuilder(
//           future: GetApiServer().myChefOrderListApi(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return const Center(
//                     child: CircularProgressIndicator(
//                   color: DynamicColor.primaryColor,
//                 ));
//               default:
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('No orders available'));
//                 } else if (snapshot.data['success'] != 'true') {
//                   return const Center(child: Text('No orders available'));
//                 } else if (snapshot.data!['data'] == 'NA') {
//                   return const Center(child: Text('No orders available'));
//                 } else {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         primary: false,
//                         itemCount: snapshot.data['data'].length,
//                         itemBuilder: (context, index) {
//                           dynamic data = snapshot.data['data'][index];
//                           return Card(
//                             color: DynamicColor.boxColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Column(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     PageNavigateScreen().push(
//                                         context,
//                                         OrderDetailPage(
//                                           data: data,
//                                           userType: 'Chef',
//                                         ));
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Expanded(
//                                           child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(10),
//                                         child: Container(
//                                           height: SizeConfig.getSizeHeightBy(
//                                               context: context, by: 0.1),
//                                           color: DynamicColor.black
//                                               .withOpacity(0.3),
//                                           child: CustomNetworkImage(
//                                             url: data['item'][0]
//                                                         ['dish_images'] ==
//                                                     'NA'
//                                                 ? ""
//                                                 : data['item'][0]['dish_images']
//                                                     [0]['kitchen_image'],
//                                             fit: BoxFit.contain,
//                                           ),
//                                         ),
//                                       )),
//                                       Expanded(
//                                           flex: 2,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 8.0),
//                                             child: Stack(
//                                               children: [
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const SizedBox(height: 5),
//                                                     Text(
//                                                         data['item'][0]['name'],
//                                                         style: white17Bold,
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis),
//                                                     const SizedBox(height: 3),
//                                                     Text(
//                                                         'Order ID: ${data['order_unique_number']}',
//                                                         style: white14w5,
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis),
//                                                     const SizedBox(height: 3),
//                                                     Text(
//                                                         'Ouantity: ${data['item'][0]['quantity']}',
//                                                         style: white14w5,
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis),
//                                                     const SizedBox(height: 3),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text('Status: ',
//                                                             style: white14w5,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                         Text(
//                                                             data['delivery_status'] ==
//                                                                     'delivered'
//                                                                 ? data['delivery_status']
//                                                                     .toString()
//                                                                     .toUpperCase()
//                                                                 : data['status']
//                                                                     .toString()
//                                                                     .toUpperCase(),
//                                                             style: TextStyle(
//                                                                 fontSize: 14.0,
//                                                                 color: data['delivery_status'] ==
//                                                                         'delivered'
//                                                                     ? DynamicColor
//                                                                         .green
//                                                                     : data['status'] ==
//                                                                             'pending'
//                                                                         ? DynamicColor
//                                                                             .primaryColor
//                                                                         : data['status'] ==
//                                                                                 'accept'
//                                                                             ? DynamicColor
//                                                                                 .green
//                                                                             : DynamicColor
//                                                                                 .redColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 3),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment:
//                                                         Alignment.topRight,
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment.end,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .end,
//                                                       children: [
//                                                         InkWell(
//                                                           onTap: () {
//                                                             showDialog(
//                                                                 context:
//                                                                     context,
//                                                                 barrierDismissible:
//                                                                     Platform.isAndroid
//                                                                         ? false
//                                                                         : true,
//                                                                 builder:
//                                                                     (context) =>
//                                                                         DeleteOrderPopUp(
//                                                                           id: data[
//                                                                               'order_unique_number'],
//                                                                           orderType:
//                                                                               'Order Delete',
//                                                                         )).then(
//                                                                 (value) {
//                                                               setState(() {});
//                                                             });
//                                                           },
//                                                           child:
//                                                               const CircleAvatar(
//                                                                   radius: 12,
//                                                                   backgroundColor:
//                                                                       DynamicColor
//                                                                           .primaryColor,
//                                                                   child: Icon(
//                                                                     Icons.close,
//                                                                     color: DynamicColor
//                                                                         .white,
//                                                                     size: 20,
//                                                                   )),
//                                                         ),
//                                                         const SizedBox(
//                                                             height: 10),
//                                                         Text(
//                                                             '$currencySymbol${data['item'][0]['total_amount']}',
//                                                             style:
//                                                                 greenColor15bold,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ))
//                                     ],
//                                   ),
//                                 ),
//                                 const Divider(color: DynamicColor.grey300),
//                                 SizedBox(
//                                     height:
//                                         SizeConfig.getSize20(context: context)),
//                                 data['status'] == 'pending'
//                                     ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           CommanButton(
//                                               heroTag: index + 1,
//                                               shap: 10.0,
//                                               hight: 35.0,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.25,
//                                               textSize: 15.0,
//                                               buttonBGColor: DynamicColor.green,
//                                               buttonName: 'Accept',
//                                               onPressed: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     barrierDismissible:
//                                                         Platform.isAndroid
//                                                             ? false
//                                                             : true,
//                                                     builder: (context) =>
//                                                         AcceptRejectCompleteOrderPopup(
//                                                             title: 'accept',
//                                                             orderID: data[
//                                                                     'order_id']
//                                                                 .toString(),
//                                                             buyerID:
//                                                                 data['buyer_id']
//                                                                     .toString(),
//                                                             amount: data['item']
//                                                                         [0][
//                                                                     'total_amount']
//                                                                 .toString(),
//                                                             status:
//                                                                 'accept')).then(
//                                                   (value) {
//                                                     setState(() {});
//                                                   },
//                                                 );
//                                               }),
//                                           CommanButton(
//                                               heroTag: index + 2,
//                                               shap: 10.0,
//                                               hight: 35.0,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.25,
//                                               textSize: 15.0,
//                                               buttonBGColor: Colors.red,
//                                               buttonName: 'Decline',
//                                               onPressed: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     barrierDismissible:
//                                                         Platform.isAndroid
//                                                             ? false
//                                                             : true,
//                                                     builder: (context) =>
//                                                         AcceptRejectCompleteOrderPopup(
//                                                           title: 'decline',
//                                                           orderID:
//                                                               data['order_id']
//                                                                   .toString(),
//                                                           buyerID:
//                                                               data['buyer_id']
//                                                                   .toString(),
//                                                           amount: data['item']
//                                                                       [0][
//                                                                   'total_amount']
//                                                               .toString(),
//                                                           status: 'decline',
//                                                         )).then(
//                                                   (value) {
//                                                     setState(() {});
//                                                   },
//                                                 );
//                                               })
//                                         ],
//                                       )
//                                     : data['status'] == 'decline'
//                                         ? Container(
//                                             height: 30,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               border: Border.all(
//                                                   color: DynamicColor.redColor),
//                                             ),
//                                             child: const Text('Declined',
//                                                 style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 16,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           )
//                                         : data['delivery_status'] == 'delivered'
//                                             ? Container(
//                                                 height: 30,
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.3,
//                                                 alignment: Alignment.center,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                   border: Border.all(
//                                                       color: Colors.green),
//                                                 ),
//                                                 child: const Text('Completed',
//                                                     style: TextStyle(
//                                                         color:
//                                                             DynamicColor.green,
//                                                         fontSize: 16,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                               )
//                                             : CommanButton(
//                                                 heroTag: index + 1,
//                                                 shap: 10.0,
//                                                 hight: 35.0,
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.30,
//                                                 textSize: 15.0,
//                                                 buttonBGColor:
//                                                     DynamicColor.green,
//                                                 buttonName: 'Complete',
//                                                 onPressed: () {
//                                                   showDialog(
//                                                       context: context,
//                                                       barrierDismissible:
//                                                           Platform.isAndroid
//                                                               ? false
//                                                               : true,
//                                                       builder: (context) =>
//                                                           AcceptRejectCompleteOrderPopup(
//                                                             title: 'complete',
//                                                             orderID:
//                                                                 data['order_id']
//                                                                     .toString(),
//                                                             buyerID:
//                                                                 data['buyer_id']
//                                                                     .toString(),
//                                                             amount: data['item']
//                                                                         [0][
//                                                                     'total_amount']
//                                                                 .toString(),
//                                                             status: 'complete',
//                                                             data: data,
//                                                           ));
//                                                 }),
//                                 SizedBox(
//                                     height:
//                                         SizeConfig.getSize20(context: context)),
//                               ],
//                             ),
//                           );
//                         }),
//                   );
//                 }
//             }
//           }),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/accept_reject_complete_order_popup.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/order_detail.dart';

class ChefOrderList extends StatefulWidget {
  const ChefOrderList({super.key});

  @override
  State<ChefOrderList> createState() => _ChefOrderListState();
}

class _ChefOrderListState extends State<ChefOrderList> {
  // Sample static data
  final List<Map<String, dynamic>> sampleOrders = [
    {
      "order_id": "001",
      "order_unique_number": "ORD123456",
      "buyer_id": "B001",
      "status": "pending", // Options: pending, accept, decline
      "delivery_status": "",
      "item": [
        {
          "name": "Spicy Chicken Curry",
          "quantity": "2",
          "total_amount": "300",
          "dish_images": [
            {"kitchen_image": ""}
          ]
        }
      ]
    },
    {
      "order_id": "002",
      "order_unique_number": "ORD123457",
      "buyer_id": "B002",
      "status": "accept",
      "delivery_status": "delivered",
      "item": [
        {
          "name": "Paneer Butter Masala",
          "quantity": "1",
          "total_amount": "150",
          "dish_images": [
            {"kitchen_image": ""}
          ]
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: BackIconCustomAppBar(title: 'My Orders'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: sampleOrders.length,
        itemBuilder: (context, index) {
          final data = sampleOrders[index];

          return Card(
            color: DynamicColor.boxColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    PageNavigateScreen().push(
                      context,
                      OrderDetailPage(data: data, userType: 'Chef'),
                    );
                  },
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
                            child:  CustomNetworkImage(
                              url: '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    data['item'][0]['name'],
                                    style: white17Bold,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Order ID: ${data['order_unique_number']}',
                                    style: white14w5,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Quantity: ${data['item'][0]['quantity']}',
                                    style: white14w5,
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Text('Status: ', style: white14w5),
                                      Text(
                                        data['delivery_status'] == 'delivered'
                                            ? 'DELIVERED'
                                            : data['status'].toString().toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: data['delivery_status'] == 'delivered'
                                              ? DynamicColor.green
                                              : data['status'] == 'pending'
                                              ? DynamicColor.primaryColor
                                              : data['status'] == 'accept'
                                              ? DynamicColor.green
                                              : DynamicColor.redColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                          DeleteOrderPopUp(
                                            id: 'dummy_id',
                                            orderType: 'Order Delete',
                                          ),
                                        );
                                      },
                                      child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor:
                                        DynamicColor.primaryColor,
                                        child: Icon(Icons.close,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '₹${data['item'][0]['total_amount']}',
                                      style: greenColor15bold,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(color: DynamicColor.grey300),
                const SizedBox(height: 10),
                _buildStatusActions(context, data, index),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusActions(
      BuildContext context, Map<String, dynamic> data, int index) {
    if (data['status'] == 'pending') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommanButton(
            heroTag: 'accept_$index',
            shap: 10.0,
            hight: 35.0,
            width: MediaQuery.of(context).size.width * 0.25,
            textSize: 15.0,
            buttonBGColor: DynamicColor.green,
            buttonName: 'Accept',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>  AcceptRejectCompleteOrderPopup(
                  title: 'accept',
                  orderID: '001',
                  buyerID: 'B001',
                  amount: '300',
                  status: 'accept',
                ),
              );
            },
          ),
          CommanButton(
            heroTag: 'decline_$index',
            shap: 10.0,
            hight: 35.0,
            width: MediaQuery.of(context).size.width * 0.25,
            textSize: 15.0,
            buttonBGColor: Colors.red,
            buttonName: 'Decline',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>  AcceptRejectCompleteOrderPopup(
                  title: 'decline',
                  orderID: '001',
                  buyerID: 'B001',
                  amount: '300',
                  status: 'decline',
                ),
              );
            },
          ),
        ],
      );
    } else if (data['status'] == 'decline') {
      return _statusTag('Declined', DynamicColor.redColor);
    } else if (data['delivery_status'] == 'delivered') {
      return _statusTag('Completed', DynamicColor.green);
    } else {
      return CommanButton(
        heroTag: 'complete_$index',
        shap: 10.0,
        hight: 35.0,
        width: MediaQuery.of(context).size.width * 0.30,
        textSize: 15.0,
        buttonBGColor: DynamicColor.green,
        buttonName: 'Complete',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AcceptRejectCompleteOrderPopup(
              title: 'complete',
              orderID: '001',
              buyerID: 'B001',
              amount: '300',
              status: 'complete',
              data: {},
            ),
          );
        },
      );
    }
  }

  Widget _statusTag(String title, Color color) {
    return Container(
      height: 30,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color),
      ),
      child: Text(title,
          style: TextStyle(
              color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
