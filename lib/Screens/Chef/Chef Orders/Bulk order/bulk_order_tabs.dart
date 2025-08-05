import 'package:flutter/material.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Orders/Bulk%20order/chef_bulk_active_order_list.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Orders/Bulk%20order/chef_bulk_completed_order_list.dart';

class BulkOrderTabs extends StatefulWidget {
  int currentIndex;
  BulkOrderTabs({super.key, required this.currentIndex});

  @override
  State<BulkOrderTabs> createState() => _BulkOrderTabsState();
}

class _BulkOrderTabsState extends State<BulkOrderTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              title:
                  Text(TextStrings.textKey['my_bulk_order']!, style: white21w5),
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
                          text: 'Active',
                        ),
                        Tab(
                          text: 'Completed',
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ChefActiveBulkOrderList(),
              ChefCompletedBulkOrderList()
            ]),
      ),
    );
  }
}
