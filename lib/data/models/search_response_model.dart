import 'package:json_annotation/json_annotation.dart';

part 'search_response_model.g.dart';

@JsonSerializable()
class SearchResponseModel {
  final List<dynamic>? data;
  final String? message;

  SearchResponseModel({
    this.data,
    this.message,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}
