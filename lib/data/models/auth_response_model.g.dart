// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      userType: json['userType'] as String?,
      token: json['token'] as String?,
      myFollowers: (json['myFollowers'] as num?)?.toInt(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'userType': instance.userType,
      'token': instance.token,
      'myFollowers': instance.myFollowers,
      'currency': instance.currency,
    };
