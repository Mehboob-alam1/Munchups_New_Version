// import 'package:flutter/material.dart';
// import 'package:munchups_app/Comman%20widgets/Custom%20Slider/custome_slider.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
//
// class GrocerItemDetailPage extends StatefulWidget {
//   dynamic userdata;
//   dynamic dishData;
//   GrocerItemDetailPage({
//     super.key,
//     this.userdata,
//     this.dishData,
//   });
//
//   @override
//   State<GrocerItemDetailPage> createState() => _GrocerItemDetailPageState();
// }
//
// class _GrocerItemDetailPageState extends State<GrocerItemDetailPage> {
//   bool isLoading = false;
//
//   List sliderImages = [];
//
//   dynamic dishData;
//   dynamic userData;
//   dynamic checkItemLocal;
//
//   @override
//   void initState() {
//     super.initState();
//     userData = widget.userdata;
//     dishData = widget.dishData;
//     if (dishData['dish_images'] != 'NA') {
//       for (var element in dishData['dish_images']) {
//         sliderImages.add(element['kitchen_image']);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: isLoading
//             ? const Center(
//                 child:
//                     CircularProgressIndicator(color: DynamicColor.primaryColor))
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     CustomSlider(list: sliderImages),
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(dishData['dish_name'],
//                                   style: white21bold,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                               Text('$currencySymbol${dishData['dish_price']}',
//                                   style: const TextStyle(
//                                     color: DynamicColor.green,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 height: 35,
//                                 padding:
//                                     const EdgeInsets.only(left: 8, right: 8),
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: DynamicColor.borderline),
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const Icon(Icons.star,
//                                         color: DynamicColor.primaryColor,
//                                         size: 18),
//                                     Text(
//                                         userData['avg_rating'] == null
//                                             ? '0'
//                                             : ' ${userData['avg_rating'].toString()}',
//                                         style: white13w5),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(color: DynamicColor.white),
//                           serviceTypeAndPerson(),
//                           const SizedBox(height: 5),
//                           Text('Item Description', style: primary17w6),
//                           const SizedBox(height: 10),
//                           Text(dishData['dish_description'])
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
//
//   Widget serviceTypeAndPerson() {
//     return Row(
//       children: [
//         Expanded(
//             child: SizedBox(
//           height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
//           child: Card(
//             color: DynamicColor.boxColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text('Phone No.',
//                       style: lightWhite14Bold, textAlign: TextAlign.center),
//                   const SizedBox(height: 5),
//                   Text(
//                       (userData['phone'] == null)
//                           ? 'No available'
//                           : formatMobileNumber(userData['phone']),
//                       style: primary15w5),
//                 ],
//               ),
//             ),
//           ),
//         )),
//         Expanded(
//             child: SizedBox(
//           height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
//           child: Card(
//             color: DynamicColor.boxColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text('Postal Code',
//                     style: lightWhite14Bold, textAlign: TextAlign.center),
//                 const SizedBox(height: 5),
//                 Text(
//                   (userData['postal_code'] == null)
//                       ? 'No available'
//                       : userData['postal_code'],
//                   style: primary15w5,
//                 )
//               ],
//             ),
//           ),
//         )),
//         Expanded(
//             child: SizedBox(
//           height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
//           child: Card(
//             color: DynamicColor.boxColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text('Service Type',
//                     style: lightWhite14Bold, textAlign: TextAlign.center),
//                 const SizedBox(height: 5),
//                 Text(
//                   dishData['service_type'] == null
//                       ? 'No available'
//                       : dishData['service_type'].toString().toUpperCase(),
//                   style: primary15w5,
//                 )
//               ],
//             ),
//           ),
//         )),
//       ],
//     );
//   }
//
//   String formatMobileNumber(String mobileNumber) {
//     if (mobileNumber.length < 2) {
//       return mobileNumber;
//     }
//     String lastTwoDigits = mobileNumber.substring(mobileNumber.length - 2);
//     String maskedDigits = 'X' * (mobileNumber.length - 2);
//     return '$maskedDigits$lastTwoDigits';
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Custom%20Slider/custome_slider.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

import 'package:munchups_app/models/dish_model.dart';
import 'package:munchups_app/models/user_model.dart';

class GrocerItemDetailPage extends StatelessWidget {
  final UserModel user;
  final DishModel dish;

  const GrocerItemDetailPage({
    super.key,
    required this.user,
    required this.dish,
  });

  String formatMobileNumber(String mobileNumber) {
    if (mobileNumber.length < 2) return mobileNumber;
    return 'X' * (mobileNumber.length - 2) +
        mobileNumber.substring(mobileNumber.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomSlider(list: dish.images),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dish.name,
                            style: white21bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text('$currencySymbol${dish.price}',
                            style: const TextStyle(
                              color: DynamicColor.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColor.borderline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: DynamicColor.primaryColor, size: 18),
                          Text(user.avgRating?.toString() ?? '0',
                              style: white13w5),
                        ],
                      ),
                    ),
                    const Divider(color: DynamicColor.white),
                    _buildServiceCards(context),
                    const SizedBox(height: 5),
                    Text('Item Description', style: primary17w6),
                    const SizedBox(height: 10),
                    Text(dish.description ?? 'No description available'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCards(BuildContext context) {
    return Row(
      children: [
        _infoCard('Phone No.',
            user.phone != null ? formatMobileNumber(user.phone!) : 'Not available'),
        _infoCard('Postal Code', user.postalCode ?? 'Not available'),
        _infoCard('Service Type',
            dish.serviceType?.toUpperCase() ?? 'Not available'),
      ],
    );
  }

  Widget _infoCard(String title, String value) {
    return Expanded(
      child: SizedBox(
        height: SizeConfig.getSizeHeightBy(context: context, by: 0.12),
        child: Card(
          color: DynamicColor.boxColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: lightWhite14Bold, textAlign: TextAlign.center),
                  const SizedBox(height: 5),
                  Text(value,
                      style: primary15w5, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
