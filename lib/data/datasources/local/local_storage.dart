import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<void> saveUserData(Map<String, dynamic> userData);
  Future<void> saveUserType(String userType);
  Future<void> saveAuthToken(String token);
  Future<Map<String, dynamic>?> getUserData();
  Future<String?> getUserType();
  Future<String?> getAuthToken();
  Future<void> clearUserData();
  Future<void> saveCartData(List<Map<String, dynamic>> cartData);
  Future<List<Map<String, dynamic>>> getCartData();
  Future<void> saveLocationData(Map<String, dynamic> locationData);
  Future<Map<String, dynamic>?> getLocationData();
  Future<bool> isAccountVerified();
  Future<void> saveVerificationStatus(String status);
  Future<void> completeRegistration(Map<String, dynamic> userData);
  Future<void> completeLogin(Map<String, dynamic> userData, String token);
  Future<void> logout();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await sharedPreferences.setString('data', jsonEncode(userData));
  }

  @override
  Future<void> saveUserType(String userType) async {
    await sharedPreferences.setString('user_type', userType);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString('auth_token', token);
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final data = sharedPreferences.getString('data');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  @override
  Future<String?> getUserType() async {
    return sharedPreferences.getString('user_type');
  }

  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString('auth_token');
  }

  @override
  Future<void> clearUserData() async {
    await sharedPreferences.remove('data');
    await sharedPreferences.remove('user_type');
    await sharedPreferences.remove('auth_token');
  }

  @override
  Future<void> saveCartData(List<Map<String, dynamic>> cartData) async {
    await sharedPreferences.setString('cart', jsonEncode(cartData));
  }

  @override
  Future<List<Map<String, dynamic>>> getCartData() async {
    final data = sharedPreferences.getString('cart');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => Map<String, dynamic>.from(json)).toList();
    }
    return [];
  }

  @override
  Future<void> saveLocationData(Map<String, dynamic> locationData) async {
    await sharedPreferences.setString('guestLatLong', jsonEncode(locationData));
  }

  @override
  Future<Map<String, dynamic>?> getLocationData() async {
    final data = sharedPreferences.getString('guestLatLong');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  @override
  Future<bool> isAccountVerified() async {
    try {
      String? verificationStatus = await sharedPreferences.getString('verification_status');
      return verificationStatus == 'verified';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveVerificationStatus(String status) async {
    await sharedPreferences.setString('verification_status', status);
  }

  @override
  Future<void> completeRegistration(Map<String, dynamic> userData) async {
    await sharedPreferences.setString('data', jsonEncode(userData));
    await sharedPreferences.setString('user_type', userData['user_type'] ?? '');
    await sharedPreferences.setString('verification_status', 'verified');
    await sharedPreferences.setString('auth_token', userData['token'] ?? '');
  }

  @override
  Future<void> completeLogin(Map<String, dynamic> userData, String token) async {
    await sharedPreferences.setString('data', jsonEncode(userData));
    await sharedPreferences.setString('user_type', userData['user_type'] ?? '');
    await sharedPreferences.setString('verification_status', 'verified');
    await sharedPreferences.setString('auth_token', token);
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.clear();
  }
}
