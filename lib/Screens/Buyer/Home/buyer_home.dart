import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/exit_page.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/providers/main_provider.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Buyer/Cart/card_list.dart';
import 'package:munchups_app/Screens/Buyer/Chefs/all_chefs_list.dart';
import 'package:munchups_app/Screens/Buyer/Grocers/all_grocer_list.dart';
import 'package:munchups_app/Screens/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Component/providers/app_provider.dart';
import '../../../Component/providers/cart_provider.dart';
import '../../../Component/providers/data_provider.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  int changeImage = 0;

  @override
  void initState() {
    super.initState();
    //_initializeData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().initializeCart();
      context.read<DataProvider>().fetchHomeData();
    });
  }

  Future<void> _initializeData() async {
    // Initialize cart data
    await context.read<CartProvider>().initializeCart();

    // Fetch home data if needed
    await context.read<DataProvider>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: DefaultTabController(
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
                  onTap: () {
                    globalKey.currentState!.openDrawer();
                  },
                  child: const Icon(Icons.menu,
                      color: DynamicColor.white, size: 35)),
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
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: DynamicColor.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart,
                              color: DynamicColor.white, size: 12),
                          const SizedBox(width: 2),
                          const Text('Cart',
                              style: TextStyle(
                                  color: DynamicColor.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 2),
                          Container(
                            width: 1,
                            height: 12,
                            color: DynamicColor.white,
                          ),
                          const SizedBox(width: 5),
                          // Use Consumer to listen to cart changes
                          Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              return Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: DynamicColor.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    cartProvider.cartCount.toString(),
                                    style: const TextStyle(
                                        color: DynamicColor.primaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              if (dataProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (dataProvider.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${dataProvider.error}'),
                      ElevatedButton(
                        onPressed: () => dataProvider.fetchHomeData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InputFieldsWithLightWhiteColor(
                      controller: context.read<AppProvider>().homeSearchTextController,
                      labelText: 'Search for food...',
                      prefixIcon: Icons.search, onChanged: (String value) {

                    },
                    ),
                  ),
                  
                  // Tab bar
                  Container(
                    color: DynamicColor.primaryColor,
                    child: const TabBar(
                      tabs: [
                        Tab(text: 'Chefs'),
                        Tab(text: 'Grocers'),
                      ],
                      labelColor: DynamicColor.white,
                      unselectedLabelColor: DynamicColor.lightBlack,
                      indicatorColor: DynamicColor.white,
                    ),
                  ),
                  
                  // Tab content
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Chefs tab
                        _buildChefsList(dataProvider.chefsList),
                        // Grocers tab
                        _buildGrocersList(dataProvider.grocersList),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChefsList(List<dynamic> chefs) {
    if (chefs.isEmpty) {
      return const Center(child: Text('No chefs available'));
    }
    
    return ListView.builder(
      itemCount: chefs.length,
      itemBuilder: (context, index) {
        final chef = chefs[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chef['image'] ?? ''),
          ),
          title: Text(chef['name'] ?? ''),
          subtitle: Text(chef['speciality'] ?? ''),
          onTap: () {
            // Navigate to chef detail page
          },
        );
      },
    );
  }

  Widget _buildGrocersList(List<dynamic> grocers) {
    if (grocers.isEmpty) {
      return const Center(child: Text('No grocers available'));
    }
    
    return ListView.builder(
      itemCount: grocers.length,
      itemBuilder: (context, index) {
        final grocer = grocers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(grocer['image'] ?? ''),
          ),
          title: Text(grocer['name'] ?? ''),
          subtitle: Text(grocer['store_name'] ?? ''),
          onTap: () {
            // Navigate to grocer detail page
          },
        );
      },
    );
  }
}
