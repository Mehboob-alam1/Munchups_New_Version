import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

class AuthResponseModel {
  final String status;
  final String message;
  final Map<String, dynamic>? data;
  final String? userType;
  final String? token;
  final int? myFollowers;
  final String? currency;

  AuthResponseModel({
    required this.status,
    required this.message,
    this.data,
    this.userType,
    this.token,
    this.myFollowers,
    this.currency,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle myFollowers conversion safely to prevent "string is not subtype of int" error
    int? myFollowers;
    if (json['my_followers'] != null) {
      if (json['my_followers'] is String) {
        myFollowers = int.tryParse(json['my_followers']);
      } else if (json['my_followers'] is num) {
        myFollowers = json['my_followers'].toInt();
      }
    }

    // Create user data from the response fields
    Map<String, dynamic> userData = {
      'user_id': json['user_id'],
      'first_name': json['first_name'],
      'last_name': json['last_name'],
      'user_name': json['user_name'],
      'email': json['email'],
      'phone': json['phone'],
      'image': json['image'],
      'connect_with_stripe': json['connect_with_stripe'],
      'signup_status': json['signup_status'],
    };

    return AuthResponseModel(
      status: json['success'] == 'true' ? 'success' : 'error',
      message: json['msg']?.toString() ?? '',
      data: userData,
      userType: json['user_type']?.toString(),
      token: json['token']?.toString(),
      myFollowers: myFollowers,
      currency: json['currency']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data,
    'userType': userType,
    'token': token,
    'myFollowers': myFollowers,
    'currency': currency,
  };
}
