import 'package:flutter/material.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/complet_order.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/live_order.dart';
import 'package:munchups_app/Screens/Buyer/My%20Orders/order_list.dart';

class OrderTabs extends StatefulWidget {
  int currentIndex;
  OrderTabs({super.key, required this.currentIndex});

  @override
  State<OrderTabs> createState() => _OrderTabsState();
}

class _OrderTabsState extends State<OrderTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: DynamicColor.white,
                  )),
              title: Text(TextStrings.textKey['my_order']!, style: white21w5),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      PageNavigateScreen()
                          .pushRemovUntil(context, const BuyerHomePage());
                    },
                    child: const Icon(
                      Icons.home,
                      color: DynamicColor.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Container(
                  decoration: BoxDecoration(
                      color: DynamicColor.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBar(
                      indicator: BoxDecoration(
                          color: DynamicColor.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      unselectedLabelColor: DynamicColor.primaryColor,
                      unselectedLabelStyle: primary17w6,
                      labelStyle: white17Bold,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (value) {},
                      tabs: const [
                        Tab(
                          text: 'Single',
                        ),
                        Tab(
                          text: 'Live Events',
                        ),
                        Tab(
                          text: 'Done Events',
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [MyOrderList(orderData: const [], onRefresh: () {},), const LiveOrderList(), const CompleteOrderList()]),
      ),
    );
  }
}
