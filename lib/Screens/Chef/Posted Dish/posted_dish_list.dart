import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:munchups_app/Comman widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class ChefPostedDishListPage extends StatefulWidget {
  const ChefPostedDishListPage({super.key});

  @override
  State<ChefPostedDishListPage> createState() => _ChefPostedDishListPageState();
}

class _ChefPostedDishListPageState extends State<ChefPostedDishListPage> {
  String _userType = 'chef';
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _profileSnapshot;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userType = prefs.getString('user_type');
      final String? userDataString = prefs.getString('data');

      if (userType == null || userDataString == null) {
        throw Exception('User credentials are missing. Please log in again.');
      }

      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(jsonDecode(userDataString));
      final String? userId = userData['user_id']?.toString();

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found in stored profile.');
      }

      setState(() {
        _userType = userType;
      });

      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://munchups.com/webservice/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final response = await dio.get(
        'get_profile.php',
        queryParameters: {
          'user_id': userId,
          'user_type': userType,
        },
      );

      dynamic data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is! Map) {
        throw Exception('Unexpected response: $data');
      }

      final Map<String, dynamic> responseMap =
          Map<String, dynamic>.from(data as Map);
      final dynamic profileData = responseMap['profile_data'];

      Map<String, dynamic> normalizedProfile = {};
      if (profileData is Map<String, dynamic>) {
        normalizedProfile = profileData;
      } else if (profileData is Map) {
        normalizedProfile =
            Map<String, dynamic>.from(profileData as Map<dynamic, dynamic>);
      } else if (profileData is String) {
        final trimmed = profileData.trim();
        if (trimmed.isNotEmpty) {
          try {
            final decoded = jsonDecode(trimmed);
            if (decoded is Map) {
              normalizedProfile =
                  Map<String, dynamic>.from(decoded as Map<dynamic, dynamic>);
            }
          } catch (_) {}
        }
      }

      final dynamic allPost = _normalizeAllPost(normalizedProfile['all_post']);

      _profileSnapshot = {
        'requested_user_id': userId,
        'requested_user_type': userType,
        'success': responseMap['success'],
        'message': responseMap['msg'],
        'profile_data': normalizedProfile,
        'all_post_type': allPost?.runtimeType.toString(),
        'all_post': allPost,
      };
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  dynamic _normalizeAllPost(dynamic source) {
    if (source == null) {
      return null;
    }
    if (source is List) {
      return List<dynamic>.from(source);
    }
    if (source is Map) {
      return Map<String, dynamic>.from(source as Map);
    }
    if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
        return 'NA';
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return List<dynamic>.from(decoded);
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded as Map);
        }
        return decoded;
      } catch (_) {
        return trimmed;
      }
    }
    return source;
  }

  List<Map<String, dynamic>> _extractDishList() {
    if (_profileSnapshot == null) return [];
    final dynamic allPost = _profileSnapshot!['all_post'];
    return _normalizeDishList(allPost);
  }

  List<Map<String, dynamic>> _normalizeDishList(dynamic source) {
    final List<Map<String, dynamic>> dishes = [];

    void add(dynamic item, {int depth = 0}) {
      if (item == null || depth > 5) {
        return;
      }

      if (item is String) {
        final trimmed = item.trim();
        if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
          return;
        }
        try {
          final decoded = jsonDecode(trimmed);
          add(decoded, depth: depth + 1);
        } catch (_) {
          // treat plain string dish name?
        }
        return;
      }

      if (item is List) {
        for (final entry in item) {
          add(entry, depth: depth + 1);
        }
        return;
      }

      if (item is Map<String, dynamic>) {
        final normalized = Map<String, dynamic>.from(item);
        normalized['dish_images'] =
            _normalizeImageUrls(normalized['dish_images']);
        dishes.add(normalized);
        return;
      }

      if (item is Map) {
        final normalized = Map<String, dynamic>.from(item as Map);
        normalized['dish_images'] =
            _normalizeImageUrls(normalized['dish_images']);
        dishes.add(normalized);
        return;
      }
    }

    add(source);
    return dishes;
  }

  List<String> _normalizeImageUrls(dynamic source) {
    final List<String> urls = [];

    void addUrl(dynamic value) {
      if (value == null) return;
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') return;
        urls.add(trimmed);
        return;
      }
      if (value is Map) {
        addUrl(value['kitchen_image']);
        addUrl(value['image']);
      }
    }

    if (source is List) {
      for (final entry in source) {
        addUrl(entry);
      }
    } else if (source is Map) {
      for (final value in source.values) {
        addUrl(value);
      }
    } else if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty || trimmed.toUpperCase() == 'NA') {
        return urls;
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          for (final entry in decoded) {
            addUrl(entry);
          }
        } else if (decoded is Map) {
          for (final value in decoded.values) {
            addUrl(value);
          }
        } else {
          addUrl(trimmed);
        }
      } catch (_) {
        addUrl(trimmed);
      }
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackIconCustomAppBar(title: 'Posted Dishes')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> dishes = _extractDishList();

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: dishes.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              children: const [
                Icon(Icons.restaurant, size: 64, color: DynamicColor.primaryColor),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'You have not posted any dishes yet.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Create your first dish to showcase it here.',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      itemBuilder: (context, index) {
                final dish = dishes[index];
                return _DishCard(
                  dish: dish,
                  userType: _userType,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemCount: dishes.length,
            ),
    );
  }
}

class _DishCard extends StatelessWidget {
  final Map<String, dynamic> dish;
  final String userType;

  const _DishCard({
    required this.dish,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images =
        (dish['dish_images'] as List?)?.cast<String>() ?? const [];
    final String? name = dish['dish_name']?.toString();
    final String? price = dish['dish_price']?.toString();
    final String? date = dish['dish_date']?.toString();
    final String? startTime = dish['start_time']?.toString();
    final String? endTime = dish['end_time']?.toString();
    final String? description = dish['dish_description']?.toString();
    final String? meal = dish['meal']?.toString();
    final String? serviceType = dish['service_type']?.toString();
    final String? portion = dish['portion']?.toString();
    final String? criteria = dish['criteria']?.toString();

    final primaryImage = images.isNotEmpty ? images.first : null;
    final gallery = images.length > 1 ? images.sublist(1) : const <String>[];

    return Container(
      decoration: BoxDecoration(
        color: DynamicColor.boxColor.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  child: SizedBox(
              height: SizeConfig.getSizeHeightBy(context: context, by: 0.22),
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  primaryImage == null
                      ? Container(
                          color: Colors.grey.shade400,
                          child: const Icon(Icons.restaurant,
                              size: 48, color: Colors.white),
                        )
                      : CustomNetworkImage(
                          url: primaryImage,
                          fit: BoxFit.cover,
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            name ?? 'Untitled Dish',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: white21w5,
                          ),
                        ),
                        if (price != null && price.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: DynamicColor.primaryColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              _formatPrice(price),
                              style: white14w5,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                                  ),
                                ),
                              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (meal != null && meal.isNotEmpty)
                      _MetaChip(
                        icon: Icons.local_dining,
                        label: meal,
                      ),
                    if (serviceType != null && serviceType.isNotEmpty)
                      _MetaChip(
                        icon: Icons.delivery_dining,
                        label: serviceType,
                      ),
                    if (date != null && date.isNotEmpty)
                      _MetaChip(
                        icon: Icons.calendar_today,
                        label: date,
                      ),
                    if ((startTime != null && startTime.isNotEmpty) ||
                        (endTime != null && endTime.isNotEmpty))
                      _MetaChip(
                        icon: Icons.schedule,
                        label:
                            '${startTime ?? ''}${startTime != null && endTime != null ? ' - ' : ''}${endTime ?? ''}',
                      ),
                    if (portion != null && portion.isNotEmpty)
                      _MetaChip(
                        icon: Icons.group,
                        label: 'Portion: $portion',
                      ),
                    if (criteria != null && criteria.isNotEmpty)
                      _MetaChip(
                        icon: Icons.flag,
                        label: 'Criteria: $criteria',
                      ),
                    _MetaChip(
                      icon: Icons.person,
                      label: userType.toUpperCase(),
                                    ),
                                  ],
                                ),
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ],
            ),
          ),
          if (gallery.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView.separated(
                padding:
                    const EdgeInsets.only(left: 18, right: 18, bottom: 18),
                scrollDirection: Axis.horizontal,
                itemCount: gallery.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final url = gallery[index];
                  return _GalleryThumbnail(imageUrl: url);
                },
                                      ),
                                    ),
                                  ],
                                ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: DynamicColor.primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DynamicColor.primaryColor.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: DynamicColor.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
          ),
                            ],
                          ),
                        );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  final String imageUrl;

  const _GalleryThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomNetworkImage(
          url: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

String _formatPrice(String? raw) {
  if (raw == null || raw.isEmpty) return '${currencySymbol}0';
  final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
  final value = double.tryParse(cleaned);
  if (value == null) {
    return '$currencySymbol$raw';
  }
  return '$currencySymbol${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}';
}
