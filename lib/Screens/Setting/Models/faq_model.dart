// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  String success;
  String msg;
  String faq;

  FaqModel({
    required this.success,
    required this.msg,
    required this.faq,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        success: json["success"],
        msg: json["msg"],
        faq: json["faq"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "faq": faq,
      };
}
