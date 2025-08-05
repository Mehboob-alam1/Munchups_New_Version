// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
// import 'package:munchups_app/Comman%20widgets/exit_page.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Screens/Buyer/Cart/card_list.dart';
// import 'package:munchups_app/Screens/Buyer/Chefs/all_chefs_list.dart';
// import 'package:munchups_app/Screens/Buyer/Grocers/all_grocer_list.dart';
// import 'package:munchups_app/Screens/drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class BuyerHomePage extends StatefulWidget {
//   const BuyerHomePage({super.key});
//
//   @override
//   State<BuyerHomePage> createState() => _BuyerHomePageState();
// }
//
// class _BuyerHomePageState extends State<BuyerHomePage> {
//   final GlobalKey<ScaffoldState> globalKey = GlobalKey();
//   int changeImage = 0;
//   dynamic checkItemLocal;
//
//   @override
//   void initState() {
//     super.initState();
//     getCartCount();
//   }
//
//   void getCartCount() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       checkItemLocal = jsonDecode(prefs.getString('cart').toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           key: globalKey,
//           drawerEnableOpenDragGesture: false,
//           drawer: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.65,
//               child: const DrawerPage()),
//           appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(185),
//             child: AppBar(
//               backgroundColor: Colors.transparent,
//               surfaceTintColor: Colors.transparent,
//               foregroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               leading: InkWell(
//                   onTap: () {
//                     globalKey.currentState!.openDrawer();
//                   },
//                   child: const Icon(Icons.menu,
//                       color: DynamicColor.white, size: 35)),
//               title: Text(TextStrings.textKey['home']!, style: primary25bold),
//               centerTitle: true,
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15, bottom: 5, right: 10),
//                   child: InkWell(
//                     onTap: () {
//                       PageNavigateScreen().push(context, const CartListPage());
//                     },
//                     child: Container(
//                       height: 25,
//                       padding: const EdgeInsets.only(left: 8, right: 8),
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: DynamicColor.primaryColor,
//                           borderRadius: BorderRadius.circular(8)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.shopping_cart,
//                               color: DynamicColor.white, size: 12),
//                           const SizedBox(width: 2),
//                           const Text('Cart',
//                               style: TextStyle(
//                                   color: DynamicColor.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500)),
//                           const SizedBox(width: 2),
//                           Container(
//                             width: 1,
//                             height: 12,
//                             color: DynamicColor.white,
//                           ),
//                           const SizedBox(width: 5),
//                           Text(checkItemLocal != null ? '1' : '0',
//                               style: const TextStyle(
//                                   color: DynamicColor.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(10),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 10, right: 10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       serchBox(),
//                       const SizedBox(height: 20),
//                       Container(
//                         decoration: BoxDecoration(
//                             color: DynamicColor.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: TabBar(
//                             indicator: BoxDecoration(
//                                 color: DynamicColor.primaryColor,
//                                 borderRadius: BorderRadius.circular(10)),
//                             unselectedLabelColor: DynamicColor.primaryColor,
//                             unselectedLabelStyle: primary17w6,
//                             labelStyle: white17Bold,
//                             indicatorColor: Colors.white,
//                             labelColor: Colors.white,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             onTap: (value) {
//                               setState(() {
//                                 homeSearchTextController.text = '';
//                               });
//                             },
//                             tabs: const [
//                               Tab(
//                                 text: 'Chefs',
//                               ),
//                               Tab(
//                                 text: 'Grocers',
//                               )
//                             ]),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           body: const TabBarView(
//               physics: NeverScrollableScrollPhysics(),
//               children: [AllChefsList(), AllGrocerList()]),
//         ),
//       ),
//     );
//   }
//
//   Widget serchBox() {
//     return InputFieldsWithLightWhiteColor(
//         controller: homeSearchTextController,
//         labelText: 'Username, Chef Name, Dish Name',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.emailAddress,
//         style: black15bold,
//         onChanged: (value) {
//           setState(() {});
//         });
//   }
// }


import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Buyer/Cart/card_list.dart';
import 'package:munchups_app/Screens/Buyer/Chefs/all_chefs_list.dart';
import 'package:munchups_app/Screens/Buyer/Grocers/all_grocer_list.dart';
import 'package:munchups_app/Screens/drawer.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: globalKey,
        drawerEnableOpenDragGesture: false,
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: const DrawerPage()),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(185),
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: InkWell(
              onTap: () => globalKey.currentState!.openDrawer(),
              child: const Icon(Icons.menu,
                  color: DynamicColor.white, size: 35),
            ),
            title: Text(TextStrings.textKey['home']!, style: primary25bold),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5, right: 10),
                child: InkWell(
                  onTap: () {
                    PageNavigateScreen().push(context, const CartListPage());
                  },
                  child: Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: DynamicColor.primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: const [
                        Icon(Icons.shopping_cart,
                            color: DynamicColor.white, size: 12),
                        SizedBox(width: 5),
                        Text('Cart',
                            style: TextStyle(
                                color: DynamicColor.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 5),
                        VerticalDivider(color: DynamicColor.white, thickness: 1),
                        SizedBox(width: 5),
                        Text('0', // Hardcoded or dynamic via controller
                            style: TextStyle(
                                color: DynamicColor.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchBox(),
                    const SizedBox(height: 20),
                    _tabBar(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [AllChefsList(), AllGrocerList()],
        ),
      ),
    );
  }

  Widget _searchBox() {
    return InputFieldsWithLightWhiteColor(
      controller: homeSearchTextController,
      labelText: 'Username, Chef Name, Dish Name',
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      style: black15bold,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _tabBar() {
    return Container(
      decoration: BoxDecoration(
        color: DynamicColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        indicator: BoxDecoration(
            color: DynamicColor.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        unselectedLabelColor: DynamicColor.primaryColor,
        unselectedLabelStyle: primary17w6,
        labelStyle: white17Bold,
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        onTap: (_) => setState(() => homeSearchTextController.text = ''),
        tabs: const [
          Tab(text: 'Chefs'),
          Tab(text: 'Grocers'),
        ],
      ),
    );
  }
}
