import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:munchups_app/Comman widgets/alert boxes/delete_dish_popup.dart';
import 'package:munchups_app/Comman widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/Chef/Posted Dish/edit_dish_form.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/data_provider.dart';

import '../../../Component/Strings/strings.dart';

class ChefPostedDishListPage extends StatefulWidget {
  const ChefPostedDishListPage({super.key});

  @override
  State<ChefPostedDishListPage> createState() => _ChefPostedDishListPageState();
}

class _ChefPostedDishListPageState extends State<ChefPostedDishListPage> {
  String getUserType = 'chef';

  Map<String, dynamic> _mapFromAny(Map source) {
    return source.map((key, value) => MapEntry(key.toString(), value));
  }

  void _debugPrintFull(String tag, dynamic value) {
    try {
      final message = value is String ? value : jsonEncode(value);
      const chunkSize = 900;
      for (var i = 0; i < message.length; i += chunkSize) {
        final end = (i + chunkSize < message.length) ? i + chunkSize : message.length;
        debugPrint('$tag${message.substring(i, end)}');
      }
    } catch (e) {
      debugPrint('$tag$value');
    }
  }

  Map<String, dynamic> _extractProfileData(Map<String, dynamic> source) {
    if (source['profile_data'] is Map) {
      return _mapFromAny(source['profile_data'] as Map);
    }
    if (source['data'] is Map) {
      return _mapFromAny(source['data'] as Map);
    }
    return _mapFromAny(source);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        if (prefs.getString('user_type') != null) {
          getUserType = prefs.getString('user_type')!.toString();
        }
      });
      if (mounted) {
        await context
            .read<DataProvider>()
            .fetchUserProfile(forceRefresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:
              BackIconCustomAppBar(title: TextStrings.textKey['posted_dish']!)),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final isLoading = dataProvider.isLoading &&
              (dataProvider.userProfile.isEmpty);
          final hasError = dataProvider.error.isNotEmpty &&
              dataProvider.userProfile.isEmpty;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: DynamicColor.primaryColor,
              ),
            );
          }

          if (hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dataProvider.error),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => dataProvider.fetchUserProfile(
                        forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final rawProfile = dataProvider.userProfile;
          final profile = _extractProfileData(rawProfile);
          _debugPrintFull('ChefPostedDishList: profile=', profile);
          dynamic postsDynamic = profile['all_post'];
          _debugPrintFull(
              'ChefPostedDishList: all_post (${postsDynamic.runtimeType})=',
              postsDynamic);
          List<Map<String, dynamic>> dishList = [];

          List<Map<String, dynamic>> _normalizeDishImages(dynamic source) {
            final List<Map<String, dynamic>> images = [];

            void addImage(dynamic entry) {
              if (entry is Map) {
                final map = Map<String, dynamic>.from(entry);
                if (map['kitchen_image'] != null) {
                  images.add({'kitchen_image': map['kitchen_image'].toString()});
                }
              } else if (entry is String && entry.trim().isNotEmpty) {
                images.add({'kitchen_image': entry});
              }
            }

            if (source is String) {
              final trimmed = source.trim();
              if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
                debugPrint('ChefPostedDishList: dish_images string is empty/NA');
                return images;
              }
              try {
                final decoded = jsonDecode(trimmed);
                if (decoded is List) {
                  for (final entry in decoded) {
                    addImage(entry);
                  }
                } else if (decoded is Map) {
                  for (final entry in decoded.values) {
                    addImage(entry);
                  }
                }
              } catch (e) {
                debugPrint('ChefPostedDishList: Unable to decode dish_images string: $e');
              }
            } else if (source is List) {
              for (final entry in source) {
                addImage(entry);
              }
            } else if (source is Map) {
              for (final entry in source.values) {
                addImage(entry);
              }
            } else if (source != null) {
              debugPrint(
                  'ChefPostedDishList: dish_images unexpected type=${source.runtimeType} value=$source');
            }

            return images;
          }

          void addDish(dynamic item) {
            if (item is String) {
              final trimmed = item.trim();
              if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
                return;
              }
              try {
                final decoded = jsonDecode(trimmed);
                addDish(decoded);
              } catch (e) {
                debugPrint('ChefPostedDishList: Unable to decode dish string: $e');
              }
              return;
            }
            if (item is Map<String, dynamic>) {
              final normalized = Map<String, dynamic>.from(item);
              normalized['dish_images'] =
                  _normalizeDishImages(item['dish_images']);
              _debugPrintFull('ChefPostedDishList: normalized dish=', normalized);
              dishList.add(normalized);
            } else if (item is Map) {
              final map = Map<String, dynamic>.from(item as Map);
              map['dish_images'] = _normalizeDishImages(map['dish_images']);
              _debugPrintFull('ChefPostedDishList: normalized dish=', map);
              dishList.add(map);
            }
          }

          if (postsDynamic is List) {
            for (final item in postsDynamic) {
              addDish(item);
            }
          } else if (postsDynamic is Map) {
            for (final value in postsDynamic.values) {
              addDish(value);
            }
          } else if (postsDynamic is String) {
            try {
              final decoded = jsonDecode(postsDynamic);
              if (decoded is List) {
                for (final item in decoded) {
                  addDish(item);
                }
              } else if (decoded is Map) {
                for (final value in decoded.values) {
                  addDish(value);
                }
              }
            } catch (e) {
              debugPrint('ChefPostedDishList: Unable to decode all_post: $e');
            }
          }

          if (dishList.isEmpty) {
            return const Center(child: Text('No dish available'));
          }

          _debugPrintFull(
              'ChefPostedDishList: final normalized list length=${dishList.length} data=',
              dishList);

          return Padding(
            padding:
                EdgeInsets.only(top: SizeConfig.getSize20(context: context)),
                  child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height * 0.75),
              ),
                      itemCount: dishList.length,
                      itemBuilder: (context, index) {
                final data = dishList[index];
                final String dishName = data['dish_name']?.toString() ?? '';
                final String dishPrice = data['dish_price']?.toString() ?? '0';
                final String startTime = data['start_time']?.toString() ?? '';
                final String endTime = data['end_time']?.toString() ?? '';

                String imageUrl = '';
                final dynamic dishImagesDynamic = data['dish_images'];
                if (dishImagesDynamic is List && dishImagesDynamic.isNotEmpty) {
                  final firstImage = dishImagesDynamic.first;
                  if (firstImage is Map && firstImage['kitchen_image'] != null) {
                    imageUrl = firstImage['kitchen_image'].toString();
                  } else if (firstImage is String) {
                    imageUrl = firstImage;
                  }
                }

                        return Card(
                          color: DynamicColor.boxColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    height: SizeConfig.getSizeHeightBy(
                                        context: context, by: 0.154),
                                    width: SizeConfig.getSizeWidthBy(
                                        context: context, by: 0.37),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CustomNetworkImage(
                                        url: imageUrl,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dishName,
                                        style: white14w5,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text('$currencySymbol$dishPrice',
                                        style: greenColor15bold,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 10),
                                    Center(
                                        child: Text('Dish Serving time',
                                            style: white15bold)),
                                    Center(
                                      child: Text(
                                          startTime.isEmpty && endTime.isEmpty
                                              ? 'Not specified'
                                              : '$startTime - $endTime',
                                          style: primary15w5),
                                    ),
                                  ],
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Share.share(
                                            'https://play.google.com/store');
                                      },
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            DynamicColor.primaryColor,
                                        child: Icon(Icons.share,
                                            size: 20,
                                            color: DynamicColor.white),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        PageNavigateScreen().push(
                                            context,
                                            EditChefPostDishForm(
                                                dishData: data));
                                      },
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            DynamicColor.secondryColor,
                                        child: Icon(Icons.edit,
                                            size: 20,
                                            color: DynamicColor.white),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible:
                                                Platform.isAndroid
                                                    ? false
                                                    : true,
                                          builder: (context) => DeleteDishPopUp(
                                            dishID: data['dish_id']
                                                ?.toString(),
                                            userType: getUserType,
                                          ),
                                        ).then((value) => context
                                            .read<DataProvider>()
                                            .fetchUserProfile(
                                                forceRefresh: true));
                                      },
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.delete,
                                            size: 20,
                                            color: DynamicColor.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
            );

        },
      ),
    );
  }
}
