import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/live_order_detail.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/chef_provider.dart';

class ChefActiveBulkOrderList extends StatefulWidget {
  const ChefActiveBulkOrderList({super.key});

  @override
  State<ChefActiveBulkOrderList> createState() =>
      _ChefActiveBulkOrderListState();
}

class _ChefActiveBulkOrderListState extends State<ChefActiveBulkOrderList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChefProvider>().loadOrders();
    });
  }

  void _refresh(BuildContext context) {
    context.read<ChefProvider>().loadOrders(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChefProvider>(
      builder: (context, chefProvider, child) {
        if (chefProvider.isOrdersLoading &&
            chefProvider.activeBulkOrders.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: DynamicColor.primaryColor,
            ),
          );
        }

        if (chefProvider.ordersError.isNotEmpty &&
            chefProvider.activeBulkOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chefProvider.ordersError,
                  style: white15bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _refresh(context),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final activeOrders = chefProvider.activeBulkOrders;
        if (activeOrders.isEmpty) {
          return const Center(child: Text('No order available'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              final data = activeOrders[index];
              return InkWell(
                onTap: () {
                  PageNavigateScreen().push(
                    context,
                    LiveOrderDetailPage(
                      data: data,
                      fromuserName: 'Buyer',
                    ),
                  );
                },
                child: Card(
                  color: DynamicColor.boxColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: SizeConfig.getSizeHeightBy(
                              context: context,
                              by: 0.1,
                            ),
                            color: DynamicColor.black.withOpacity(0.3),
                            child: CustomNetworkImage(
                              url: data['image'],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    '${data['first_name']} ${data['last_name']}',
                                    style: white17Bold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Order ID: ${data['order_unique_number']}',
                                    style: white14w5,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Status: ', style: white14w5),
                                      Text(
                                        data['order_status']
                                            .toString()
                                            .toUpperCase(),
                                        style: green14w5,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                              Platform.isAndroid
                                                  ? false
                                                  : true,
                                          builder: (context) => DeleteOrderPopUp(
                                            id: data['order_unique_number'],
                                            orderType: 'Bulk',
                                          ),
                                        ).then((value) => _refresh(context));
                                      },
                                      child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor:
                                            DynamicColor.primaryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: DynamicColor.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$currencySymbol${data['budget']}',
                                      style: greenColor15bold,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
