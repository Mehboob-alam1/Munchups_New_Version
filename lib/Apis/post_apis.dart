import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostApiServer {
  Future loginApi(body) async {
    String url = Utils.baseUrl() + 'login.php';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future registrationApi(body, File image) async {
    String url = Utils.baseUrl() + 'signup.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    if (image.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('photo', image.path,
          filename: image.path.split('/').last));
    }

    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future updateProfileApi(body, File image) async {
    String url = Utils.baseUrl() + 'update_profile.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    if (image.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('photo', image.path,
          filename: image.path.split('/').last));
    }

    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future resetPasswordApi(body) async {
    String url = Utils.baseUrl() + 'reset_password.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future changePasswordApi(body) async {
    String url = Utils.baseUrl() + 'change_password.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future contactUsApi(body) async {
    String url = Utils.baseUrl() + 'contact_us.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future submitReviewApi(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() + 'submit_summery_review.php';

    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer " + token['Token'],
    });

    dynamic data = jsonDecode(response.body);

    return data;
  }

  Future onDemandFoodApi(body) async {
    String url = Utils.baseUrl() + 'post_food_order.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future followUnfollowApi(toUserId, flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    String url = Utils.baseUrl() +
        'follow_unfollow.php/?my_user_id=${userData['user_id']}&to_user_id=${toUserId.toString()}&flag=$flag';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    // request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future reportApi(body) async {
    String url = Utils.baseUrl() + 'report.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future orderPlaceApi(body) async {
    String url = Utils.baseUrl() + 'order_dish_test.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future makePaymentApi(propodalID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    dynamic body = {
      'user_id': userData['user_id'].toString(),
      'proposal_id': propodalID.toString(),
    };
    String url = Utils.baseUrl() + 'order_food_test.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future orderReportApi(body) async {
    String url = Utils.baseUrl() + 'occasion_order_report.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future chefRatingApi(body) async {
    String url = Utils.baseUrl() + 'rating.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }
  // Chef Apis

  Future postDishApi(body, File image1, File image2, File image3) async {
    String url = Utils.baseUrl() + 'post_dish_or_item.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    if (image1.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'images[]', image1.path,
          filename: image1.path.split('/').last));
    }
    if (image2.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'images[]', image2.path,
          filename: image2.path.split('/').last));
    }
    if (image3.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'images[]', image3.path,
          filename: image3.path.split('/').last));
    }

    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future updateDishApi(body, File image1, File image2, File image3) async {
    String url = Utils.baseUrl() + 'Update_post_dish_or_item.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    if (image1.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'images[]', image1.path,
          filename: image1.path.split('/').last));
    }
    if (image2.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'images[]', image2.path,
          filename: image2.path.split('/').last));
    }
    if (image3.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'images[]', image3.path,
          filename: image3.path.split('/').last));
    }

    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future changeOrderStatusApi(orderID, buyerID, amount, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    String url = Utils.baseUrl() +
        'accept_reject_test.php/?chef_grocer_id=${userData['user_id']}&order_id=$orderID&user_id=${buyerID.toString()}&amount=$amount&status=$status';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    // request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future customerTokenTestApi(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    String url = Utils.baseUrl() + 'customer_token_test.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'user_id': userData['user_id'].toString(),
      'token': token,
    });
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  // DELETE api

  Future deleteAccountApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String getUserType = prefs.getString('user_type').toString();

    dynamic body = {
      'user_id': userData['user_id'].toString(),
      'user_type': getUserType,
    };
    String url = Utils.baseUrl() + 'delete_profile.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future deleteDishApi(dishID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    String url = Utils.baseUrl() +
        'delete_dish.php/?chef_grocer_id=${userData['user_id']}&dish_id=$dishID';
    final request = http.MultipartRequest('DELETE', Uri.parse(url));
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future deleteOrderApi(orderUniqueNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String getUserType = prefs.getString('user_type').toString();

    dynamic body = {
      'user_id': userData['user_id'].toString(),
      'user_type': getUserType,
      'order_unique_number': orderUniqueNumber.toString(),
    };
    String url = Utils.baseUrl() + 'delete_order.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future deleteBulkOrderApi(orderUniqueNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String getUserType = prefs.getString('user_type').toString();

    dynamic body = {
      'user_id': userData['user_id'].toString(),
      'user_type': getUserType,
      'order_unique_number': orderUniqueNumber.toString(),
    };
    String url = Utils.baseUrl() + 'occasion_order_delete_BYBUYER.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future deletePostedDemandFoodApi(foodID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    String url = Utils.baseUrl() +
        'delete_occasion_food.php/?user_id=${userData['user_id']}&food_id=$foodID';

    final request = http.MultipartRequest('GET', Uri.parse(url));
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future deleteNotificationApi(notifiID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    dynamic body;
    if (notifiID != null) {
      body = {
        'user_id': userData['user_id'].toString(),
        'notification_id': notifiID.toString(),
      };
    } else {
      body = {
        'user_id': userData['user_id'].toString(),
      };
    }

    String url = Utils.baseUrl() + 'delete_notification.php';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }
}
