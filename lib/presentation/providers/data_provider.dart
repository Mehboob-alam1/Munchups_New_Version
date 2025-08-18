import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
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
      final result = await fetchHomeDataUseCase(null);
      
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
      // This would need the actual user ID and type
      final result = await fetchUserProfileUseCase({
        'userId': 'temp_user_id',
        'userType': 'temp_user_type',
      });
      
      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (success) {
          _userProfile = success;
        },
      );
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
