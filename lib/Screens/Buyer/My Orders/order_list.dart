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
import 'package:munchups_app/Screens/Buyer/My%20Orders/order_detail.dart';

class MyOrderList extends StatefulWidget {
  const MyOrderList({super.key});

  @override
  State<MyOrderList> createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList> {
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

          final orders = _extractList(snapshot.data['data']);
          if (orders.isEmpty) {
            return const Center(child: Text('No order available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = _asMap(orders[index]);
                final items = _extractList(order['item']);
                final firstItem = items.isNotEmpty
                    ? _asMap(items.first)
                    : <String, dynamic>{};
                final dishImages = _extractList(firstItem['dish_images']);
                final imageUrl = dishImages.isNotEmpty
                    ? _asMap(dishImages.first)['kitchen_image']?.toString() ?? ''
                    : '';
                final quantity = firstItem['quantity']?.toString() ?? '0';
                final totalAmount =
                    firstItem['total_amount'] ?? firstItem['dish_price'] ?? '0';

                return InkWell(
                  onTap: () {
                    PageNavigateScreen().push(
                      context,
                      OrderDetailPage(
                        data: order,
                        userType: 'Buyer',
                      ),
                    );
                  },
                  child: Card(
                    color: DynamicColor.boxColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: SizeConfig.getSizeHeightBy(
                                  context: context, by: 0.1),
                              color: DynamicColor.black.withOpacity(0.3),
                              child: CustomNetworkImage(
                                url: imageUrl,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      firstItem['name']?.toString() ?? '',
                                      style: white17Bold,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Order ID: ${order['order_unique_number']}',
                                      style: white14w5,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Quantity: $quantity',
                                      style: white14w5,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                                            overflow: TextOverflow.ellipsis),
                                        Text(
                                          order['delivery_status'] ==
                                                  'delivered'
                                              ? order['delivery_status']
                                                  .toString()
                                                  .toUpperCase()
                                              : order['status']
                                                  .toString()
                                                  .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: order['delivery_status'] ==
                                                    'delivered'
                                                ? DynamicColor.green
                                                : order['status'] == 'pending'
                                                    ? DynamicColor.primaryColor
                                                    : order['status'] == 'accept'
                                                        ? DynamicColor.green
                                                        : DynamicColor.redColor,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                                id: order['order_unique_number'],
                                                orderType: 'Order Delete',
                                              ),
                                            ).then((value) {
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
                                          '$currencySymbol$totalAmount',
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
                        )
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
