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
  List<dynamic> followingsDetails;

  ChefFollowingsListModel({
    required this.success,
    required this.msg,
    required this.followersCount,
    required this.followersDetails,
    required this.followingCounts,
    required this.followingsDetails,
  });

  factory ChefFollowingsListModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawFollowers = json["followers_details"];
    final List<ChefFollowersDetail> followerList = <ChefFollowersDetail>[];
    if (rawFollowers is List) {
      for (final item in rawFollowers) {
        if (item is Map<String, dynamic>) {
          followerList.add(ChefFollowersDetail.fromJson(item));
        } else if (item is Map) {
          followerList.add(ChefFollowersDetail.fromJson(
              Map<String, dynamic>.from(item as Map)));
        }
      }
    }

    final dynamic rawFollowings = json["followings_details"];
    final List<dynamic> followings = <dynamic>[];
    if (rawFollowings is List) {
      followings.addAll(rawFollowings);
    }

    return ChefFollowingsListModel(
      success: json["success"]?.toString() ?? 'false',
      msg: json["msg"]?.toString() ?? '',
      followersCount:
          int.tryParse(json["followers_count"]?.toString() ?? '0') ?? 0,
      followersDetails: followerList,
      followingCounts:
          int.tryParse(json["following_counts"]?.toString() ?? '0') ?? 0,
      followingsDetails: followings,
    );
  }

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
        followingId:
            int.tryParse(json["following_id"]?.toString() ?? '0') ?? 0,
        firstName: json["first_name"]?.toString() ?? '',
        lastName: json["last_name"]?.toString() ?? '',
        image: json["image"]?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        fromUser: int.tryParse(json["from_user"]?.toString() ?? '0') ?? 0,
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
