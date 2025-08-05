import 'dart:convert';

NotoficationListModel notoficationListModelFromJson(String str) =>
    NotoficationListModel.fromJson(json.decode(str));

String notoficationListModelToJson(NotoficationListModel data) =>
    json.encode(data.toJson());

class NotoficationListModel {
  String success;
  String msg;
  List<NotificationDetail> notificationDetails;

  NotoficationListModel({
    required this.success,
    required this.msg,
    required this.notificationDetails,
  });

  factory NotoficationListModel.fromJson(Map<String, dynamic> json) =>
      NotoficationListModel(
        success: json["success"],
        msg: json["msg"],
        notificationDetails: List<NotificationDetail>.from(
            json["notification_details"]
                .map((x) => NotificationDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "notification_details":
            List<dynamic>.from(notificationDetails.map((x) => x.toJson())),
      };
}

class NotificationDetail {
  int notificationId;
  int userId;
  String firstName;
  String lastName;
  String image;
  String message;
  String title;
  String inserttime;
  String action;
  String messageJson;
  String readStatus;

  NotificationDetail({
    required this.notificationId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.message,
    required this.title,
    required this.inserttime,
    required this.action,
    required this.messageJson,
    required this.readStatus,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) =>
      NotificationDetail(
        notificationId: json["notification_id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        message: json["message"],
        title: json["title"],
        inserttime: json["inserttime"],
        action: json["action"],
        messageJson: json["message_json"],
        readStatus: json["read_status"],
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "message": message,
        "title": title,
        "inserttime": inserttime,
        "action": action,
        "message_json": messageJson,
        "read_status": readStatus,
      };
}
