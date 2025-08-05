// To parse this JSON data, do
//
//     final termsAndConditionsModel = termsAndConditionsModelFromJson(jsonString);

import 'dart:convert';

TermsAndConditionsModel termsAndConditionsModelFromJson(String str) =>
    TermsAndConditionsModel.fromJson(json.decode(str));

String termsAndConditionsModelToJson(TermsAndConditionsModel data) =>
    json.encode(data.toJson());

class TermsAndConditionsModel {
  String success;
  String msg;
  String termsConditions;
  String privacyPolicy;
  String aboutUs;

  TermsAndConditionsModel({
    required this.success,
    required this.msg,
    required this.termsConditions,
    required this.privacyPolicy,
    required this.aboutUs,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionsModel(
        success: json["success"],
        msg: json["msg"],
        termsConditions: json["terms_conditions"],
        privacyPolicy: json["privacy_policy"],
        aboutUs: json["about_us"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "terms_conditions": termsConditions,
        "privacy_policy": privacyPolicy,
        "about_us": aboutUs,
      };
}
