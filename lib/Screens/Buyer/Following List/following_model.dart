import 'dart:convert';

MyFollowingsListModel myFollowingsListModelFromJson(String str) =>
    MyFollowingsListModel.fromJson(json.decode(str));

String myFollowingsListModelToJson(MyFollowingsListModel data) =>
    json.encode(data.toJson());

class MyFollowingsListModel {
  String success;
  String msg;
  List<MyFollowreDetail> followreDetails;

  MyFollowingsListModel({
    required this.success,
    required this.msg,
    required this.followreDetails,
  });

  factory MyFollowingsListModel.fromJson(Map<String, dynamic> json) =>
      MyFollowingsListModel(
        success: json["success"],
        msg: json["msg"],
        followreDetails: List<MyFollowreDetail>.from(
            json["followre_details"].map((x) => MyFollowreDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "followre_details":
            List<dynamic>.from(followreDetails.map((x) => x.toJson())),
      };
}

class MyFollowreDetail {
  int followingId;
  String firstName;
  String lastName;
  String image;
  String userType;
  int userId;

  MyFollowreDetail({
    required this.followingId,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.userType,
    required this.userId,
  });

  factory MyFollowreDetail.fromJson(Map<String, dynamic> json) =>
      MyFollowreDetail(
        followingId: json["following_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        userType: json["user_type"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "following_id": followingId,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "user_type": userType,
        "user_id": userId,
      };
}
