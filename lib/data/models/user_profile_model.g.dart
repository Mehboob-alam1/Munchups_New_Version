// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      success: json['success'] as String,
      msg: json['msg'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'data': instance.data,
    };
