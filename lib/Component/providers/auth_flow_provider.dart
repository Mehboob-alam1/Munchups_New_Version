import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/usecases/auth/auth_flow_usecase.dart';

class AuthFlowProvider extends ChangeNotifier {
  final AuthFlowUseCase _authFlowUseCase;
  
  AuthFlowProvider({required AuthFlowUseCase authFlowUseCase}) 
      : _authFlowUseCase = authFlowUseCase;

  // Authentication states
  bool _isLoading = false;
  String _error = '';
  String _currentStep = 'login'; // login, register, otp, forgot_password, reset_password, home
  Map<String, dynamic> _pendingUserData = {};
  String _pendingEmail = '';
  String _pendingType = ''; // register, login, forgot_password
  bool _isInitialized = false;

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentStep => _currentStep;
  Map<String, dynamic> get pendingUserData => _pendingUserData;
  String get pendingEmail => _pendingEmail;
  String get pendingType => _pendingType;
  bool get isInitialized => _isInitialized;

  // Initialize auth state on app start
  Future<void> initializeAuthState() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Check if user is logged in
      String? userDataString = prefs.getString('data');
      String? authToken = prefs.getString('auth_token');
      String? verificationStatus = prefs.getString('verification_status');
      String? savedStep = prefs.getString('auth_step');
      String? savedEmail = prefs.getString('pending_email');
      String? savedType = prefs.getString('pending_type');
      
      if (userDataString != null && authToken != null) {
        // User is logged in
        if (verificationStatus == 'verified') {
          _currentStep = 'home';
        } else {
          // User is logged in but not verified
          _currentStep = 'otp';
          _pendingEmail = savedEmail ?? '';
          _pendingType = savedType ?? 'login';
        }
      } else if (savedStep != null && savedEmail != null) {
        // User was in middle of auth process
        _currentStep = savedStep;
        _pendingEmail = savedEmail;
        _pendingType = savedType ?? 'register';
        
        // Load pending user data if available
        String? pendingDataString = prefs.getString('pending_user_data');
        if (pendingDataString != null) {
          _pendingUserData = jsonDecode(pendingDataString);
        }
      } else {
        // Fresh start
        _currentStep = 'login';
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing auth state: $e');
      _currentStep = 'login';
      _isInitialized = true;
    } finally {
      _setLoading(false);
    }
  }

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

  // Set current step and save to preferences
  Future<void> setCurrentStep(String step) async {
    _currentStep = step;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_step', step);
    } catch (e) {
      debugPrint('Error saving auth step: $e');
    }
    notifyListeners();
  }

  // Save pending user data (for registration flow)
  Future<void> savePendingUserData(Map<String, dynamic> userData, String email, String type) async {
    _pendingUserData = userData;
    _pendingEmail = email;
    _pendingType = type;
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_user_data', jsonEncode(userData));
      await prefs.setString('pending_email', email);
      await prefs.setString('pending_type', type);
    } catch (e) {
      debugPrint('Error saving pending user data: $e');
    }
    
    notifyListeners();
  }

  // Clear pending data
  Future<void> clearPendingData() async {
    _pendingUserData = {};
    _pendingEmail = '';
    _pendingType = '';
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('pending_user_data');
      await prefs.remove('pending_email');
      await prefs.remove('pending_type');
      await prefs.remove('auth_step');
    } catch (e) {
      debugPrint('Error clearing pending data: $e');
    }
    
    notifyListeners();
  }

  // Check if user account is verified
  Future<bool> isAccountVerified() async {
    return await _authFlowUseCase.isAccountVerified();
  }

  // Save verification status
  Future<void> saveVerificationStatus(String status) async {
    await _authFlowUseCase.saveVerificationStatus(status);
    notifyListeners();
  }

  // Complete registration flow
  Future<void> completeRegistration() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Save user data
      await prefs.setString('data', jsonEncode(_pendingUserData));
      await prefs.setString('user_type', _pendingUserData['user_type'] ?? '');
      await prefs.setString('verification_status', 'verified');
      await prefs.setString('auth_token', _pendingUserData['token'] ?? '');
      
      // Clear pending data
      await clearPendingData();
      await setCurrentStep('home');
      
    } catch (e) {
      _setError('Failed to complete registration: $e');
    }
  }

  // Complete login flow
  Future<void> completeLogin(Map<String, dynamic> userData, String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Save user data
      await prefs.setString('data', jsonEncode(userData));
      await prefs.setString('user_type', userData['user_type'] ?? '');
      await prefs.setString('verification_status', 'verified');
      await prefs.setString('auth_token', token);
      
      // Clear pending data
      await clearPendingData();
      await setCurrentStep('home');
      
    } catch (e) {
      _setError('Failed to complete login: $e');
    }
  }

  // Handle OTP verification success
  Future<void> handleOtpSuccess() async {
    if (_pendingType == 'register') {
      await completeRegistration();
    } else if (_pendingType == 'login') {
      // For login, we need to get the user data from the login response
      // This should be called after successful OTP verification
      await setCurrentStep('home');
    } else if (_pendingType == 'forgot_password') {
      await setCurrentStep('reset_password');
    }
  }

  // Start registration flow
  Future<void> startRegistration(Map<String, dynamic> userData, String email) async {
    await savePendingUserData(userData, email, 'register');
    await setCurrentStep('otp');
  }

  // Start login flow (when account not activated)
  Future<void> startLoginVerification(String email) async {
    await savePendingUserData({}, email, 'login');
    await setCurrentStep('otp');
  }

  // Start forgot password flow
  Future<void> startForgotPassword(String email) async {
    await savePendingUserData({}, email, 'forgot_password');
    await setCurrentStep('otp');
  }

  // Logout
  Future<void> logout() async {
    await _authFlowUseCase.logout();
    
    _currentStep = 'login';
    _pendingUserData = {};
    _pendingEmail = '';
    _pendingType = '';
    _error = '';
    
    notifyListeners();
  }

  // Get the next screen based on current state
  String getNextScreen() {
    switch (_currentStep) {
      case 'login':
        return 'login';
      case 'register':
        return 'register';
      case 'otp':
        return 'otp';
      case 'forgot_password':
        return 'forgot_password';
      case 'reset_password':
        return 'reset_password';
      case 'home':
        return 'home';
      default:
        return 'login';
    }
  }

  // Check if user needs OTP verification
  bool needsOtpVerification() {
    return _currentStep == 'otp' && _pendingEmail.isNotEmpty;
  }

  // Get OTP type for display
  String getOtpType() {
    return _pendingType;
  }

  // Get OTP email
  String getOtpEmail() {
    return _pendingEmail;
  }
}
