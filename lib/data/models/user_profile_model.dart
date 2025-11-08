import 'dart:convert';

class UserProfileModel {
  final String success;
  final String? msg;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? raw;

  UserProfileModel({
    required this.success,
    this.msg,
    this.data,
    this.raw,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parseData(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is Map) {
        return Map<String, dynamic>.from(value as Map);
      }
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded as Map);
          }
        } catch (_) {}
      }
      return null;
    }

    final profileData = parseData(json['profile_data']);
    final data = parseData(json['data']) ?? profileData ?? {};

    return UserProfileModel(
      success: json['success']?.toString() ?? 'false',
      msg: json['msg']?.toString(),
      data: data,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'data': data,
      };
}
