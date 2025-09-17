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
    if (json['myFollowers'] != null) {
      if (json['myFollowers'] is String) {
        myFollowers = int.tryParse(json['myFollowers']);
      } else if (json['myFollowers'] is num) {
        myFollowers = json['myFollowers'].toInt();
      }
    }

    return AuthResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] as Map<String, dynamic>?,
      userType: json['userType']?.toString(),
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
