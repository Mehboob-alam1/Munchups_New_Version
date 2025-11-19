import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/live_order_detail.dart';

class CompleteOrderList extends StatefulWidget {
  const CompleteOrderList({super.key});

  @override
  State<CompleteOrderList> createState() => _CompleteOrderListState();
}

class _CompleteOrderListState extends State<CompleteOrderList> {
  List<dynamic> _extractList(dynamic source) {
    if (source == null) return const [];
    if (source is List) return source;
    if (source is Map) return source.values.toList();
    if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
        return const [];
      }
    }
    return const [];
  }

  Map<String, dynamic> _asMap(dynamic source) {
    if (source is Map<String, dynamic>) return source;
    if (source is Map) return Map<String, dynamic>.from(source as Map);
    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetApiServer().myOrderListApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data['success'] != 'true') {
            return const Center(child: Text('No orders available'));
          }

          final orders = _extractList(snapshot.data['oc_complete_order_arr']);
          if (orders.isEmpty) {
            return const Center(child: Text('No order available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final data = _asMap(orders[index]);
                final imageUrl = data['image']?.toString() ?? '';

                return InkWell(
                  onTap: () {
                    PageNavigateScreen().push(
                        context,
                        LiveOrderDetailPage(
                            data: data, fromuserName: 'Chef'));
                  },
                  child: Card(
                    color: DynamicColor.boxColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                url: imageUrl, fit: BoxFit.contain),
                          ),
                        )),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(data['last_name']?.toString() ?? '',
                                          style: white17Bold,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 3),
                                      Text(
                                          'Order ID: ${data['order_unique_number']}',
                                          style: white14w5,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                           Text('Status: ',
                                              style: white14w5,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
                                          Text(
                                              data['order_status']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: green14w5,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      Platform.isAndroid
                                                          ? false
                                                          : true,
                                                  builder: (context) =>
                                                      DeleteOrderPopUp(
                                                        id: data[
                                                            'order_unique_number'],
                                                        orderType: 'Bulk',
                                                      )).then((value) {
                                                setState(() {});
                                              });
                                            },
                                            child: const CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    DynamicColor.primaryColor,
                                                child: Icon(
                                                  Icons.close,
                                                  color: DynamicColor.white,
                                                  size: 20,
                                                )),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                              '$currencySymbol${data['budget']}',
                                              style: greenColor15bold,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
