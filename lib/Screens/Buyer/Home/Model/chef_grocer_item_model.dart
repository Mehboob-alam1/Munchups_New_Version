import 'dart:convert';

BuyerHomeModel buyerHomeModelFromJson(String str) =>
    BuyerHomeModel.fromJson(json.decode(str));

String buyerHomeModelToJson(BuyerHomeModel data) => json.encode(data.toJson());

class BuyerHomeModel {
  String success;
  String msg;
  List<All> allChef;
  List<All> allGrocery;

  BuyerHomeModel({
    required this.success,
    required this.msg,
    required this.allChef,
    required this.allGrocery,
  });

  factory BuyerHomeModel.fromJson(Map<String, dynamic> json) => BuyerHomeModel(
        success: json["success"],
        msg: json["msg"],
        allChef: List<All>.from(json["all_chef"].map((x) => All.fromJson(x))),
        allGrocery:
            List<All>.from(json["all_grocery"].map((x) => All.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "all_chef": List<dynamic>.from(allChef.map((x) => x.toJson())),
        "all_grocery": List<dynamic>.from(allGrocery.map((x) => x.toJson())),
      };
}

class All {
  double distance;
  String? distanceFloat;
  String userType;
  String onlineOfflineFlag;
  int userId;
  String userName;
  String phone;
  String firstName;
  String lastName;
  String fullName;
  String emailId;
  String chefImage;
  String address;
  String postalCode;
  String country;
  String city;
  String state;
  String shopName;
  String latitude;
  String longitude;
  DateTime inserttime;
  int? professionId;
  String? professionName;
  String? professionImage;
  List<CategoryDetail>? categoryDetail;
  int avgRating;
  Country? allDish;
  dynamic allDishGrocer;

  All({
    required this.distance,
    this.distanceFloat,
    required this.userType,
    required this.onlineOfflineFlag,
    required this.userId,
    required this.userName,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.emailId,
    required this.chefImage,
    required this.address,
    required this.postalCode,
    required this.country,
    required this.city,
    required this.state,
    required this.shopName,
    required this.latitude,
    required this.longitude,
    required this.inserttime,
    this.professionId,
    this.professionName,
    this.professionImage,
    this.categoryDetail,
    required this.avgRating,
    this.allDish,
    this.allDishGrocer,
  });

  factory All.fromJson(Map<String, dynamic> json) => All(
        distance: json["distance"]?.toDouble(),
        distanceFloat: json["distance_float"],
        userType: json["user_type"]!,
        onlineOfflineFlag: json["online_offline_flag"]!,
        userId: json["user_id"],
        userName: json["user_name"],
        phone: json["phone"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        emailId: json["email_id"],
        chefImage: json["chef_image"],
        address: json["address"],
        postalCode: json["postal_code"],
        country: json["country"]!,
        city: json["city"],
        state: json["state"],
        shopName: json["shop_name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        inserttime: DateTime.parse(json["inserttime"]),
        professionId: json["profession_id"],
        professionName: json["profession_name"],
        professionImage: json["profession_image"],
        categoryDetail: json["category_detail"] == null
            ? []
            : List<CategoryDetail>.from(json["category_detail"]!
                .map((x) => CategoryDetail.fromJson(x))),
        avgRating: json["avg_rating"],
        allDish: countryValues.map[json["all_dish"]]!,
        allDishGrocer: json["all_dish_grocer"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "distance_float": distanceFloat,
        "user_type": userType,
        "online_offline_flag": onlineOfflineFlag,
        "user_id": userId,
        "user_name": userName,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "full_name": fullName,
        "email_id": emailId,
        "chef_image": chefImage,
        "address": address,
        "postal_code": postalCode,
        "country": country,
        "city": city,
        "state": state,
        "shop_name": shopName,
        "latitude": latitude,
        "longitude": longitude,
        "inserttime": inserttime.toIso8601String(),
        "profession_id": professionId,
        "profession_name": professionName,
        "profession_image": professionImage,
        "category_detail": categoryDetail == null
            ? []
            : List<dynamic>.from(categoryDetail!.map((x) => x.toJson())),
        "avg_rating": avgRating,
        "all_dish": countryValues.reverse[allDish],
        "all_dish_grocer": allDishGrocer,
      };
}

enum Country { NA, PAKISTAN }

final countryValues =
    EnumValues({"NA": Country.NA, "pakistan": Country.PAKISTAN});

class AllDishGrocerElement {
  int dishId;
  int grocerId;
  String serviceType;
  String dishName;
  String dishPrice;
  String dishDescription;
  dynamic dishImages;

  AllDishGrocerElement({
    required this.dishId,
    required this.grocerId,
    required this.serviceType,
    required this.dishName,
    required this.dishPrice,
    required this.dishDescription,
    required this.dishImages,
  });

  factory AllDishGrocerElement.fromJson(Map<String, dynamic> json) =>
      AllDishGrocerElement(
        dishId: json["dish_id"],
        grocerId: json["grocer_id"],
        serviceType: json["service_type"],
        dishName: json["dish_name"],
        dishPrice: json["dish_price"],
        dishDescription: json["dish_description"],
        dishImages: json["dish_images"],
      );

  Map<String, dynamic> toJson() => {
        "dish_id": dishId,
        "grocer_id": grocerId,
        "service_type": serviceType,
        "dish_name": dishName,
        "dish_price": dishPrice,
        "dish_description": dishDescription,
        "dish_images": dishImages,
      };
}

class DishImage {
  int dishImageId;
  String kitchenImage;

  DishImage({
    required this.dishImageId,
    required this.kitchenImage,
  });

  factory DishImage.fromJson(Map<String, dynamic> json) => DishImage(
        dishImageId: json["dish_image_id"],
        kitchenImage: json["kitchen_image"],
      );

  Map<String, dynamic> toJson() => {
        "dish_image_id": dishImageId,
        "kitchen_image": kitchenImage,
      };
}

class CategoryDetail {
  int userId;
  int categoryId;
  String categoryName;
  String image;

  CategoryDetail({
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.image,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        userId: json["user_id"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "category_id": categoryId,
        "category_name": categoryName,
        "image": image,
      };
}

enum OnlineOfflineFlag { OFFLINE, ONLINE }

final onlineOfflineFlagValues = EnumValues(
    {"offline": OnlineOfflineFlag.OFFLINE, "online": OnlineOfflineFlag.ONLINE});

enum UserType { CHEF, GROCER }

final userTypeValues =
    EnumValues({"chef": UserType.CHEF, "grocer": UserType.GROCER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
