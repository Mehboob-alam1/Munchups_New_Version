import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/app_provider.dart';
import '../../../presentation/providers/cart_provider.dart';
import '../../../presentation/providers/data_provider.dart';
import '../../../Comman widgets/Input Fields/input_fields_with_lightwhite.dart';
import '../../../Comman widgets/exit_page.dart';
import '../../../Component/Strings/strings.dart';
import '../../../Component/color_class/color_class.dart';
import '../../../Component/navigatepage/navigate_page.dart';
import '../../../Component/styles/styles.dart';
import '../../drawer.dart';
import '../Cart/card_list.dart';
import '../Chefs/all_chefs_list.dart';
import '../Grocers/all_grocer_list.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final cartProvider = context.read<CartProvider>();
      final dataProvider = context.read<DataProvider>();
      cartProvider.initializeCart();
      dataProvider.fetchHomeData();
    });
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
            child: const DrawerPage(),
          ),
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
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: DynamicColor.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart,
                              color: DynamicColor.white, size: 12),
                          const SizedBox(width: 2),
                          const Text(
                            'Cart',
                            style: TextStyle(
                              color: DynamicColor.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              return Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: DynamicColor.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    cartProvider.cartCount.toString(),
                                    style: const TextStyle(
                                      color: DynamicColor.primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InputFieldsWithLightWhiteColor(
                      controller:
                      context.read<AppProvider>().homeSearchTextController,
                      labelText: 'Search for food...',
                      prefixIcon: Icons.search,
                      onChanged: (value) {},
                    ),
                  ),
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
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildChefsList(dataProvider.chefsList),
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
            // TODO: navigate to chef detail
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
            // TODO: navigate to grocer detail
          },
        );
      },
    );
  }
}