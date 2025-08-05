// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/change_orderstatus_chef_popup.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Chef/Home/home_model.dart';
//
// class HomeOrderDetailPage extends StatefulWidget {
//   OcCategoryOrderArr data;
//
//   HomeOrderDetailPage({
//     super.key,
//     required this.data,
//   });
//
//   @override
//   State<HomeOrderDetailPage> createState() => _HomeOrderDetailPageState();
// }
//
// class _HomeOrderDetailPageState extends State<HomeOrderDetailPage> {
//   late OcCategoryOrderArr data;
//
//   @override
//   void initState() {
//     super.initState();
//     data = widget.data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: 'Order Details')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(
//               left: SizeConfig.getSize20(context: context),
//               right: SizeConfig.getSize20(context: context)),
//           child: Column(
//             children: [
//               SizedBox(height: SizeConfig.getSize20(context: context)),
//               // Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //     crossAxisAlignment: CrossAxisAlignment.center,
//               //     children: [
//               //       Column(
//               //         children: [
//               //           Text('Order ID', style: white17Bold),
//               //           Text(data.foodId.toString(), style: white17Bold),
//               //         ],
//               //       ),
//               //       Column(
//               //         children: [
//               //           Text('Order Status', style: white17Bold),
//               //           const Text('ACTIVE',
//               //               style: TextStyle(
//               //                   fontSize: 17.0,
//               //                   color: DynamicColor.green,
//               //                   fontWeight: FontWeight.bold)),
//               //         ],
//               //       ),
//               //     ]),
//               SizedBox(height: SizeConfig.getSize20(context: context)),
//               orderDetail(),
//               chefDetail(),
//               SizedBox(height: SizeConfig.getSize30(context: context)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   data.proposalStatus == 'NA'
//                       ? CommanButton(
//                           heroTag: 1,
//                           shap: 10.0,
//                           hight: 35.0,
//                           width: MediaQuery.of(context).size.width * 0.3,
//                           buttonName: 'Accept',
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 barrierDismissible:
//                                     Platform.isAndroid ? false : true,
//                                 builder: (context) => ChnageOrderStatusPopup(
//                                       data: data,
//                                       name: 'Accept',
//                                     ));
//                           })
//                       : data.proposalStatus == 'accept'
//                           ? CommanButton(
//                               heroTag: 1,
//                               shap: 10.0,
//                               hight: 35.0,
//                               width: MediaQuery.of(context).size.width * 0.3,
//                               buttonName: 'Revoke',
//                               onPressed: () {
//                                 showDialog(
//                                     context: context,
//                                     barrierDismissible:
//                                         Platform.isAndroid ? false : true,
//                                     builder: (context) =>
//                                         ChnageOrderStatusPopup(
//                                           data: data,
//                                           name: 'Revoke',
//                                         ));
//                               })
//                           : Container(),
//                   CommanButton(
//                       heroTag: 2,
//                       shap: 10.0,
//                       hight: 35.0,
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       buttonName: 'CALL',
//                       onPressed: () {
//                         Utils.launchUrls('tel:${data.phone}', context);
//                       })
//                 ],
//               ),
//               SizedBox(height: SizeConfig.getSize20(context: context)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget orderDetail() {
//     return Card(
//       color: DynamicColor.boxColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10, bottom: 10),
//             child: Align(
//                 alignment: Alignment.center,
//                 child: Text('Order Detail', style: primary17w6)),
//           ),
//           Column(
//             children: [
//               customWidget(
//                   title: 'Occassion', value: data.occasionCategoryName),
//               customWidget(title: 'Number Of People', value: data.noOfPeople),
//               customWidget(title: 'Food Category', value: data.foodCateName),
//               customWidget(title: 'Service Type', value: data.serviceType),
//               customWidget(
//                   title: 'Budget', value: '$currencySymbol${data.budget}'),
//               customWidget(
//                   title: 'Date', value: '${data.startDate} - ${data.endDate}'),
//               customWidget(title: 'Time', value: data.occasionTime),
//               customWidget(
//                   title: 'Location', value: formatAddress(data.location)),
//               customWidget(title: 'Postal Code', value: data.postalCode),
//               customWidget(title: 'Note', value: data.description),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget chefDetail() {
//     return Card(
//       color: DynamicColor.boxColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10, bottom: 10),
//             child: Align(
//                 alignment: Alignment.center,
//                 child: Text('Buyer Detail', style: primary17w6)),
//           ),
//           customWidget(
//               title: 'Buyer Name', value: '${data.firstName} ${data.lastName}'),
//           customWidget(title: 'Buyer Email', value: data.emailId),
//           customWidget(
//               title: 'Buyer Address', value: formatAddress(data.location)),
//           customWidget(
//               title: 'Buyer Phone No',
//               value: data.phone == 'null' && data.phone == 'NA'
//                   ? 'Not available'
//                   : formatMobileNumber(data.phone)),
//         ],
//       ),
//     );
//   }
//
//   Widget customWidget({required String title, required String value}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10, left: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: Text('$title: ', style: white14w5)),
//           Expanded(
//               flex: 3,
//               child: Text(
//                 value,
//                 style: greenColor15bold,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               )),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Chef/Home/home_model.dart';

class HomeOrderDetailPage extends StatefulWidget {
  const HomeOrderDetailPage({super.key, required OcCategoryOrderArr data});

  @override
  State<HomeOrderDetailPage> createState() => _HomeOrderDetailPageState();
}

class _HomeOrderDetailPageState extends State<HomeOrderDetailPage> {
  final Map<String, dynamic> dummyData = {
    "occasionCategoryName": "Birthday Party",
    "noOfPeople": "25",
    "foodCateName": "Continental",
    "serviceType": "Buffet",
    "budget": "500",
    "startDate": "2025-08-20",
    "endDate": "2025-08-20",
    "occasionTime": "6:00 PM - 10:00 PM",
    "location": "123 Main St, Springfield",
    "postalCode": "123456",
    "description": "Need a themed cake and finger foods.",
    "firstName": "John",
    "lastName": "Doe",
    "emailId": "john.doe@example.com",
    "phone": "9876543210",
    "proposalStatus": "NA", // Can be: NA, accept
  };

  get actioned => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getSize20(context: context),
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getSize20(context: context)),
              orderDetail(),
              buyerDetail(),
              SizedBox(height: SizeConfig.getSize30(context: context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (dummyData["proposalStatus"] == 'NA')
                    CommanButton(
                      heroTag: 1,
                      shap: 10.0,
                      hight: 35.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      buttonName: 'Accept',
                      onPressed: () {
                        _showDialog('Accept');
                      },
                    )
                  else if (dummyData["proposalStatus"] == 'accept')
                    CommanButton(
                      heroTag: 1,
                      shap: 10.0,
                      hight: 35.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      buttonName: 'Revoke',
                      onPressed: () {
                        _showDialog('Revoke');
                      },
                    ),
                  CommanButton(
                    heroTag: 2,
                    shap: 10.0,
                    hight: 35.0,
                    width: MediaQuery.of(context).size.width * 0.3,
                    buttonName: 'CALL',
                    onPressed: () {
                      Utils.launchUrls('tel:${dummyData["phone"]}', context);
                    },
                  )
                ],
              ),
              SizedBox(height: SizeConfig.getSize20(context: context)),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: 'Order Details'),
      ),
    );
  }

  Widget orderDetail() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text('Order Detail', style: primary17w6),
            ),
          ),
          customWidget(title: 'Occasion', value: dummyData["occasionCategoryName"]),
          customWidget(title: 'Number Of People', value: dummyData["noOfPeople"]),
          customWidget(title: 'Food Category', value: dummyData["foodCateName"]),
          customWidget(title: 'Service Type', value: dummyData["serviceType"]),
          customWidget(title: 'Budget', value: '\$${dummyData["budget"]}'),
          customWidget(title: 'Date', value: '${dummyData["startDate"]} - ${dummyData["endDate"]}'),
          customWidget(title: 'Time', value: dummyData["occasionTime"]),
          customWidget(title: 'Location', value: dummyData["location"]),
          customWidget(title: 'Postal Code', value: dummyData["postalCode"]),
          customWidget(title: 'Note', value: dummyData["description"]),
        ],
      ),
    );
  }

  Widget buyerDetail() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text('Buyer Detail', style: primary17w6),
            ),
          ),
          customWidget(
              title: 'Buyer Name',
              value: '${dummyData["firstName"]} ${dummyData["lastName"]}'),
          customWidget(title: 'Buyer Email', value: dummyData["emailId"]),
          customWidget(title: 'Buyer Address', value: dummyData["location"]),
          customWidget(
              title: 'Buyer Phone No',
              value: dummyData["phone"] == 'null' || dummyData["phone"] == 'NA'
                  ? 'Not available'
                  : dummyData["phone"]),
        ],
      ),
    );
  }

  Widget customWidget({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('$title:', style: white14w5)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: greenColor15bold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Order'),
        content: Text('Are you sure you want to $action this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order $actioned')),
              );
            },
            child: Text(action),
          )
        ],
      ),
    );
  }
}
