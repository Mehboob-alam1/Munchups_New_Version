import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../domain/usecases/auth/forgot_password_usecase.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _error = '';
  String _userType = '';
  Map<String, dynamic> _userData = {};
  String _authToken = '';

  // Use Cases
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.forgotPasswordUseCase,
  });

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

  // Login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError('');

    try {
      final result = await loginUseCase(LoginParams(email: email, password: password));
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) {
          _saveUserSession(success);
          return true;
        },
      );
    } catch (e) {
      _setError('An error occurred: $e');
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
      final result = await registerUseCase(userData);
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) {
          _saveUserSession(success);
          return true;
        },
      );
    } catch (e) {
      _setError('An error occurred: $e');
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
      final result = await verifyOtpUseCase({'otp': otp, 'email': email});
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) => success,
      );
    } catch (e) {
      _setError('An error occurred: $e');
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
      final result = await verifyOtpUseCase({'otp': '', 'email': email}); // This needs a proper resend OTP use case
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) => success,
      );
    } catch (e) {
      _setError('An error occurred: $e');
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
      final result = await forgotPasswordUseCase(email);
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) => success,
      );
    } catch (e) {
      _setError('An error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Save user session
  void _saveUserSession(Map<String, dynamic> sessionData) {
    _userData = sessionData['user_data'] ?? {};
    _userType = sessionData['user_type'] ?? '';
    _authToken = sessionData['token'] ?? '';
    _isAuthenticated = true;
    notifyListeners();
  }

  // Logout
  void logout() {
    _userData = {};
    _userType = '';
    _authToken = '';
    _isAuthenticated = false;
    notifyListeners();
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
