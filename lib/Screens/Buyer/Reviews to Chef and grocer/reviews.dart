// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/custom_network_image.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
//
// class ReviewsToChefAndGrocer extends StatefulWidget {
//   dynamic data;
//   dynamic totalRating;
//   ReviewsToChefAndGrocer({
//     super.key,
//     this.data,
//     this.totalRating,
//   });
//
//   @override
//   State<ReviewsToChefAndGrocer> createState() => _ReviewsToChefAndGrocerState();
// }
//
// class _ReviewsToChefAndGrocerState extends State<ReviewsToChefAndGrocer> {
//   int totalRating = 0;
//   List allReviews = [];
//
//   @override
//   void initState() {
//     super.initState();
//     checkData();
//   }
//
//   void checkData() {
//     if (widget.data != 'NA') {
//       allReviews = widget.data;
//     }
//     if (widget.totalRating != 0) {
//       totalRating = widget.totalRating;
//     }
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: BackIconCustomAppBar(title: TextStrings.textKey['reviews']!)),
//       body: Padding(
//         padding: EdgeInsets.only(
//             left: SizeConfig.getSize10(context: context),
//             right: SizeConfig.getSize10(context: context)),
//         child: Column(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     top: SizeConfig.getSize20(context: context)),
//                 child: RatingBar.builder(
//                   initialRating: double.parse(totalRating.toString()),
//                   minRating: 1,
//                   direction: Axis.horizontal,
//                   allowHalfRating: false,
//                   tapOnlyMode: false,
//                   ignoreGestures: true,
//                   itemCount: 5,
//                   itemSize: 40.0,
//                   itemBuilder: (context, _) => const Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                   ),
//                   onRatingUpdate: (rating) {
//                     setState(() {
//                       //  _rating = rating;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             Expanded(
//                 flex: 8,
//                 child: allReviews.isEmpty
//                     ? const Center(
//                         child: Text('No reviews available'),
//                       )
//                     : ListView.builder(
//                         itemCount: allReviews.length,
//                         itemBuilder: (context, index) {
//                           dynamic data = allReviews[index];
//
//                           return Card(
//                             elevation: 10,
//                             color: DynamicColor.boxColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: ListTile(
//                               minLeadingWidth: 0.0,
//                               horizontalTitleGap: 10,
//                               contentPadding: const EdgeInsets.only(
//                                   left: 5, right: 5, bottom: 10, top: 10),
//                               minVerticalPadding: 0.0,
//                               // onTap: () {
//                               // showDialog(
//                               //     context: context,
//                               //     barrierDismissible:
//                               //         Platform.isAndroid ? false : true,
//                               //     builder: (context) =>
//                               //         BuyerDetailWhenReviewPopup(
//                               //             userId: data['rating_user_id']
//                               //                 .toString()));
//                               // },
//                               leading: SizedBox(
//                                   height: 45,
//                                   width: 45,
//                                   child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: CustomNetworkImage(
//                                         url: data['image'],
//                                         fit: BoxFit.fitWidth,
//                                       ))),
//                               title: Text(
//                                 data['first_name'],
//                                 style: white15bold,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               subtitle: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '${data['rating']}.0: Rating',
//                                     style: white13w5,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     data['review'].toString(),
//                                     style: primary15w5,
//                                     maxLines: 3,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                               trailing: Text(
//                                 data['inserttime'],
//                                 style: green13bold,
//                               ),
//                             ),
//                           );
//                         }))
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class ReviewsToChefAndGrocer extends StatelessWidget {
  const ReviewsToChefAndGrocer({super.key, required totalRating, required List data});

  // 🔸 Simulated static data
  final List<Map<String, dynamic>> mockReviews = const [
    {
      'first_name': 'John Doe',
      'rating': 4,
      'review': 'The food was amazing and delivered hot!',
      'image':
      'https://via.placeholder.com/150', // Replace with any image URL
      'inserttime': '2025-08-01'
    },
    {
      'first_name': 'Jane Smith',
      'rating': 5,
      'review': 'Great experience! Will order again.',
      'image': 'https://via.placeholder.com/150',
      'inserttime': '2025-08-03'
    },
  ];

  final double averageRating = 4.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['reviews']!),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getSize10(context: context),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ⭐ Average rating display
            RatingBar.builder(
              initialRating: averageRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (_) {},
            ),

            const SizedBox(height: 20),

            // 📜 Review list
            Expanded(
              child: mockReviews.isEmpty
                  ? const Center(
                child: Text('No reviews available'),
              )
                  : ListView.builder(
                itemCount: mockReviews.length,
                itemBuilder: (context, index) {
                  final data = mockReviews[index];
                  return Card(
                    elevation: 10,
                    color: DynamicColor.boxColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CustomNetworkImage(
                          url: data['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        data['first_name'],
                        style: white15bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['rating']}.0: Rating',
                            style: white13w5,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['review'],
                            style: primary15w5,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Text(
                        data['inserttime'],
                        style: green13bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
