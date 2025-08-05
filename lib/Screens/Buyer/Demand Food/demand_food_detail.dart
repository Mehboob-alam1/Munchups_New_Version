// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/make_payment_popup.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/reject_order_popup.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/proposal_list_model.dart';
//
// class DemandFoodOrderDetailPage extends StatefulWidget {
//   ProposalOcCategoryOrderArr data;
//
//   DemandFoodOrderDetailPage({
//     super.key,
//     required this.data,
//   });
//
//   @override
//   State<DemandFoodOrderDetailPage> createState() =>
//       _DemandFoodOrderDetailPageState();
// }
//
// class _DemandFoodOrderDetailPageState extends State<DemandFoodOrderDetailPage> {
//   late ProposalOcCategoryOrderArr data;
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
//           child: BackIconCustomAppBar(title: 'Proposal Details')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(
//               left: SizeConfig.getSize20(context: context),
//               right: SizeConfig.getSize20(context: context)),
//           child: Column(
//             children: [
//               SizedBox(height: SizeConfig.getSize20(context: context)),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       children: [
//                         Text('Order ID', style: white17Bold),
//                         Text(data.foodId.toString(), style: white17Bold),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         Text('Order Status', style: white17Bold),
//                         const Text('ACCEPT',
//                             style: TextStyle(
//                                 fontSize: 17.0,
//                                 color: DynamicColor.green,
//                                 fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ]),
//               SizedBox(height: SizeConfig.getSize20(context: context)),
//               orderDetail(),
//               chefDetail(),
//               SizedBox(height: SizeConfig.getSize30(context: context)),
//               CommanButton(
//                   heroTag: 1,
//                   shap: 10.0,
//                   hight: 35.0,
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   buttonName: 'Make Payment To Accept',
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         barrierDismissible: Platform.isAndroid ? false : true,
//                         builder: (context) => MakePaymentToAcceptPopup(
//                               proposalId: data.proposalId.toString(),
//                             ));
//                   }),
//               SizedBox(height: SizeConfig.getSize30(context: context)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   CommanButton(
//                       heroTag: 2,
//                       shap: 10.0,
//                       hight: 35.0,
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       buttonName: 'Reject',
//                       onPressed: () {
//                         showDialog(
//                             context: context,
//                             barrierDismissible:
//                                 Platform.isAndroid ? false : true,
//                             builder: (context) => RejectOrderPopup(
//                                   proposalID: data.proposalId.toString(),
//                                 ));
//                       }),
//                   CommanButton(
//                       heroTag: 3,
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
//                 title: 'Location',
//                 value: formatAddress(data.location),
//               ),
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
//                 child: Text('Chef Detail', style: primary17w6)),
//           ),
//           customWidget(
//               title: 'Chef Name', value: '${data.firstName} ${data.lastName}'),
//           customWidget(title: 'Chef Email', value: data.emailId),
//           customWidget(
//               title: 'Chef Address', value: formatAddress(data.location)),
//           customWidget(
//               title: 'Chef Phone No',
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
//         children: [
//           Expanded(child: Text('$title: ', style: white14w5)),
//           Expanded(flex: 3, child: Text(value, style: greenColor15bold))
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

// Mock data class for UI demo
class ProposalOcCategoryOrderArr {
  final String foodId;
  final String proposalId;
  final String occasionCategoryName;
  final String noOfPeople;
  final String foodCateName;
  final String serviceType;
  final String budget;
  final String startDate;
  final String endDate;
  final String occasionTime;
  final String location;
  final String postalCode;
  final String description;
  final String firstName;
  final String lastName;
  final String emailId;
  final String phone;

  ProposalOcCategoryOrderArr({
    required this.foodId,
    required this.proposalId,
    required this.occasionCategoryName,
    required this.noOfPeople,
    required this.foodCateName,
    required this.serviceType,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.occasionTime,
    required this.location,
    required this.postalCode,
    required this.description,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.phone,
  });
}

class DemandFoodOrderDetailPage extends StatefulWidget {
  final ProposalOcCategoryOrderArr data;

  const DemandFoodOrderDetailPage({super.key, required this.data});

  @override
  State<DemandFoodOrderDetailPage> createState() =>
      _DemandFoodOrderDetailPageState();
}

class _DemandFoodOrderDetailPageState extends State<DemandFoodOrderDetailPage> {
  late ProposalOcCategoryOrderArr data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Proposal Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getSize20(context: context),
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getSize20(context: context)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Order ID', style: white17Bold),
                        Text(data.foodId, style: white17Bold),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Order Status', style: white17Bold),
                        const Text('ACCEPT',
                            style: TextStyle(
                                fontSize: 17.0,
                                color: DynamicColor.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ]),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              orderDetail(),
              chefDetail(),
              SizedBox(height: SizeConfig.getSize30(context: context)),
              CommanButton(
                heroTag: 1,
                shap: 10.0,
                hight: 35.0,
                width: MediaQuery.of(context).size.width * 0.7,
                buttonName: 'Make Payment To Accept',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment popup removed")),
                  );
                },
              ),
              SizedBox(height: SizeConfig.getSize30(context: context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommanButton(
                    heroTag: 2,
                    shap: 10.0,
                    hight: 35.0,
                    width: MediaQuery.of(context).size.width * 0.3,
                    buttonName: 'Reject',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Reject popup removed")),
                      );
                    },
                  ),
                  CommanButton(
                    heroTag: 3,
                    shap: 10.0,
                    hight: 35.0,
                    width: MediaQuery.of(context).size.width * 0.3,
                    buttonName: 'CALL',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Calling feature removed"),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.getSize20(context: context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderDetail() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Order Detail', style: primary17w6),
            ),
            SizedBox(height: 10),
            customWidget(title: 'Occasion', value: data.occasionCategoryName),
            customWidget(title: 'Number Of People', value: data.noOfPeople),
            customWidget(title: 'Food Category', value: data.foodCateName),
            customWidget(title: 'Service Type', value: data.serviceType),
            customWidget(title: 'Budget', value: '\$${data.budget}'),
            customWidget(
              title: 'Date',
              value: '${data.startDate} - ${data.endDate}',
            ),
            customWidget(title: 'Time', value: data.occasionTime),
            customWidget(title: 'Location', value: data.location),
            customWidget(title: 'Postal Code', value: data.postalCode),
            customWidget(title: 'Note', value: data.description),
          ],
        ),
      ),
    );
  }

  Widget chefDetail() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Text('Chef Detail', style: primary17w6)),
            SizedBox(height: 10),
            customWidget(
                title: 'Chef Name',
                value: '${data.firstName} ${data.lastName}'),
            customWidget(title: 'Chef Email', value: data.emailId),
            customWidget(title: 'Chef Address', value: data.location),
            customWidget(title: 'Chef Phone No', value: data.phone),
          ],
        ),
      ),
    );
  }

  Widget customWidget({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Row(
        children: [
          Expanded(child: Text('$title: ', style: white14w5)),
          Expanded(flex: 3, child: Text(value, style: greenColor15bold))
        ],
      ),
    );
  }
}
