import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthFlowProvider extends ChangeNotifier {
  // Authentication states
  bool _isLoading = false;
  String _error = '';
  String _currentStep = 'login'; // login, register, otp, forgot_password, reset_password
  Map<String, dynamic> _pendingUserData = {};
  String _pendingEmail = '';
  String _pendingType = ''; // register, forgot_password, etc.

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentStep => _currentStep;
  Map<String, dynamic> get pendingUserData => _pendingUserData;
  String get pendingEmail => _pendingEmail;
  String get pendingType => _pendingType;

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

  // Set current step
  void setCurrentStep(String step) {
    _currentStep = step;
    notifyListeners();
  }

  // Save pending user data (for registration flow)
  void savePendingUserData(Map<String, dynamic> userData, String email, String type) {
    _pendingUserData = userData;
    _pendingEmail = email;
    _pendingType = type;
    notifyListeners();
  }

  // Clear pending data
  void clearPendingData() {
    _pendingUserData = {};
    _pendingEmail = '';
    _pendingType = '';
    notifyListeners();
  }

  // Check if user account is verified
  Future<bool> isAccountVerified() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('data');
      String? verificationStatus = prefs.getString('verification_status');
      
      if (userDataString != null && verificationStatus != null) {
        return verificationStatus == 'verified';
      }
      return false;
    } catch (e) {
      debugPrint('Error checking verification status: $e');
      return false;
    }
  }

  // Save verification status
  Future<void> saveVerificationStatus(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('verification_status', status);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving verification status: $e');
    }
  }

  // Complete registration flow
  Future<void> completeRegistration() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Save user data
      await prefs.setString('data', jsonEncode(_pendingUserData));
      await prefs.setString('user_type', _pendingUserData['user_type'] ?? '');
      await prefs.setString('verification_status', 'verified');
      
      // Clear pending data
      clearPendingData();
      setCurrentStep('login');
      
    } catch (e) {
      _setError('Failed to complete registration: $e');
    }
  }

  // Handle OTP verification success
  Future<void> handleOtpSuccess() async {
    if (_pendingType == 'register') {
      await completeRegistration();
    } else if (_pendingType == 'forgot_password') {
      setCurrentStep('reset_password');
    }
  }

  // Check authentication flow and redirect accordingly
  Future<String> getNextScreen() async {
    bool isVerified = await isAccountVerified();
    
    if (_currentStep == 'register' && !isVerified) {
      return 'otp';
    } else if (_currentStep == 'login' && !isVerified) {
      return 'otp';
    } else if (_currentStep == 'otp') {
      if (_pendingType == 'register') {
        return 'login';
      } else if (_pendingType == 'forgot_password') {
        return 'reset_password';
      }
    }
    
    return 'home';
  }
}
