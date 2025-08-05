// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/add_comment_to%20oder_placed_popup.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../Comman widgets/app_bar/back_icon_appbar.dart';
// import '../../../Component/Strings/strings.dart';
//
// class CartListPage extends StatefulWidget {
//   const CartListPage({super.key});
//
//   @override
//   State<CartListPage> createState() => _CartListPageState();
// }
//
// class _CartListPageState extends State<CartListPage> {
//   int count = 0;
//
//   double totalPrice = 0.0;
//
//   dynamic checkItemLocal;
//
//   @override
//   void initState() {
//     super.initState();
//     getcartItemData();
//   }
//
//   void getcartItemData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       checkItemLocal = jsonDecode(prefs.getString('cart').toString());
//       countPrice();
//     });
//   }
//
//   void countPrice() {
//     setState(() {
//       if (checkItemLocal != null) {
//         totalPrice += checkItemLocal['total_price'];
//       }
//     });
//   }
//
//   void removecartItem() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.remove('cart').toString();
//
//       Utils().myToast(context, msg: 'Removed successfully');
//       Timer(const Duration(milliseconds: 600), () {
//         PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['cart']!)),
//       body: Padding(
//         padding: EdgeInsets.only(
//             left: SizeConfig.getSize10(context: context),
//             right: SizeConfig.getSize10(context: context)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             checkItemLocal != null
//                 ? cardListShow()
//                 : Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           top: SizeConfig.getSizeHeightBy(
//                               context: context, by: 0.25)),
//                       child: Text('No item available', style: primary13bold),
//                     ),
//                   ),
//             Container(
//               child: total(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget cardListShow() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Card(
//         color: DynamicColor.boxColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//                 flex: 2,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                       height: SizeConfig.getSizeHeightBy(
//                           context: context, by: 0.11),
//                       color: DynamicColor.black.withOpacity(0.3),
//                       child: CustomNetworkImage(
//                         url: checkItemLocal['dish_image'],
//                         fit: BoxFit.contain,
//                       )),
//                 )),
//             Expanded(
//                 flex: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8, top: 8),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //  const SizedBox(height: 8),
//                       Text(checkItemLocal['dish_name'],
//                           style: white17Bold,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis),
//                       Row(
//                         children: [
//                           Text('Initial Price: ',
//                               style: lightWhite14Bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                           Text(
//                               '$currencySymbol${checkItemLocal['dish_price'].toStringAsFixed(2).toString()}',
//                               style: primary15w5,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text('Total Price: ',
//                               style: lightWhite14Bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                           Text(
//                               //'$currencySymbol${checkItemLocal['total_price']}',
//                               '$currencySymbol${checkItemLocal['total_price'].toStringAsFixed(2).toString()}',
//                               style: greenColor15bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text('Qty: ',
//                               style: lightWhite14Bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                           Text('${checkItemLocal['quantity']}',
//                               style: lightWhite15Bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                         ],
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: InkWell(
//                           onTap: () {
//                             removecartItem();
//                           },
//                           child: Container(
//                             height: 20,
//                             width: 70,
//                             alignment: Alignment.center,
//                             margin: const EdgeInsets.only(bottom: 10, top: 5),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: DynamicColor.primaryColor,
//                             ),
//                             child: Text('Remove', style: white13w5),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )),
//             Expanded(
//                 child: Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 margin: const EdgeInsets.only(right: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 8),
//                     InkWell(
//                       onTap: () {
//                         if (checkItemLocal['quantity'] > 1) {
//                           setState(() {
//                             checkItemLocal['quantity']--;
//
//                             var s = checkItemLocal['total_price'] -
//                                 checkItemLocal['dish_price'];
//                             checkItemLocal['total_price'] = s;
//
//                             totalPrice -= checkItemLocal['dish_price'];
//                           });
//                         }
//                       },
//                       child: Container(
//                         height: 25,
//                         width: 30,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color: DynamicColor.primaryColor,
//                             borderRadius: BorderRadius.circular(8)),
//                         child: const Icon(
//                           Icons.remove,
//                           color: DynamicColor.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       checkItemLocal['quantity'].toString(),
//                       style: white17Bold,
//                     ),
//                     const SizedBox(height: 3),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           checkItemLocal['quantity']++;
//                           var s = checkItemLocal['total_price'] +
//                               checkItemLocal['dish_price'];
//                           checkItemLocal['total_price'] = s;
//                           totalPrice += checkItemLocal['dish_price'];
//                         });
//                       },
//                       child: Container(
//                         height: 25,
//                         width: 30,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color: DynamicColor.primaryColor,
//                             borderRadius: BorderRadius.circular(8)),
//                         child: const Icon(
//                           Icons.add,
//                           color: DynamicColor.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget total() {
//     return Card(
//       color: DynamicColor.boxColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Item:', style: white15bold),
//                 Text(checkItemLocal != null ? '1' : '0', style: white15bold),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Sub Total:', style: white15bold),
//                 Text(
//                     '$currencySymbol${totalPrice.toStringAsFixed(2).toString()}',
//                     style: white15bold),
//               ],
//             ),
//             const Divider(color: DynamicColor.white),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Total', style: white21bold),
//                 Text(
//                     '$currencySymbol${totalPrice.toStringAsFixed(2).toString()}',
//                     style: primary25bold),
//               ],
//             ),
//             const SizedBox(height: 40),
//             CommanButton(
//                 heroTag: 1,
//                 shap: 10.0,
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 buttonName: 'Pay & Get Order Number',
//                 onPressed: () {
//                   if (checkItemLocal != null) {
//                     showDialog(
//                         context: context,
//                         barrierDismissible: Platform.isAndroid ? false : true,
//                         builder: (context) => AddCommentToOrderForPlacedPopup(
//                             data: checkItemLocal));
//                   } else {
//                     Utils().myToast(context, msg: 'No Cart item available');
//                   }
//
//                   //   PageNavigateScreen().push(context, const MainHomePage());
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  Map<String, dynamic>? cartItem;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    loadCartItem();
  }

  void loadCartItem() {
    cartItem = {
      'dish_image': 'https://via.placeholder.com/150',
      'dish_name': 'Delicious Pasta',
      'dish_price': 12.5,
      'total_price': 25.0,
      'quantity': 2,
    };
    totalPrice = cartItem!['total_price'];
  }

  void removeCartItem() {
    setState(() {
      cartItem = null;
      totalPrice = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cartItem != null
                ? buildCartItem()
                : Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Text('No item available', style: primary13bold),
              ),
            ),
            buildTotalSection()
          ],
        ),
      ),
    );
  }

  Widget buildCartItem() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 100,
                color: DynamicColor.black.withOpacity(0.3),
                child: CustomNetworkImage(
                  url: cartItem!['dish_image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem!['dish_name'], style: white17Bold),
                  Text('Initial Price: \$${cartItem!['dish_price']}',
                      style: lightWhite14Bold),
                  Text('Total Price: \$${cartItem!['total_price']}',
                      style: greenColor15bold),
                  Text('Qty: ${cartItem!['quantity']}', style: white13w5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: removeCartItem,
                      child: Container(
                        height: 24,
                        width: 70,
                        margin: const EdgeInsets.only(top: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: DynamicColor.primaryColor,
                        ),
                        child: const Text('Remove',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          buildQtyButtons(),
        ],
      ),
    );
  }

  Widget buildQtyButtons() {
    return Column(
      children: [
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            if (cartItem!['quantity'] > 1) {
              setState(() {
                cartItem!['quantity']--;
                cartItem!['total_price'] -= cartItem!['dish_price'];
                totalPrice = cartItem!['total_price'];
              });
            }
          },
          child: buildQtyButton(Icons.remove),
        ),
        const SizedBox(height: 4),
        Text(cartItem!['quantity'].toString(), style: white17Bold),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            setState(() {
              cartItem!['quantity']++;
              cartItem!['total_price'] += cartItem!['dish_price'];
              totalPrice = cartItem!['total_price'];
            });
          },
          child: buildQtyButton(Icons.add),
        ),
      ],
    );
  }

  Widget buildQtyButton(IconData icon) {
    return Container(
      height: 25,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DynamicColor.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget buildTotalSection() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildTotalRow("Item:", cartItem != null ? "1" : "0"),
            const SizedBox(height: 10),
            buildTotalRow("Sub Total:", "\$${totalPrice.toStringAsFixed(2)}"),
            const Divider(color: Colors.white),
            buildTotalRow("Total", "\$${totalPrice.toStringAsFixed(2)}",
                bold: true),
            const SizedBox(height: 30),
            CommanButton(
              buttonName: "Pay & Get Order Number",
              width: MediaQuery.of(context).size.width * 0.7,
              shap: 10.0,
              onPressed: () {
                // No action – frontend only
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildTotalRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bold ? white21bold : white15bold),
        Text(value, style: bold ? primary25bold : white15bold),
      ],
    );
  }
}
