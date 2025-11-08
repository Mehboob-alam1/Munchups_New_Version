import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/accept_reject_complete_order_popup.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/delete_order_popup.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/order_detail.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/chef_provider.dart';

class ChefOrderList extends StatefulWidget {
  const ChefOrderList({super.key});

  @override
  State<ChefOrderList> createState() => _ChefOrderListState();
}

class _ChefOrderListState extends State<ChefOrderList> {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: TextStrings.textKey['my_order']!),
      ),
      body: Consumer<ChefProvider>(
        builder: (context, chefProvider, child) {
          if (chefProvider.isOrdersLoading && chefProvider.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          if (chefProvider.ordersError.isNotEmpty &&
              chefProvider.orders.isEmpty) {
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

          if (chefProvider.orders.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          final orders = chefProvider.orders;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final data = orders[index];
                return _OrderCard(
                  data: data,
                  index: index,
                  onChanged: () => _refresh(context),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  final VoidCallback onChanged;

  const _OrderCard({
    required this.data,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              PageNavigateScreen().push(
                context,
                OrderDetailPage(
                  data: data,
                  userType: 'Chef',
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height:
                          SizeConfig.getSizeHeightBy(context: context, by: 0.1),
                      color: DynamicColor.black.withOpacity(0.3),
                      child: CustomNetworkImage(
                        url: data['item'][0]['dish_images'] == 'NA'
                            ? ''
                            : data['item'][0]['dish_images'][0]['kitchen_image'],
                        fit: BoxFit.contain,
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
                            Text(
                              'Quantity: ${data['item'][0]['quantity']}',
                              style: white14w5,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ', style: white14w5),
                                Text(
                                  _statusLabel(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: _statusColor(),
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
                                        Platform.isAndroid ? false : true,
                                    builder: (context) => DeleteOrderPopUp(
                                      id: data['order_unique_number'],
                                      orderType: 'Order Delete',
                                    ),
                                  ).then((value) => onChanged());
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: DynamicColor.primaryColor,
                                  child: Icon(
                                    Icons.close,
                                    color: DynamicColor.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$currencySymbol${data['item'][0]['total_amount']}',
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
          const Divider(color: DynamicColor.grey300),
          SizedBox(height: SizeConfig.getSize20(context: context)),
          _buildActionRow(context),
          SizedBox(height: SizeConfig.getSize20(context: context)),
        ],
      ),
    );
  }

  String _statusLabel() {
    if (data['delivery_status'] == 'delivered') {
      return data['delivery_status'].toString().toUpperCase();
    }
    return data['status'].toString().toUpperCase();
  }

  Color _statusColor() {
    if (data['delivery_status'] == 'delivered') {
      return DynamicColor.green;
    }
    switch (data['status']) {
      case 'pending':
        return DynamicColor.primaryColor;
      case 'accept':
        return DynamicColor.green;
      case 'decline':
        return DynamicColor.redColor;
      default:
        return DynamicColor.redColor;
    }
  }

  Widget _buildActionRow(BuildContext context) {
    if (data['status'] == 'pending') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommanButton(
            heroTag: index + 1,
            shap: 10.0,
            hight: 35.0,
            width: MediaQuery.of(context).size.width * 0.25,
            textSize: 15.0,
            buttonBGColor: DynamicColor.green,
            buttonName: 'Accept',
            onPressed: () => _handleStatusChange(
              context,
              title: 'accept',
              status: 'accept',
            ),
          ),
          CommanButton(
            heroTag: index + 2,
            shap: 10.0,
            hight: 35.0,
            width: MediaQuery.of(context).size.width * 0.25,
            textSize: 15.0,
            buttonBGColor: Colors.red,
            buttonName: 'Decline',
            onPressed: () => _handleStatusChange(
              context,
              title: 'decline',
              status: 'decline',
            ),
          ),
        ],
      );
    }

    if (data['status'] == 'decline') {
      return _statusChip('Declined', DynamicColor.redColor);
    }

    if (data['delivery_status'] == 'delivered') {
      return _statusChip('Delivered', DynamicColor.green);
    }

    if (data['status'] == 'accept') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommanButton(
            heroTag: index + 3,
            shap: 10.0,
            hight: 35.0,
            width: MediaQuery.of(context).size.width * 0.3,
            textSize: 15.0,
            buttonBGColor: Colors.red,
            buttonName: 'Reject',
            onPressed: () => _handleStatusChange(
              context,
              title: 'reject',
              status: 'reject',
            ),
          ),
          CommanButton(
            heroTag: index + 4,
            shap: 10.0,
            hight: 35.0,
            width: MediaQuery.of(context).size.width * 0.3,
            textSize: 15.0,
            buttonBGColor: DynamicColor.green,
            buttonName: 'Complete',
            onPressed: () => _handleStatusChange(
              context,
              title: 'complete',
              status: 'completed',
            ),
          ),
        ],
      );
    }

    return _statusChip('Processing', DynamicColor.primaryColor);
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      height: 30,
      width: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleStatusChange(
    BuildContext context, {
    required String title,
    required String status,
  }) {
    showDialog(
      context: context,
      barrierDismissible: Platform.isAndroid ? false : true,
      builder: (context) => AcceptRejectCompleteOrderPopup(
        title: title,
        orderID: data['order_id'].toString(),
        buyerID: data['buyer_id'].toString(),
        amount: data['item'][0]['total_amount'].toString(),
        status: status,
      ),
    ).then((value) => onChanged());
  }
}
