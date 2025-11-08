// To parse this JSON data, do
//
//     final chefHomeListModel = chefHomeListModelFromJson(jsonString);

import 'dart:convert';

ChefHomeListModel chefHomeListModelFromJson(String str) =>
    ChefHomeListModel.fromJson(json.decode(str));

String chefHomeListModelToJson(ChefHomeListModel data) =>
    json.encode(data.toJson());

class ChefHomeListModel {
  String success;
  String msg;
  List<OcCategoryOrderArr> ocCategoryOrderArr;
  int notificationCount;

  ChefHomeListModel({
    required this.success,
    required this.msg,
    required this.ocCategoryOrderArr,
    required this.notificationCount,
  });

  factory ChefHomeListModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawList = json["oc_category_order_arr"];
    final List<OcCategoryOrderArr> list = <OcCategoryOrderArr>[];

    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          list.add(OcCategoryOrderArr.fromJson(item));
        } else if (item is Map) {
          list.add(OcCategoryOrderArr.fromJson(
              Map<String, dynamic>.from(item as Map)));
        }
      }
    }

    return ChefHomeListModel(
      success: json["success"]?.toString() ?? 'false',
      msg: json["msg"]?.toString() ?? '',
      ocCategoryOrderArr: list,
      notificationCount:
          int.tryParse(json["notification_count"]?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "oc_category_order_arr":
            List<dynamic>.from(ocCategoryOrderArr.map((x) => x.toJson())),
        "notification_count": notificationCount,
      };
}

class OcCategoryOrderArr {
  int foodId;
  int occasionCategoryId;
  int buyerId;
  dynamic proposalId;
  String proposalStatus;
  String occasionCategoryName;
  String foodCateName;
  String noOfPeople;
  String serviceType;
  String budget;
  String endDate;
  String startDate;
  String occasionTime;
  String location;
  String postalCode;
  String description;
  String personalOccasionName;
  String firstName;
  String image;
  String lastName;
  String userName;
  String emailId;
  String phone;

  OcCategoryOrderArr({
    required this.foodId,
    required this.occasionCategoryId,
    required this.buyerId,
    required this.proposalId,
    required this.proposalStatus,
    required this.occasionCategoryName,
    required this.foodCateName,
    required this.noOfPeople,
    required this.serviceType,
    required this.budget,
    required this.endDate,
    required this.startDate,
    required this.occasionTime,
    required this.location,
    required this.postalCode,
    required this.description,
    required this.personalOccasionName,
    required this.firstName,
    required this.image,
    required this.lastName,
    required this.userName,
    required this.emailId,
    required this.phone,
  });

  factory OcCategoryOrderArr.fromJson(Map<String, dynamic> json) =>
      OcCategoryOrderArr(
        foodId: int.tryParse(json["food_id"]?.toString() ?? '0') ?? 0,
        occasionCategoryId:
            int.tryParse(json["occasion_category_id"]?.toString() ?? '0') ?? 0,
        buyerId: int.tryParse(json["buyer_id"]?.toString() ?? '0') ?? 0,
        proposalId: json["proposal_id"],
        proposalStatus: json["proposal_status"]?.toString() ?? '',
        occasionCategoryName: json["occasion_category_name"]?.toString() ?? '',
        foodCateName: json["food_cate_name"]?.toString() ?? '',
        noOfPeople: json["no_of_people"]?.toString() ?? '',
        serviceType: json["service_type"]?.toString() ?? '',
        budget: json["budget"]?.toString() ?? '',
        endDate: json["end_date"]?.toString() ?? '',
        startDate: json["start_date"]?.toString() ?? '',
        occasionTime: json["occasion_time"]?.toString() ?? '',
        location: json["location"]?.toString() ?? '',
        postalCode: json["postal_code"]?.toString() ?? '',
        description: json["description"]?.toString() ?? '',
        personalOccasionName:
            json["personal_occasion_name"]?.toString() ?? '',
        firstName: json["first_name"]?.toString() ?? '',
        image: json["image"]?.toString() ?? '',
        lastName: json["last_name"]?.toString() ?? '',
        userName: json["user_name"]?.toString() ?? '',
        emailId: json["email_id"]?.toString() ?? '',
        phone: json["phone"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "occasion_category_id": occasionCategoryId,
        "buyer_id": buyerId,
        "proposal_id": proposalId,
        "proposal_status": proposalStatus,
        "occasion_category_name": occasionCategoryName,
        "food_cate_name": foodCateName,
        "no_of_people": noOfPeople,
        "service_type": serviceType,
        "budget": budget,
        "end_date": endDate,
        "start_date": startDate,
        "occasion_time": occasionTime,
        "location": location,
        "postal_code": postalCode,
        "description": description,
        "personal_occasion_name": personalOccasionName,
        "first_name": firstName,
        "image": image,
        "last_name": lastName,
        "user_name": userName,
        "email_id": emailId,
        "phone": phone,
      };
}
