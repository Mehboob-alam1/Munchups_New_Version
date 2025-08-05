// To parse this JSON data, do
//
//     final chefFollowingsListModel = chefFollowingsListModelFromJson(jsonString);

import 'dart:convert';

ChefFollowingsListModel chefFollowingsListModelFromJson(String str) =>
    ChefFollowingsListModel.fromJson(json.decode(str));

String chefFollowingsListModelToJson(ChefFollowingsListModel data) =>
    json.encode(data.toJson());

class ChefFollowingsListModel {
  String success;
  String msg;
  int followersCount;
  List<ChefFollowersDetail> followersDetails;
  int followingCounts;
  String followingsDetails;

  ChefFollowingsListModel({
    required this.success,
    required this.msg,
    required this.followersCount,
    required this.followersDetails,
    required this.followingCounts,
    required this.followingsDetails,
  });

  factory ChefFollowingsListModel.fromJson(Map<String, dynamic> json) =>
      ChefFollowingsListModel(
        success: json["success"],
        msg: json["msg"],
        followersCount: json["followers_count"],
        followersDetails: List<ChefFollowersDetail>.from(
            json["followers_details"]
                .map((x) => ChefFollowersDetail.fromJson(x))),
        followingCounts: json["following_counts"],
        followingsDetails: json["followings_details"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "followers_count": followersCount,
        "followers_details":
            List<dynamic>.from(followersDetails.map((x) => x.toJson())),
        "following_counts": followingCounts,
        "followings_details": followingsDetails,
      };
}

class ChefFollowersDetail {
  int followingId;
  String firstName;
  String lastName;
  String image;
  String address;
  String phone;
  int fromUser;

  ChefFollowersDetail({
    required this.followingId,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.address,
    required this.phone,
    required this.fromUser,
  });

  factory ChefFollowersDetail.fromJson(Map<String, dynamic> json) =>
      ChefFollowersDetail(
        followingId: json["following_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        address: json['address'],
        phone: json['phone'],
        fromUser: json["from_user"],
      );

  Map<String, dynamic> toJson() => {
        "following_id": followingId,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "address": address,
        "phone": phone,
        "from_user": fromUser,
      };
}
