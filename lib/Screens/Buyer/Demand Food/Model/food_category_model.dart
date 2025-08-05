// To parse this JSON data, do
//
//     final professionFoodCategoryModel = professionFoodCategoryModelFromJson(jsonString);

import 'dart:convert';

ProfessionFoodCategoryModel professionFoodCategoryModelFromJson(String str) =>
    ProfessionFoodCategoryModel.fromJson(json.decode(str));

String professionFoodCategoryModelToJson(ProfessionFoodCategoryModel data) =>
    json.encode(data.toJson());

class ProfessionFoodCategoryModel {
  String success;
  String msg;
  List<ChefProfession> profession;
  List<FoodCategory> category;

  ProfessionFoodCategoryModel({
    required this.success,
    required this.msg,
    required this.profession,
    required this.category,
  });

  factory ProfessionFoodCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProfessionFoodCategoryModel(
        success: json["success"],
        msg: json["msg"],
        profession: List<ChefProfession>.from(
            json["profession"].map((x) => ChefProfession.fromJson(x))),
        category: List<FoodCategory>.from(
            json["category"].map((x) => FoodCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "profession": List<dynamic>.from(profession.map((x) => x.toJson())),
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
      };
}

class FoodCategory {
  int categoryId;
  String categoryName;
  String image;

  FoodCategory({
    required this.categoryId,
    required this.categoryName,
    required this.image,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) => FoodCategory(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "image": image,
      };
}

class ChefProfession {
  int professionId;
  String professionName;
  String professionImage;

  ChefProfession({
    required this.professionId,
    required this.professionName,
    required this.professionImage,
  });

  factory ChefProfession.fromJson(Map<String, dynamic> json) => ChefProfession(
        professionId: json["profession_id"],
        professionName: json["profession_name"],
        professionImage: json["profession_image"],
      );

  Map<String, dynamic> toJson() => {
        "profession_id": professionId,
        "profession_name": professionName,
        "profession_image": professionImage,
      };
}
