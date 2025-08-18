// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponseModel _$SearchResponseModelFromJson(Map<String, dynamic> json) =>
    SearchResponseModel(
      data: json['data'] as List<dynamic>?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SearchResponseModelToJson(
        SearchResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
    };
