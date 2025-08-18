import 'package:json_annotation/json_annotation.dart';

part 'home_data_model.g.dart';

@JsonSerializable()
class HomeDataModel {
  final List<dynamic>? data;
  final List<dynamic>? chefs;
  final List<dynamic>? grocers;

  HomeDataModel({
    this.data,
    this.chefs,
    this.grocers,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}
