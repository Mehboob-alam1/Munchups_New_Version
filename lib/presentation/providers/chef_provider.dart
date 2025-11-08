import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/Chef/Home/home_model.dart';
import '../../Screens/Chef/Chef Followers/chef_follower_model.dart';
import '../../domain/entities/chef_dashboard_entity.dart';
import '../../domain/entities/chef_orders_entity.dart';
import '../../domain/entities/chef_followers_entity.dart';
import '../../domain/usecases/chef/fetch_chef_dashboard_usecase.dart';
import '../../domain/usecases/chef/fetch_chef_orders_usecase.dart';
import '../../domain/usecases/chef/fetch_chef_followers_usecase.dart';

class ChefProvider extends ChangeNotifier {
  final FetchChefDashboardUseCase fetchChefDashboardUseCase;
  final FetchChefOrdersUseCase fetchChefOrdersUseCase;
  final FetchChefFollowersUseCase fetchChefFollowersUseCase;

  ChefProvider({
    required this.fetchChefDashboardUseCase,
    required this.fetchChefOrdersUseCase,
    required this.fetchChefFollowersUseCase,
  });

  // Dashboard state
  bool _isDashboardLoading = false;
  String _dashboardError = '';
  List<OcCategoryOrderArr> _dashboardOccasions = <OcCategoryOrderArr>[];
  int _notificationCount = 0;

  // Orders state
  bool _isOrdersLoading = false;
  String _ordersError = '';
  List<Map<String, dynamic>> _orders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _activeBulkOrders =
      <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _completedBulkOrders =
      <Map<String, dynamic>>[];

  // Followers state
  bool _isFollowersLoading = false;
  String _followersError = '';
  List<ChefFollowersDetail> _followers = <ChefFollowersDetail>[];
  int _followersCount = 0;
  int _followingCount = 0;

  // Getters
  bool get isDashboardLoading => _isDashboardLoading;
  String get dashboardError => _dashboardError;
  List<OcCategoryOrderArr> get dashboardOccasions => _dashboardOccasions;
  int get notificationCount => _notificationCount;

  bool get isOrdersLoading => _isOrdersLoading;
  String get ordersError => _ordersError;
  List<Map<String, dynamic>> get orders => _orders;
  List<Map<String, dynamic>> get activeBulkOrders => _activeBulkOrders;
  List<Map<String, dynamic>> get completedBulkOrders =>
      _completedBulkOrders;

  bool get isFollowersLoading => _isFollowersLoading;
  String get followersError => _followersError;
  List<ChefFollowersDetail> get followers => _followers;
  int get followersCount => _followersCount;
  int get followingCount => _followingCount;

  void _setDashboardLoading(bool value) {
    _isDashboardLoading = value;
    notifyListeners();
  }

  void _setOrdersLoading(bool value) {
    _isOrdersLoading = value;
    notifyListeners();
  }

  void _setFollowersLoading(bool value) {
    _isFollowersLoading = value;
    notifyListeners();
  }

  void clearDashboardError() {
    _dashboardError = '';
    notifyListeners();
  }

  void clearOrdersError() {
    _ordersError = '';
    notifyListeners();
  }

  void clearFollowersError() {
    _followersError = '';
    notifyListeners();
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('data');
    if (dataString == null) return null;
    final dynamic userData = jsonDecode(dataString);
    return userData['user_id']?.toString();
  }

  Future<String?> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_type');
  }

  Future<void> loadDashboard({bool forceRefresh = false}) async {
    if (_dashboardOccasions.isNotEmpty && !forceRefresh) {
      return;
    }

    _setDashboardLoading(true);
    _dashboardError = '';

    try {
      final userId = await _getUserId();
      if (userId == null) {
        _dashboardError = 'User session expired';
        return;
      }

      final result = await fetchChefDashboardUseCase(userId);
      result.fold(
        (failure) => _dashboardError = failure.message,
        (ChefDashboardEntity success) {
          _dashboardOccasions = success.occasions
              .map((item) => OcCategoryOrderArr.fromJson(item))
              .toList();
          _notificationCount = success.notificationCount;
        },
      );
    } catch (e) {
      _dashboardError = e.toString();
    } finally {
      _setDashboardLoading(false);
    }
  }

  Future<void> loadOrders({bool forceRefresh = false}) async {
    if (_orders.isNotEmpty && !forceRefresh) {
      return;
    }

    _setOrdersLoading(true);
    _ordersError = '';

    try {
      final userId = await _getUserId();
      if (userId == null) {
        _ordersError = 'User session expired';
        return;
      }

      final result = await fetchChefOrdersUseCase(userId);
      result.fold(
        (failure) => _ordersError = failure.message,
        (ChefOrdersEntity success) {
          _orders = success.orders;
          _activeBulkOrders = success.activeBulkOrders;
          _completedBulkOrders = success.completedBulkOrders;
        },
      );
    } catch (e) {
      _ordersError = e.toString();
    } finally {
      _setOrdersLoading(false);
    }
  }

  Future<void> loadFollowers({bool forceRefresh = false}) async {
    if (_followers.isNotEmpty && !forceRefresh) {
      return;
    }

    _setFollowersLoading(true);
    _followersError = '';

    try {
      final userId = await _getUserId();
      final userType = await _getUserType();
      if (userId == null || userType == null) {
        _followersError = 'User session expired';
        return;
      }

      final result = await fetchChefFollowersUseCase(
        FetchChefFollowersParams(userId: userId, userType: userType),
      );

      result.fold(
        (failure) => _followersError = failure.message,
        (ChefFollowersEntity success) {
          _followers = success.followers
              .map((item) => ChefFollowersDetail.fromJson(item))
              .toList();
          _followersCount = success.followersCount;
          _followingCount = success.followingCount;
        },
      );
    } catch (e) {
      _followersError = e.toString();
    } finally {
      _setFollowersLoading(false);
    }
  }
}

