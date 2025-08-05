import 'dart:convert';

PostedDemandFoodListModel postedDemandFoodListModelFromJson(String str) =>
    PostedDemandFoodListModel.fromJson(json.decode(str));

String postedDemandFoodListModelToJson(PostedDemandFoodListModel data) =>
    json.encode(data.toJson());

class PostedDemandFoodListModel {
  String success;
  String msg;
  List<PostedOcCategoryOrderArr> ocCategoryOrderArr;

  PostedDemandFoodListModel({
    required this.success,
    required this.msg,
    required this.ocCategoryOrderArr,
  });

  factory PostedDemandFoodListModel.fromJson(Map<String, dynamic> json) =>
      PostedDemandFoodListModel(
        success: json["success"],
        msg: json["msg"],
        ocCategoryOrderArr: List<PostedOcCategoryOrderArr>.from(
            json["oc_category_order_arr"]
                .map((x) => PostedOcCategoryOrderArr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "oc_category_order_arr":
            List<dynamic>.from(ocCategoryOrderArr.map((x) => x.toJson())),
      };
}

class PostedOcCategoryOrderArr {
  int foodId;
  int occasionCategoryId;
  String occasionCategoryName;
  String noOfPeople;
  String serviceType;
  String budget;
  String personalOccasionName;
  dynamic totalProposal;

  PostedOcCategoryOrderArr({
    required this.foodId,
    required this.occasionCategoryId,
    required this.occasionCategoryName,
    required this.noOfPeople,
    required this.serviceType,
    required this.budget,
    required this.personalOccasionName,
    required this.totalProposal,
  });

  factory PostedOcCategoryOrderArr.fromJson(Map<String, dynamic> json) =>
      PostedOcCategoryOrderArr(
        foodId: json["food_id"],
        occasionCategoryId: json["occasion_category_id"],
        occasionCategoryName: json["occasion_category_name"],
        noOfPeople: json["no_of_people"],
        serviceType: json["service_type"],
        budget: json["budget"],
        personalOccasionName: json["personal_occasion_name"],
        totalProposal: json["total_proposal"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "occasion_category_id": occasionCategoryId,
        "occasion_category_name": occasionCategoryName,
        "no_of_people": noOfPeople,
        "service_type": serviceType,
        "budget": budget,
        "personal_occasion_name": personalOccasionName,
        "total_proposal": totalProposal,
      };
}
