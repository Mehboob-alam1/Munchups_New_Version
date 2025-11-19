import 'dart:async';

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
import '../../../Component/utils/custom_network_image.dart';
import '../Cart/card_list.dart';
import '../Chefs/all_chefs_list.dart';
import '../Grocers/all_grocer_list.dart';
import '../../Chef/Chef Profile/chef_profile.dart';
import '../../Grocer/Grocer Profile/grocer_profile.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  Timer? _searchDebounce;
  bool _searchListenerAttached = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_searchListenerAttached) {
      final controller =
          context.read<AppProvider>().homeSearchTextController;
      controller.addListener(_onSearchControllerChanged);
      _searchListenerAttached = true;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    if (_searchListenerAttached) {
      final controller =
          context.read<AppProvider>().homeSearchTextController;
      controller.removeListener(_onSearchControllerChanged);
    }
    super.dispose();
  }

  void _onSearchControllerChanged() {
    setState(() {});
  }

  void _handleSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      final dataProvider = context.read<DataProvider>();
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        dataProvider.clearSearch();
      } else {
        dataProvider.searchUsers(trimmed);
      }
    });
  }

  void _clearSearch() {
    final controller = context.read<AppProvider>().homeSearchTextController;
    controller.clear();
    context.read<DataProvider>().clearSearch();
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
              final searchController =
                  context.read<AppProvider>().homeSearchTextController;
              final searchText = searchController.text.trim();
              final isSearchActive =
                  searchText.isNotEmpty && dataProvider.searchQuery.isNotEmpty;

              if (!isSearchActive && dataProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!isSearchActive && dataProvider.error.isNotEmpty) {
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
                      controller: searchController,
                      labelText: 'Search for food...',
                      prefixIcon: Icons.search,
                      suffixIcon: searchText.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _clearSearch,
                            ),
                      onChanged: _handleSearchChanged,
                    ),
                  ),
                  if (isSearchActive)
                    Expanded(
                      child: _buildSearchResults(
                        dataProvider,
                        fallbackText: searchText,
                      ),
                    )
                  else ...[
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
        final dynamic chef = chefs[index];
        final map = chef is Map<String, dynamic>
            ? chef
            : (chef is Map
                ? Map<String, dynamic>.from(chef as Map)
                : <String, dynamic>{});
        final imageUrl = _extractImageUrl(map);
        final name = _preferValues(map, [
          'full_name',
          'first_name',
          'user_name',
        ]);
        final subtitleParts = [
          _preferValues(map, ['profession_name']),
          _composeLocation(map),
        ].where((part) => part.isNotEmpty).toList();
        final rating = _preferValues(map, ['avg_rating']);

        return Card(
          color: DynamicColor.boxColor.withOpacity(0.9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: _Avatar(imageUrl: imageUrl),
            title: Text(
              name.isEmpty ? 'Unknown Chef' : name,
              style: white15bold,
            ),
            subtitle: subtitleParts.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitleParts.join('  •  '),
                      style: white14w5.copyWith(
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),
            trailing: rating.isEmpty
                ? null
                : _RatingChip(rating: rating),
            onTap: () => _openProfile(map: map, fallbackType: 'chef'),
          ),
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
        final dynamic grocer = grocers[index];
        final map = grocer is Map<String, dynamic>
            ? grocer
            : (grocer is Map
                ? Map<String, dynamic>.from(grocer as Map)
                : <String, dynamic>{});
        final imageUrl = _extractImageUrl(map);
        final name = _preferValues(map, [
          'full_name',
          'user_name',
          'name',
        ]);
        final subtitleParts = [
          _preferValues(map, ['shop_name', 'store_name']),
          _composeLocation(map),
        ].where((part) => part.isNotEmpty).toList();
        final rating = _preferValues(map, ['avg_rating']);

        return Card(
          color: DynamicColor.boxColor.withOpacity(0.9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: _Avatar(imageUrl: imageUrl),
            title: Text(
              name.isEmpty ? 'Unknown Grocer' : name,
              style: white15bold,
            ),
            subtitle: subtitleParts.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitleParts.join('  •  '),
                      style: white14w5.copyWith(
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),
            trailing: rating.isEmpty
                ? null
                : _RatingChip(rating: rating),
            onTap: () => _openProfile(map: map, fallbackType: 'grocer'),
          ),
        );
      },
    );
  }

  void _openProfile({
    required Map<String, dynamic> map,
    required String fallbackType,
  }) {
    if (map.isEmpty) {
      return;
    }
    final id = map['user_id'] ?? map['chef_id'] ?? map['grocer_id'];
    if (id == null) {
      return;
    }

    final userId = id.toString();
    final normalizedType =
        (map['user_type'] ?? fallbackType).toString().toLowerCase();
    final appProvider = context.read<AppProvider>();
    final currentUserType =
        appProvider.userType.isNotEmpty ? appProvider.userType : 'buyer';

    if (normalizedType == 'chef') {
      PageNavigateScreen().push(
        context,
        ChefProfilePage(
          userId: userId,
          userType: 'chef',
          currentUser: currentUserType,
        ),
      );
    } else if (normalizedType == 'grocer') {
      PageNavigateScreen().push(
        context,
        GrocerProfilePage(
          userId: userId,
          userType: 'grocer',
          currentUser: currentUserType,
        ),
      );
    }
  }

  String? _extractImageUrl(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data as Map);
      final candidates = [
        map['chef_image'],
        map['image'],
        map['grocer_image'],
        map['profile_image'],
        map['pimage'],
      ];
      for (final candidate in candidates) {
        if (candidate == null) continue;
        final trimmed = candidate.toString().trim();
        if (trimmed.isEmpty) continue;
        final upper = trimmed.toUpperCase();
        if (upper == 'NA' || upper == 'NULL') continue;
        if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
          return trimmed;
        }
      }
    }
    return null;
  }

  String _preferValues(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) continue;
      final trimmed = value.toString().trim();
      if (trimmed.isEmpty) continue;
      final upper = trimmed.toUpperCase();
      if (upper == 'NA' || upper == 'NULL') continue;
      return trimmed;
    }
    return '';
  }

  String _composeLocation(Map<String, dynamic> map) {
    final parts = <String>[
      _preferValues(map, ['city']),
      _preferValues(map, ['state']),
      _preferValues(map, ['country']),
    ].where((value) => value.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    return parts.join(', ');
  }

  Widget _buildSearchResults(
    DataProvider provider, {
    required String fallbackText,
  }) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            provider.error,
            style: white15bold,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final results = provider.searchResults;
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'No results found for "$fallbackText".',
            style: white14w5,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final dynamic item = results[index];
        final map = item is Map<String, dynamic>
            ? item
            : (item is Map
                ? Map<String, dynamic>.from(item as Map)
                : <String, dynamic>{});

        final imageUrl = _extractImageUrl(map);
        final name = _preferValues(map, [
          'full_name',
          'first_name',
          'user_name',
          'name',
        ]);
        final subtitleParts = [
          _preferValues(map, ['user_type']),
          _preferValues(map, ['profession_name', 'shop_name', 'store_name']),
          _composeLocation(map),
        ].where((value) => value.isNotEmpty).toList();
        final rating = _preferValues(map, ['avg_rating']);

        return Card(
          color: DynamicColor.boxColor.withOpacity(0.9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: _Avatar(imageUrl: imageUrl),
            title: Text(
              name.isEmpty ? 'Unknown' : name,
              style: white15bold,
            ),
            subtitle: subtitleParts.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitleParts.join('  •  '),
                      style: white14w5.copyWith(
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),
            trailing: rating.isEmpty ? null : _RatingChip(rating: rating),
            onTap: () => _openProfile(map: map, fallbackType: 'chef'),
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? imageUrl;

  const _Avatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: DynamicColor.primaryColor.withOpacity(0.15),
      child: ClipOval(
        child: SizedBox(
          width: 52,
          height: 52,
          child: CustomNetworkImage(
            url: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final String rating;

  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    final parsed = double.tryParse(rating);
    final display = parsed == null
        ? rating
        : parsed.toStringAsFixed(parsed == parsed.roundToDouble() ? 0 : 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amberAccent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            display,
            style: white14w5.copyWith(color: Colors.amberAccent),
          ),
        ],
      ),
    );
  }
}