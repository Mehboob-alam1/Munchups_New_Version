import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.getString('data');
      var latlong = prefs.getString('guestLatLong');

      String url = '';
      if (userData != null) {
        var userDataMap = jsonDecode(userData);
        url = Utils.baseUrl() +
            'getall_chef_or_grocer_with_detail.php/?user_id=' +
            userDataMap['user_id'].toString();
      } else if (latlong != null) {
        var latlongMap = jsonDecode(latlong);
        url = Utils.baseUrl() +
            'getall_chef_or_grocer_with_detail.php/?latitude=${latlongMap['lat'].toString()}&longitude=${latlongMap['long'].toString()}';
      } else {
        throw Exception('No location data available');
      }

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        _homeData = data['data'] ?? [];
        _chefsList = data['chefs'] ?? [];
        _grocersList = data['grocers'] ?? [];
      } else {
        throw Exception('Failed to load home data');
      }
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
      var userData = prefs.getString('data');
      String? getUserType = prefs.getString('user_type');
      
      if (userData == null || getUserType == null) {
        throw Exception('User not authenticated');
      }

      var userDataMap = jsonDecode(userData);
      String url = Utils.baseUrl() +
          'get_profile.php?user_id=${userDataMap['user_id'].toString()}&user_type=$getUserType';
      
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _userProfile = data['data'] ?? {};
      } else {
        throw Exception('Failed to load profile');
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.getString('data');
      
      String url = Utils.baseUrl() + 'search_users.php?query=$query';
      if (userData != null) {
        var userDataMap = jsonDecode(userData);
        url += '&user_id=${userDataMap['user_id']}';
      }

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _searchResults = data['data'] ?? [];
      } else {
        throw Exception('Search failed');
      }
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
      var userData = prefs.getString('data');
      
      if (userData == null) {
        throw Exception('User not authenticated');
      }

      var userDataMap = jsonDecode(userData);
      String url = Utils.baseUrl() +
          'get_notifications.php?user_id=${userDataMap['user_id']}';

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _notifications = data['data'] ?? [];
        _unreadCount = data['unread_count'] ?? 0;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error fetching notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.getString('data');
      
      if (userData == null) return;

      var userDataMap = jsonDecode(userData);
      String url = Utils.baseUrl() +
          'mark_notification_read.php?notification_id=$notificationId&user_id=${userDataMap['user_id']}';

      await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      // Update local state
      await fetchNotifications();
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
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
