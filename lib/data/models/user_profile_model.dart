import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String success;
  final String? msg;
  final Map<String, dynamic>? data;

  UserProfileModel({
    required this.success,
    this.msg,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
