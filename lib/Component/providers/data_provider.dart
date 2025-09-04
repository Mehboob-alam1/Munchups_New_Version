import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failures.dart';
import '../../domain/usecases/data/fetch_home_data_usecase.dart';
import '../../domain/usecases/data/fetch_user_profile_usecase.dart';
import '../../domain/usecases/data/search_users_usecase.dart';
import '../../domain/usecases/data/fetch_notifications_usecase.dart';

class DataProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  
  // Home data
  List<dynamic> _homeData = [];
  List<dynamic> _chefsList = [];
  List<dynamic> _grocersList = [];
  
  // Search data
  List<dynamic> _searchResults = [];
  String _searchQuery = '';
  
  // Profile data
  Map<String, dynamic> _userProfile = {};
  
  // Notifications
  List<dynamic> _notifications = [];
  int _unreadCount = 0;

  // Use Cases
  final FetchHomeDataUseCase fetchHomeDataUseCase;
  final FetchUserProfileUseCase fetchUserProfileUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  final FetchNotificationsUseCase fetchNotificationsUseCase;

  DataProvider({
    required this.fetchHomeDataUseCase,
    required this.fetchUserProfileUseCase,
    required this.searchUsersUseCase,
    required this.fetchNotificationsUseCase,
  });

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  List<dynamic> get homeData => _homeData;
  List<dynamic> get chefsList => _chefsList;
  List<dynamic> get grocersList => _grocersList;
  List<dynamic> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get userProfile => _userProfile;
  List<dynamic> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  // Loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Error handling
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Home data methods
  Future<void> fetchHomeData() async {
    _setLoading(true);
    _setError('');
    
    try {
      // Get user data and location from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      String? latlongString = prefs.getString('guestLatLong');
      
      Map<String, dynamic>? params;
      
      if (userDataString != null) {
        // User is logged in
        Map<String, dynamic> userData = jsonDecode(userDataString);
        params = {
          'userId': userData['user_id'].toString(),
        };
      } else if (latlongString != null) {
        // Guest user with location
        Map<String, dynamic> latlong = jsonDecode(latlongString);
        params = {
          'location': {
            'lat': latlong['lat'].toString(),
            'long': latlong['long'].toString(),
          },
        };
      } else {
        throw Exception('No user data or location available');
      }
      
      final result = await fetchHomeDataUseCase(params);
      
      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (success) {
          _homeData = success['data'] ?? [];
          _chefsList = success['chefs'] ?? [];
          _grocersList = success['grocers'] ?? [];
        },
      );
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error fetching home data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Profile methods
  Future<void> fetchUserProfile() async {
    _setLoading(true);
    _setError('');
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        String userId = userData['user_id'].toString();
        String userType = userData['user_type'].toString();
        
        final result = await fetchUserProfileUseCase({
          'userId': userId,
          'userType': userType,
        });
        
        result.fold(
          (failure) {
            _setError(failure.message);
          },
          (success) {
            _userProfile = success;
          },
        );
      } else {
        throw Exception('No user data available');
      }
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error fetching user profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search methods
  Future<void> searchUsers(String query) async {
    _setLoading(true);
    _setError('');
    _searchQuery = query;
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      String? userId = userDataString != null 
          ? jsonDecode(userDataString)['user_id'].toString() 
          : null;
      
      final result = await searchUsersUseCase({
        'query': query,
        'userId': userId,
      });
      
      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (success) {
          _searchResults = success;
        },
      );
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error searching users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Notification methods
  Future<void> fetchNotifications() async {
    _setLoading(true);
    _setError('');
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        String userId = userData['user_id'].toString();
        
        final result = await fetchNotificationsUseCase(userId);
        
        result.fold(
          (failure) {
            _setError(failure.message);
          },
          (success) {
            _notifications = success;
            _unreadCount = _notifications.where((n) => n['is_read'] != '1').length;
          },
        );
      } else {
        throw Exception('No user data available');
      }
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error fetching notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Initialize all data
  Future<void> initializeData() async {
    await Future.wait([
      fetchHomeData(),
      fetchNotifications(),
    ]);
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }
}