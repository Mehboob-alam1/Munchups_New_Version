import 'dart:convert';

AllChefGrocerListModel allChefGrocerListModelFromJson(String str) =>
    AllChefGrocerListModel.fromJson(json.decode(str));

String allChefGrocerListModelToJson(AllChefGrocerListModel data) =>
    json.encode(data.toJson());

class AllChefGrocerListModel {
  String success;
  String msg;
  int? followingCounts;
  List<FollowingsDetail> followingsDetails;

  AllChefGrocerListModel({
    required this.success,
    required this.msg,
    required this.followingCounts,
    required this.followingsDetails,
  });

  factory AllChefGrocerListModel.fromJson(Map<String, dynamic> json) =>
      AllChefGrocerListModel(
        success: json["success"],
        msg: json["msg"],
        followingCounts:
            (json["following_counts"] == null) ? 0 : json["following_counts"],
        followingsDetails: List<FollowingsDetail>.from(
            json["followings_details"]
                .map((x) => FollowingsDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "following_counts": followingCounts,
        "followings_details":
            List<dynamic>.from(followingsDetails.map((x) => x.toJson())),
      };
}

class FollowingsDetail {
  int userId;
  String firstName;
  String lastName;
  String fullName;
  String userName;
  String image;
  String userType;
  String currentStatus;

  FollowingsDetail({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.userName,
    required this.image,
    required this.userType,
    required this.currentStatus,
  });

  factory FollowingsDetail.fromJson(Map<String, dynamic> json) =>
      FollowingsDetail(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        userName: json["user_name"],
        image: json["image"],
        userType: json["user_type"],
        currentStatus: json["current_status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "full_name": fullName,
        "user_name": userName,
        "image": image,
        "user_type": userType,
        "current_status": currentStatus,
      };
}
