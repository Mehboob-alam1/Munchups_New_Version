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
  Map<String, dynamic> _homeData = {};
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
  Map<String, dynamic> get homeData => _homeData;
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
          final bool isSuccessful = success['success'] == true;
          if (!isSuccessful) {
            _homeData = success['raw'] ?? {};
            _chefsList = [];
            _grocersList = [];
            _setError(success['message']?.toString() ?? 'Failed to load home data');
          } else {
            _homeData = Map<String, dynamic>.from(success['raw'] ?? {});
            _chefsList = List<dynamic>.from(success['chefs'] ?? const []);
            _grocersList = List<dynamic>.from(success['grocers'] ?? const []);
          }
        },
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error fetching home data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Profile methods
  Future<void> fetchUserProfile({bool forceRefresh = false}) async {
    if (_userProfile.isNotEmpty && !forceRefresh) {
      return;
    }

    _setLoading(true);
    _setError('');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      String? userType = prefs.getString('user_type');

      if (userDataString == null || userType == null) {
        throw Exception('No user data found');
      }

      Map<String, dynamic> userData = jsonDecode(userDataString);

      final result = await fetchUserProfileUseCase({
        'userId': userData['user_id'].toString(),
        'userType': userType,
      });

      Map<String, dynamic>? normalizedProfile;

      Map<String, dynamic> _convertToMap(Map source) {
        return source.map((key, value) => MapEntry(key.toString(), value));
      }

      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (success) {
          final data = success['data'];

          if (data is Map<String, dynamic>) {
            normalizedProfile = Map<String, dynamic>.from(data);
          } else if (data is Map) {
            normalizedProfile = _convertToMap(data);
          } else if (data is List && data.isNotEmpty) {
            final first = data.first;
            if (first is Map<String, dynamic>) {
              normalizedProfile = Map<String, dynamic>.from(first);
            } else if (first is Map) {
              normalizedProfile = _convertToMap(first);
            }
          } else if (success['profile_data'] is Map) {
            normalizedProfile =
                _convertToMap(success['profile_data'] as Map<dynamic, dynamic>);
          }

          if (normalizedProfile != null) {
            _userProfile = {
              'success': success['success'],
              'msg': success['msg'],
              'profile_data': normalizedProfile,
            };
          } else {
            _userProfile = {};
          }
        },
      );

      if (normalizedProfile != null) {
        // Persist latest profile snapshot for compatibility with legacy flows
        await prefs.setString('data', jsonEncode(normalizedProfile));
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
      if (query.isEmpty) {
        _searchResults = [];
        return;
      }

      final result = await searchUsersUseCase({
        'query': query,
        'userId': null,
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
      final result = await fetchNotificationsUseCase('temp_user_id');

      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (success) {
          _notifications = success;
          _unreadCount = success.where((n) => n['isRead'] == false).length;
        },
      );
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error fetching notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await Future.wait([
      fetchHomeData(),
      fetchUserProfile(),
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
