// To parse this JSON data, do
//
//     final proposalListModel = proposalListModelFromJson(jsonString);

import 'dart:convert';

ProposalListModel proposalListModelFromJson(String str) =>
    ProposalListModel.fromJson(json.decode(str));

String proposalListModelToJson(ProposalListModel data) =>
    json.encode(data.toJson());

class ProposalListModel {
  String success;
  String msg;
  List<ProposalOcCategoryOrderArr> ocCategoryOrderArr;

  ProposalListModel({
    required this.success,
    required this.msg,
    required this.ocCategoryOrderArr,
  });

  factory ProposalListModel.fromJson(Map<String, dynamic> json) =>
      ProposalListModel(
        success: json["success"],
        msg: json["msg"],
        ocCategoryOrderArr: List<ProposalOcCategoryOrderArr>.from(
            json["oc_category_order_arr"]
                .map((x) => ProposalOcCategoryOrderArr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "oc_category_order_arr":
            List<dynamic>.from(ocCategoryOrderArr.map((x) => x.toJson())),
      };
}

class ProposalOcCategoryOrderArr {
  int foodId;
  int occasionCategoryId;
  int chefId;
  dynamic proposalId;
  String proposalStatus;
  String buyerStatus;
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
  String emailId;
  String phone;

  ProposalOcCategoryOrderArr({
    required this.foodId,
    required this.occasionCategoryId,
    required this.chefId,
    required this.proposalId,
    required this.proposalStatus,
    required this.buyerStatus,
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
    required this.emailId,
    required this.phone,
  });

  factory ProposalOcCategoryOrderArr.fromJson(Map<String, dynamic> json) =>
      ProposalOcCategoryOrderArr(
        foodId: json["food_id"],
        occasionCategoryId: json["occasion_category_id"],
        chefId: json["chef_id"],
        proposalId: json["proposal_id"],
        proposalStatus: json["proposal_status"],
        buyerStatus: json["buyer_status"],
        occasionCategoryName: json["occasion_category_name"],
        foodCateName: json["food_cate_name"],
        noOfPeople: json["no_of_people"],
        serviceType: json["service_type"],
        budget: json["budget"],
        endDate: json["end_date"],
        startDate: json["start_date"],
        occasionTime: json["occasion_time"],
        location: json["location"],
        postalCode: json["postal_code"],
        description: json["description"],
        personalOccasionName: json["personal_occasion_name"],
        firstName: json["first_name"],
        image: json["image"],
        lastName: json["last_name"],
        emailId: json["email_id"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "occasion_category_id": occasionCategoryId,
        "chef_id": chefId,
        "proposal_id": proposalId,
        "proposal_status": proposalStatus,
        "buyer_status": buyerStatus,
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
        "email_id": emailId,
        "phone": phone,
      };
}
