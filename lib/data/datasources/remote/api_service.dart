import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert'; // Added for jsonDecode
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../models/auth_response_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/home_data_model.dart';
import '../../models/search_response_model.dart';
import '../../models/notification_model.dart';
import '../../../Component/global_data/global_data.dart'; // Import global data

abstract class RemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(Map<String, dynamic> userData);
  Future<bool> verifyOtp(String otp, String email);
  Future<bool> resendOtp(String email);
  Future<bool> forgotPassword(String email);
  Future<UserProfileModel> getUserProfile(String userId, String userType);
  Future<HomeDataModel> getHomeData(String? userId, Map<String, dynamic>? location);
  Future<SearchResponseModel> searchUsers(String query, String? userId);
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<bool> markNotificationAsRead(String notificationId, String userId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  
  RemoteDataSourceImpl({required this.dio}) {
    _setupDio();
  }
  
  void _setupDio() {
    dio.options.baseUrl = 'https://munchups.com/webservice/';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptors for logging and error handling
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    
    dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('Dio Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      // Use FormData instead of JSON data for the server
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'device_type': deviceType, // Use the global deviceType variable
        'player_id': playerID, // Add the required player_id parameter
      });
      
      final response = await dio.post(
        'login.php',
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      
      print('Raw response data: ${response.data}');
      print('Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        dynamic data = response.data;
        
        // Handle case where response might be a string that needs to be parsed
        if (data is String) {
          print('Response is string, parsing JSON...');
          data = jsonDecode(data);
        }
        
        print('Parsed data: $data');
        print('Data type: ${data.runtimeType}');
        
        if (data['success'] == 'true' || data['status'] == 'success') {
          return AuthResponseModel.fromJson(data);
        } else {
          // Check if account is not activated
          if (data['flag'] == 'not_activated' || 
              (data['msg']?.toString().contains('activate') ?? false)) {
            throw AccountNotActivatedException(data['msg'] ?? 'Please activate your account');
          }
          throw ServerException(data['msg'] ?? data['message'] ?? 'Login failed');
        }
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      print('DioException: $e');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException('No internet connection');
      } else {
        throw ServerException(e.message ?? 'Network error');
      }
    } catch (e) {
      print('General exception in login: $e');
      print('Exception type: ${e.runtimeType}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> register(Map<String, dynamic> userData) async {
    try {
      final response = await dio.post(
        'register.php',
        data: userData,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return AuthResponseModel.fromJson(data);
        } else {
          throw ServerException(data['message'] ?? 'Registration failed');
        }
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException('No internet connection');
      } else {
        throw ServerException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> verifyOtp(String otp, String email) async {
    try {
      final response = await dio.get(
        'activate_account.php',
        queryParameters: {
          'guid': otp,
          'email': email,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'success';
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> resendOtp(String email) async {
    try {
      final response = await dio.get(
        'resend_code.php',
        queryParameters: {'email': email},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'success';
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await dio.get(
        'forgot_password.php',
        queryParameters: {'email': email},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'success';
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> getUserProfile(String userId, String userType) async {
    try {
      final response = await dio.get(
        'get_profile.php',
        queryParameters: {
          'user_id': userId,
          'user_type': userType,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == 'true') {
          return UserProfileModel.fromJson(data);
        } else {
          throw ServerException(data['msg'] ?? 'Failed to load profile');
        }
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HomeDataModel> getHomeData(String? userId, Map<String, dynamic>? location) async {
    try {
      String url = 'getall_chef_or_grocer_with_detail.php';
      Map<String, dynamic> queryParams = {};
      
      if (userId != null) {
        queryParams['user_id'] = userId;
      } else if (location != null) {
        queryParams['latitude'] = location['lat'];
        queryParams['longitude'] = location['long'];
      }
      
      final response = await dio.get(
        url, 
        queryParameters: queryParams,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      
      print('Home data raw response: ${response.data}');
      print('Home data response type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        dynamic data = response.data;
        
        // Handle case where response might be a string that needs to be parsed
        if (data is String) {
          print('Home data response is string, parsing JSON...');
          data = jsonDecode(data);
        }
        
        print('Home data parsed: $data');
        print('Home data type: ${data.runtimeType}');
        
        return HomeDataModel.fromJson(data);
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      print('DioException in getHomeData: $e');
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      print('General exception in getHomeData: $e');
      print('Exception type: ${e.runtimeType}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SearchResponseModel> searchUsers(String query, String? userId) async {
    try {
      Map<String, dynamic> queryParams = {'query': query};
      if (userId != null) {
        queryParams['user_id'] = userId;
      }
      
      final response = await dio.get(
        'search_users.php',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return SearchResponseModel.fromJson(data);
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final response = await dio.get(
        'get_notifications.php',
        queryParameters: {'user_id': userId},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        }
        return [];
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> markNotificationAsRead(String notificationId, String userId) async {
    try {
      final response = await dio.post(
        'mark_notification_read.php',
        queryParameters: {
          'notification_id': notificationId,
          'user_id': userId,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'success';
      } else {
        throw ServerException('Network error occurred');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
