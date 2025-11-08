import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/exit_page.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/notify_count.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_posted_list.dart';
import 'package:munchups_app/Screens/Notification/notification.dart';
import 'package:munchups_app/Screens/drawer.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/chef_provider.dart';
import 'package:munchups_app/Screens/Chef/Home/home_model.dart';

class ChefHomePage extends StatefulWidget {
  const ChefHomePage({super.key});

  @override
  State<ChefHomePage> createState() => _ChefHomePageState();
}

class _ChefHomePageState extends State<ChefHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  final NotificationController notificationController =
      NotificationController();

  @override
  void initState() {
    super.initState();
    notificationController.startTimer(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChefProvider>().loadDashboard(forceRefresh: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    notificationController.closeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        key: globalKey,
        drawerEnableOpenDragGesture: false,
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: const DrawerPage()),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: InkWell(
                onTap: () {
                  globalKey.currentState!.openDrawer();
                },
                child: const Icon(Icons.menu,
                    color: DynamicColor.white, size: 35)),
            title: Text(TextStrings.textKey['home']!, style: primary25bold),
            centerTitle: true,
            actions: [
              ValueListenableBuilder(
                  valueListenable: notificationController.totalCount,
                  builder: (context, count, child) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 5, right: 10),
                          child: InkWell(
                              onTap: () {
                                PageNavigateScreen()
                                    .push(context, const NotificationList());
                              },
                              child: const Icon(
                                Icons.notifications,
                                color: DynamicColor.white,
                                size: 35,
                              )),
                        ),
                        count == 0
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  PageNavigateScreen()
                                      .push(context, const NotificationList());
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Text(count.toString(),
                                        style: white14w5),
                                  ),
                                ))
                      ],
                    );
                  })
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: serchBox(),
              ),
            ),
          ),
        ),
        body: Consumer<ChefProvider>(
          builder: (context, chefProvider, child) {
            if (chefProvider.isDashboardLoading &&
                chefProvider.dashboardOccasions.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: DynamicColor.primaryColor,
                ),
              );
            }

            if (chefProvider.dashboardError.isNotEmpty &&
                chefProvider.dashboardOccasions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      chefProvider.dashboardError,
                      style: white15bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          chefProvider.loadDashboard(forceRefresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (chefProvider.dashboardOccasions.isEmpty) {
              return const Center(child: Text('No Order available'));
            }

            final List<OcCategoryOrderArr> occasions =
                chefProvider.dashboardOccasions;

            return RefreshIndicator(
              onRefresh: () async {
                await chefProvider.loadDashboard(forceRefresh: true);
              },
              child: ChefsPostedListPage(
                list: occasions,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget serchBox() {
    return InputFieldsWithLightWhiteColor(
        labelText: TextStrings.textKey['serch'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
        onChanged: (value) {
          setState(() {});
        });
  }
}
