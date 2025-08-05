import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/full_image_view.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/rate_chef.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Profile/report_page.dart';

class OrderDetailPage extends StatefulWidget {
  dynamic data;
  String userType;
  OrderDetailPage({
    super.key,
    required this.data,
    required this.userType,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  dynamic data;

  double totlaPriceData = 0.0;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    totlaAmount();
  }

  void totlaAmount() {
    if (data != null) {
      for (var element in data['item']) {
        setState(() {
          totlaPriceData += double.parse(element['total_amount']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Order Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.getSize20(context: context),
              right: SizeConfig.getSize20(context: context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.getSize30(context: context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ID: ${data['order_unique_number'].toString()}',
                      style: white17Bold),
                  Row(
                    children: [
                      Text('Status: ', style: lightWhite15Bold),
                      Text(
                          data['delivery_status'] == 'delivered'
                              ? data['delivery_status'].toString().toUpperCase()
                              : data['status'].toString().toUpperCase(),
                          style: TextStyle(
                              fontSize: 14.0,
                              color: data['delivery_status'] == 'delivered'
                                  ? DynamicColor.green
                                  : data['status'] == 'pending'
                                      ? DynamicColor.primaryColor
                                      : data['status'] == 'accept'
                                          ? DynamicColor.green
                                          : DynamicColor.redColor,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )
                ],
              ),
              Text(data['order_date'],
                  // DateFormat('dd-mm-yyyy')
                  //     .format(DateTime.parse(data['order_date'])),
                  style: white15bold),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivered to', style: lightWhite14Bold),
                        Text(
                          (data['address'] == null)
                              ? 'Not found'
                              : formatAddress(data['address']),
                          style: white15bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: widget.userType != 'Buyer'
                        ? Container()
                        : data['status'] != 'pending'
                            ? data['user_type'] != 'grocer'
                                ? Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: () {
                                            PageNavigateScreen().push(
                                                context,
                                                RateChefPage(
                                                  chefID: data['chef_grocer_id']
                                                      .toString(),
                                                  orderID: data['order_id']
                                                      .toString(),
                                                ));
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 70,
                                            alignment: Alignment.center,
                                            // margin: const EdgeInsets.only(bottom: 10, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: DynamicColor.primaryColor,
                                            ),
                                            child:
                                                Text('Rate', style: white13w5),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: () {
                                            PageNavigateScreen().push(context,
                                                ReportPage(data: data));
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 70,
                                            alignment: Alignment.center,
                                            // margin: const EdgeInsets.only(bottom: 10, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: DynamicColor.primaryColor,
                                            ),
                                            child: Text('Report',
                                                style: white13w5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                            : Container(),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              const Divider(color: DynamicColor.white),
              SizedBox(height: SizeConfig.getSize10(context: context)),
              Align(
                alignment: Alignment.topLeft,
                child: Text('ITEM', style: lightWhite15Bold),
              ),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: data['item'].length,
                  itemBuilder: (context, index) {
                    dynamic dishData = data['item'][index];

                    return dishData['type'] == 'chef'
                        ? ListTile(
                            minLeadingWidth: 0,
                            contentPadding: const EdgeInsets.only(bottom: 8),
                            minVerticalPadding: 0,
                            horizontalTitleGap: 8,
                            dense: true,
                            leading: SizedBox(
                              height: 40,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () {
                                    PageNavigateScreen().push(
                                        context,
                                        FullImageView(
                                            url: dishData['dish_images'][0]
                                                ['kitchen_image']));
                                  },
                                  child: CustomNetworkImage(
                                      url: dishData['dish_images'] != 'NA'
                                          ? dishData['dish_images'][0]
                                              ['kitchen_image']
                                          : ''),
                                ),
                              ),
                            ),
                            title: Text(dishData['name'],
                                style: white17Bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                                'Ouantity: ${dishData['quantity'].toString()}',
                                style: white14w5,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            trailing: Text(
                                '$currencySymbol${dishData['dish_price'].toString()}',
                                style: greenColor15bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          )
                        : ListTile(
                            minLeadingWidth: 0,
                            contentPadding: const EdgeInsets.only(bottom: 8),
                            minVerticalPadding: 0,
                            horizontalTitleGap: 8,
                            dense: true,
                            leading: SizedBox(
                              height: 40,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomNetworkImage(
                                    url: dishData['dish_images'] != 'NA'
                                        ? dishData['dish_images'][0]
                                            ['kitchen_image']
                                        : ''),
                              ),
                            ),
                            title: Text(dishData['name'],
                                style: white17Bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                                'Ouantity: ${dishData['quantity'].toString()}',
                                style: white14w5,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            trailing: Text(
                                '$currencySymbol${dishData['dish_price'].toString()}',
                                style: greenColor15bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          );
                  }),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              const Divider(color: DynamicColor.white),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              total(),
            ],
          ),
        ),
      ),
    );
  }

  Widget total() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Item:', style: white15bold),
                Text(data['item'].length.toString(), style: white15bold),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sub Total:', style: white15bold),
                Text('$currencySymbol$totlaPriceData', style: white15bold),
              ],
            ),
            const Divider(color: DynamicColor.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: white21bold),
                Text('$currencySymbol$totlaPriceData', style: primary25bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
