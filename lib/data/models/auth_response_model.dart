import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
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

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
