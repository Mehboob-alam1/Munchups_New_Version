import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/otp_popup.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/chef_report.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';

class LiveOrderDetailPage extends StatefulWidget {
  dynamic data;
  String fromuserName;
  LiveOrderDetailPage(
      {super.key, required this.data, required this.fromuserName});

  @override
  State<LiveOrderDetailPage> createState() => _LiveOrderDetailPageState();
}

class _LiveOrderDetailPageState extends State<LiveOrderDetailPage> {
  dynamic data;

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
          child: BackIconCustomAppBar(title: 'Order Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.getSize20(context: context),
              right: SizeConfig.getSize20(context: context)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getSize20(context: context)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('Order ID', style: white17Bold),
                        Text(data['order_unique_number'].toString(),
                            style: white17Bold),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Order Status', style: white17Bold),
                        Text(data['order_status'].toString().toUpperCase(),
                            style: data['order_status'] == 'complete'
                                ? const TextStyle(
                                    fontSize: 17.0,
                                    color: DynamicColor.green,
                                    fontWeight: FontWeight.bold)
                                : TextStyle(
                                    fontSize: 17.0,
                                    color: data['order_status'] == 'pending'
                                        ? DynamicColor.primaryColor
                                        : data['order_status'] == 'active'
                                            ? DynamicColor.green
                                            : DynamicColor.redColor,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ]),
              SizedBox(height: SizeConfig.getSize20(context: context)),
              orderDetail(),
              chefDetail(),
              SizedBox(height: SizeConfig.getSize30(context: context)),
              data['order_status'] == 'complete'
                  ? CommanButton(
                      heroTag: 1,
                      shap: 10.0,
                      hight: 35.0,
                      width: MediaQuery.of(context).size.width * 0.5,
                      buttonName: 'Download Invoice',
                      onPressed: () {
                        downloadInvoiceApiCall(context);
                      })
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        widget.fromuserName == 'Chef'
                            ? CommanButton(
                                heroTag: 1,
                                shap: 10.0,
                                hight: 35.0,
                                width: MediaQuery.of(context).size.width * 0.3,
                                buttonName: 'REPORT',
                                onPressed: () {
                                  PageNavigateScreen().push(
                                      context,
                                      ChefReportFormPage(
                                          orderUniqueNumber:
                                              data['order_unique_number']
                                                  .toString()));
                                })
                            : CommanButton(
                                heroTag: 1,
                                shap: 10.0,
                                hight: 35.0,
                                width: MediaQuery.of(context).size.width * 0.3,
                                buttonName: 'Get Paid',
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible:
                                          Platform.isAndroid ? false : true,
                                      builder: (context) => OTPPopup(
                                            data: data,
                                            orderType: 'live order',
                                          ));
                                }),
                        CommanButton(
                            heroTag: 2,
                            shap: 10.0,
                            hight: 35.0,
                            width: MediaQuery.of(context).size.width * 0.3,
                            buttonName: 'CALL',
                            onPressed: () {
                              Utils.launchUrls('tel:${data['phone']}', context);
                            })
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Align(
                alignment: Alignment.center,
                child: Text('Order Detail', style: primary17w6)),
          ),
          Column(
            children: [
              customWidget(
                  title: 'Occassion', value: data['occasion_category_name']),
              customWidget(
                  title: 'Number Of People', value: data['no_of_people']),
              customWidget(
                  title: 'Food Category', value: data['food_cate_name']),
              customWidget(title: 'Service Type', value: data['service_type']),
              customWidget(
                  title: 'Budget', value: '$currencySymbol${data['budget']}'),
              customWidget(
                  title: 'Date',
                  value: data['start_date'] + ' - ' + data['end_date']),
              customWidget(title: 'Time', value: data['occasion_time']),
              customWidget(
                  title: 'Location', value: formatAddress(data['location'])),
              customWidget(title: 'Postal Code', value: data['postal_code']),
              customWidget(title: 'Note', value: data['description']),
            ],
          )
        ],
      ),
    );
  }

  Widget chefDetail() {
    return Card(
      color: DynamicColor.boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Align(
                alignment: Alignment.center,
                child:
                    Text('${widget.fromuserName} Detail', style: primary17w6)),
          ),
          customWidget(
              title: '${widget.fromuserName} Name',
              value: '${data['first_name']} ${data['last_name']}'),
          customWidget(
              title: '${widget.fromuserName} Email',
              value: (data['email_id'] == null)
                  ? 'Not available'
                  : data['email_id']),
          customWidget(
              title: '${widget.fromuserName} Address',
              value: formatAddress(data['location'])),
          customWidget(
              title: '${widget.fromuserName} Phone No',
              value: data['phone'] == null || data['phone'] == 'NA'
                  ? 'Not available'
                  : formatMobileNumber(data['phone'])),
        ],
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

  void downloadInvoiceApiCall(context) async {
    Utils().showSpinner(context);
    try {
      GetApiServer()
          .downloadInvoiceApi(data['order_unique_number'])
          .then((value) {
        Utils().stopSpinner(context);
        if (value['success'] == 'true') {
          Utils.launchUrls(value['url'], context);
          PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
        }
      });
    } catch (e) {
      log(e.toString());
      Utils().stopSpinner(context);
    }
  }
}
