import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppProvider extends ChangeNotifier {
  // App state
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _userType = '';
  Map<String, dynamic> _userData = {};
  ThemeMode _themeMode = ThemeMode.dark;
  
  // Global data
  String _googleApiKey = 'AIzaSyArVg2eeb6UbZtIgSHLEqUpHD1Itj5nYsw';
  String _apiKey = 'Fvo6g6H3XEaA7xFlMchbNA43771';
  String _dateFormat = 'dd-MM-yy';
  String _currencySymbol = '£';
  String _appLogoUrl = 'assets/images/logo_with_name.png';
  
  // Controllers
  TextEditingController homeSearchTextController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  
  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get userType => _userType;
  Map<String, dynamic> get userData => _userData;
  ThemeMode get themeMode => _themeMode;
  String get googleApiKey => _googleApiKey;
  String get apiKey => _apiKey;
  String get dateFormat => _dateFormat;
  String get currencySymbol => _currencySymbol;
  String get appLogoUrl => _appLogoUrl;

  // Initialize app
  Future<void> initializeApp() async {
    _setLoading(true);
    try {
      await _loadUserData();
      await _loadThemePreference();
    } catch (e) {
      debugPrint('Error initializing app: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // User authentication
  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      String? userTypeString = prefs.getString('user_type');
      
      if (userDataString != null && userTypeString != null) {
        _userData = jsonDecode(userDataString);
        _userType = userTypeString;
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _userData = {};
        _userType = '';
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      _isAuthenticated = false;
      _userData = {};
      _userType = '';
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData, String userType) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', jsonEncode(userData));
      await prefs.setString('user_type', userType);
      
      _userData = userData;
      _userType = userType;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('data');
      await prefs.remove('user_type');
      
      _userData = {};
      _userType = '';
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  // Theme management
  Future<void> _loadThemePreference() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? themeString = prefs.getString('theme_mode');
      if (themeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == themeString,
          orElse: () => ThemeMode.dark,
        );
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', mode.toString());
      _themeMode = mode;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Utility methods
  String formatAddress(String address) {
    if (address.length <= 80) {
      return address;
    }
    String firstPart = address.substring(3, 80);
    return '$firstPart...';
  }

  String formatMobileNumber(String mobileNumber) {
    if (mobileNumber.length < 2) {
      return mobileNumber;
    }
    String lastTwoDigits = mobileNumber.substring(mobileNumber.length - 2);
    String maskedDigits = 'X' * (mobileNumber.length - 2);
    return '$maskedDigits$lastTwoDigits';
  }

  @override
  void dispose() {
    homeSearchTextController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
