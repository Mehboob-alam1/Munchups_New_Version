import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _error = '';
  String _userType = '';
  Map<String, dynamic> _userData = {};
  String _authToken = '';

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get error => _error;
  String get userType => _userType;
  Map<String, dynamic> get userData => _userData;
  String get authToken => _authToken;

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

  // Initialize authentication state
  Future<void> initializeAuth() async {
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      String? userTypeString = prefs.getString('user_type');
      String? tokenString = prefs.getString('auth_token');

      if (userDataString != null && userTypeString != null) {
        _userData = jsonDecode(userDataString);
        _userType = userTypeString;
        _authToken = tokenString ?? '';
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _userData = {};
        _userType = '';
        _authToken = '';
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      _isAuthenticated = false;
      _userData = {};
      _userType = '';
      _authToken = '';
    } finally {
      _setLoading(false);
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError('');

    try {
      String url = Utils.baseUrl() + 'login.php';
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          // Safely handle the data field - it might be a Map or List
          Map<String, dynamic> userData = {};
          if (data['data'] is Map<String, dynamic>) {
            userData = data['data'];
          } else if (data['data'] is Map) {
            userData = Map<String, dynamic>.from(data['data']);
          }
          
          await _saveUserSession(
            userData, 
            data['user_type']?.toString() ?? '', 
            data['token']?.toString() ?? ''
          );
          return true;
        } else {
          _setError(data['message']?.toString() ?? 'Login failed');
          return false;
        }
      } else {
        _setError('Network error occurred');
        return false;
      }
    } catch (e) {
      _setError('An error occurred: $e');
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register method
  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    _setError('');

    try {
      String url = Utils.baseUrl() + 'register.php';
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          // Safely handle the data field - it might be a Map or List
          Map<String, dynamic> userData = {};
          if (data['data'] is Map<String, dynamic>) {
            userData = data['data'];
          } else if (data['data'] is Map) {
            userData = Map<String, dynamic>.from(data['data']);
          }
          
          await _saveUserSession(
            userData, 
            data['user_type']?.toString() ?? '', 
            data['token']?.toString() ?? ''
          );
          return true;
        } else {
          _setError(data['message']?.toString() ?? 'Registration failed');
          return false;
        }
      } else {
        _setError('Network error occurred');
        return false;
      }
    } catch (e) {
      _setError('An error occurred: $e');
      debugPrint('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp, String email) async {
    _setLoading(true);
    _setError('');

    try {
      String url = Utils.baseUrl() + 'activate_account.php?guid=$otp&email=$email';
      
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          return true;
        } else {
          _setError(data['message'] ?? 'OTP verification failed');
          return false;
        }
      } else {
        _setError('Network error occurred');
        return false;
      }
    } catch (e) {
      _setError('An error occurred: $e');
      debugPrint('OTP verification error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Resend OTP
  Future<bool> resendOtp(String email) async {
    _setLoading(true);
    _setError('');

    try {
      String url = Utils.baseUrl() + 'resend_code.php?email=$email';
      
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          return true;
        } else {
          _setError(data['message'] ?? 'Failed to resend OTP');
          return false;
        }
      } else {
        _setError('Network error occurred');
        return false;
      }
    } catch (e) {
      _setError('An error occurred: $e');
      debugPrint('Resend OTP error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _setError('');

    try {
      String url = Utils.baseUrl() + 'forgot_password.php?email=$email';
      
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          return true;
        } else {
          _setError(data['message'] ?? 'Password reset failed');
          return false;
        }
      } else {
        _setError('Network error occurred');
        return false;
      }
    } catch (e) {
      _setError('An error occurred: $e');
      debugPrint('Forgot password error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Save user session
  Future<void> _saveUserSession(Map<String, dynamic> userData, String userType, String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', jsonEncode(userData));
      await prefs.setString('user_type', userType);
      await prefs.setString('auth_token', token);
      
      _userData = userData;
      _userType = userType;
      _authToken = token;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user session: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('data');
      await prefs.remove('user_type');
      await prefs.remove('auth_token');
      
      _userData = {};
      _userType = '';
      _authToken = '';
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  // Check if user is authenticated
  bool get isLoggedIn => _isAuthenticated;

  // Get user ID
  String? get userId => _userData['user_id']?.toString();

  // Get user email
  String? get userEmail => _userData['email']?.toString();

  // Get user name
  String? get userName => _userData['name']?.toString();
}
