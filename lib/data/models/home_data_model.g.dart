// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDataModel _$HomeDataModelFromJson(Map<String, dynamic> json) =>
    HomeDataModel(
      data: json['data'] as List<dynamic>?,
      chefs: json['chefs'] as List<dynamic>?,
      grocers: json['grocers'] as List<dynamic>?,
    );

Map<String, dynamic> _$HomeDataModelToJson(HomeDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'chefs': instance.chefs,
      'grocers': instance.grocers,
    };
