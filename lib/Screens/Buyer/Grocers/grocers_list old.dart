// import 'package:flutter/material.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Screens/Buyer/Chefs/detail_page.dart';

// import '../../../Comman widgets/add_to_card.dart';
// import '../../../Component/navigatepage/navigate_page.dart';

// class GrocersListPage extends StatefulWidget {
//   const GrocersListPage({super.key});

//   @override
//   State<GrocersListPage> createState() => _GrocersListPageState();
// }

// class _GrocersListPageState extends State<GrocersListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: SizeConfig.getSize20(context: context)),
//       child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: MediaQuery.of(context).size.width /
//                   (MediaQuery.of(context).size.height * 0.80)),
//           itemCount: 2,
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 PageNavigateScreen().push(context, const DetailPage());
//               },
//               child: Card(
//                 color: DynamicColor.boxColor,
//                 child: Column(
//                   children: [
//                     Expanded(
//                         child: Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: SizedBox(
//                         height: SizeConfig.getSizeHeightBy(
//                             context: context, by: 0.1),
//                         width: SizeConfig.getSizeWidthBy(
//                             context: context, by: 0.42),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: CustomNetworkImage(
//                               url:
//                                   'https://c.ndtvimg.com/2022-03/jcliv9dg_shahi-paneer_625x300_15_March_22.jpg?im=FaceCrop,algorithm=dnn,width=1200,height=886'),
//                         ),
//                       ),
//                     )),
//                     Expanded(
//                         child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Sahi Paneer',
//                               style: white14w5,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                           Text('$currencySymbol120',
//                               style: greenColor15bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis),
//                           AddToCardWidget(index: index),
//                           const Divider(
//                             height: 0,
//                             thickness: 1,
//                             color: DynamicColor.lightBlack,
//                           ),
//                           ListTile(
//                             contentPadding: EdgeInsets.zero,
//                             minLeadingWidth: 0.0,
//                             horizontalTitleGap: 5.0,
//                             minVerticalPadding: 5.0,
//                             dense: true,
//                             leading: CircleAvatar(
//                               radius: 20,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: CustomNetworkImage(
//                                     url:
//                                         'https://preview.keenthemes.com/metronic-v4/theme_rtl/assets/pages/media/profile/profile_user.jpg'),
//                               ),
//                             ),
//                             title: Text(
//                               'Kamal Kumar',
//                               style: white15bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             subtitle: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text('2.5', style: white13w5),
//                                     const SizedBox(width: 2),
//                                     const Icon(
//                                       Icons.star,
//                                       color: Colors.orange,
//                                       size: 15,
//                                     ),
//                                   ],
//                                 ),
//                                 Text('450 Miles', style: white13w5),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ))
//                   ],
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
