import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/demanded_food_list_model.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/food_category_model.dart';
import 'package:munchups_app/Screens/Buyer/Demand%20Food/Model/proposal_list_model.dart';
import 'package:munchups_app/Screens/Buyer/Following%20List/following_model.dart';
import 'package:munchups_app/Screens/Buyer/Search%20All%20User/search_model.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Followers/chef_follower_model.dart';
import 'package:munchups_app/Screens/Chef/Home/home_model.dart';
import 'package:munchups_app/Screens/Notification/notify_model.dart';
import 'package:munchups_app/Screens/Setting/Models/faq_model.dart';
import 'package:munchups_app/Screens/Setting/Models/termsAndCond.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetApiServer {
  Future verifyOtpApi(String otp, String emailID) async {
    String url =
        Utils.baseUrl() + 'activate_account.php?guid=$otp&email=$emailID';

    print('=== OTP VERIFICATION API CALL ===');
    print('URL: $url');
    print('OTP: $otp');
    print('Email: $emailID');
    print('===============================');

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    dynamic data = jsonDecode(response.body);
    print('Parsed data: $data');
    return data;
  }

  Future resendOtpApi(String emailID) async {
    String url = Utils.baseUrl() + 'resend_code.php?email=$emailID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);

    return data;
  }

  Future forgetPasswordApi(email) async {
    String url = Utils.baseUrl() + 'forgot_password.php?email=$email';

    final request = http.MultipartRequest('GET', Uri.parse(url));
    var res = await request.send();
    var response = await res.stream.bytesToString();
    dynamic data = jsonDecode(response);

    return data;
  }

  Future buyerHomeDemoApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    var latlong = jsonDecode(prefs.getString('guestLatLong').toString());

    String url = '';
    if (userData != null) {
      url = Utils.baseUrl() +
          'getall_chef_or_grocer_with_detail.php/?user_id=' +
          userData['user_id'].toString();
    } else {
      url = Utils.baseUrl() +
          'getall_chef_or_grocer_with_detail.php/?latitude=${latlong['lat'].toString()}&longitude=${latlong['long'].toString()}';
    }
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);

    return data;
  }

  Future getProfileApi(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String getUserType = prefs.getString('user_type').toString();
    String url = Utils.baseUrl() +
        'get_profile.php?user_id=${userData['user_id'].toString()}&user_type=$getUserType';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    var data = jsonDecode(response.body);

    return data;
  }

  Future getOtherUserProfileApi(userId, userType) async {
    String url = Utils.baseUrl() +
        'get_profile.php?user_id=${userId.toString()}&user_type=$userType';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    var data = jsonDecode(response.body);

    return data;
  }

  Future<FaqModel> faqApi() async {
    String url = Utils.baseUrl() + 'faq.php';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    FaqModel data = FaqModel.fromJson(jsonDecode(response.body));

    return data;
  }

  Future<TermsAndConditionsModel> trmsAndCondiApi() async {
    String url = Utils.baseUrl() + 'get_content.php';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    TermsAndConditionsModel data =
        TermsAndConditionsModel.fromJson(jsonDecode(response.body));

    return data;
  }

  Future<MyFollowingsListModel> myFollowersListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'get_my_follower.php/?user_id=' +
        userData['user_id'].toString();

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    MyFollowingsListModel data =
        MyFollowingsListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future<NotoficationListModel> notificationListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'get_all_notification.php/?user_id=' +
        userData['user_id'].toString();

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    NotoficationListModel data =
        NotoficationListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future<PostedDemandFoodListModel> postedDemandFoodListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'getall_occasion_food.php/?user_id=' +
        userData['user_id'].toString();

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    PostedDemandFoodListModel data =
        PostedDemandFoodListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future<AllChefGrocerListModel> allChefAndGrocerListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String getUserType = prefs.getString('user_type').toString();
    String url = Utils.baseUrl() +
        'getall_chef_groucer.php/?user_id=' +
        userData['user_id'].toString() +
        '&user_type=$getUserType';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    AllChefGrocerListModel data =
        AllChefGrocerListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future getOnlineAddressApi(postCode) async {
    String url =
        'https://api.getAddress.io/autocomplete/$postCode?api-key=$apiKey';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future getGoogleAddressApi(postCode) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$postCode&key=$googleApiKey';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

// dropdown Apis
  Future occasionApi() async {
    String url = Utils.baseUrl() + 'getall_occasion.php';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future myOrderListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'get_all_orderBYUSER_ID.php?user_id=${userData['user_id'].toString()}';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future getAllUserLatLongApi(lat, long, postlCode) async {
    String url = '';
    if (postlCode == null) {
      url =
          Utils.baseUrl() + 'get_user_lat_long_details.php?lat=$lat&long=$long';
    } else {
      url = Utils.baseUrl() +
          'get_user_lat_long_details.php?lat=$lat&long=$long&postal_code=$postlCode';
    }

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future dishDetailApi(dishID, grocerID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = '';
    if (userData != null) {
      url = Utils.baseUrl() +
          'getall_chef_or_grocer_with_detail_details.php?dish_id=$dishID&user_id=${userData['user_id'].toString()}';
    } else {
      url = Utils.baseUrl() +
          'getall_chef_or_grocer_with_detail_details.php?dish_id=$dishID&user_id=$grocerID';
    }

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future checkAddToCartApi(dishID) async {
    String url = Utils.baseUrl() + 'check_add_tocart.php?dish_id=$dishID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future<ProposalListModel> getProposalOrderApi(buyerID, foodID) async {
    String url = Utils.baseUrl() +
        'get_all_proposal_BYCHEF.php?buyer_id=$buyerID&food_id=$foodID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    ProposalListModel data =
        ProposalListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future rejectProposalStatusApi(proposalID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'change_proposal_status_buyer.php?user_id=${userData['user_id'].toString()}&proposal_id=$proposalID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future onDemandFoodDetailApi(String foodID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'getall_food_detail.php?user_id=${userData['user_id'].toString()}&food_id=$foodID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }
  // Chef Apis

  Future<ProfessionFoodCategoryModel> getChefCategoryAndProfationApi() async {
    String url = Utils.baseUrl() + 'get_profession_category.php';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    ProfessionFoodCategoryModel data =
        ProfessionFoodCategoryModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future<ChefHomeListModel> getChefHomeListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());

    String url = Utils.baseUrl() +
        'get_all_ocassion_orderBYBUYER.php?chef_id=${userData['user_id'].toString()}';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    ChefHomeListModel data =
        ChefHomeListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future myChefOrderListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'get_all_orderBYCHEF_or_GROCER_ID.php?chef_grocer_id=${userData['user_id'].toString()}';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future orderOtpVerifyApi(String uniqueNumber, String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'ocassion_complete_otp.php?user_id=${userData['user_id'].toString()}&unique_number=$uniqueNumber&otp=$otp';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future completeOrderOtpVerifyApi(
      String uniqueNumber, String otp, buyerID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'mark_complete.php?chef_grocer_id=${userData['user_id'].toString()}&order_unique_number=$uniqueNumber&payment_otp=$otp&user_id=$buyerID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future downloadInvoiceApi(String orederUniqueNumber) async {
    String url = Utils.baseUrl() +
        'pdf_send.php?order_unique_number=$orederUniqueNumber';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future<ChefFollowingsListModel> chefFollowersListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String getUserType = prefs.getString('user_type').toString();
    String url = Utils.baseUrl() +
        'all_following_or_follower.php/?user_id=${userData['user_id'].toString()}&user_type=$getUserType';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    ChefFollowingsListModel data =
        ChefFollowingsListModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future changeProposalStatusApi(foodID, proposalID, buyerID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'change_proposal_status.php?user_id=${userData['user_id'].toString()}&food_id=$foodID&proposal_id=$proposalID&buyer_id=$buyerID';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }

  Future countNotificationApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = jsonDecode(prefs.getString('data').toString());
    String url = Utils.baseUrl() +
        'notification_count.php?user_id=${userData['user_id'].toString()}';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    dynamic data = jsonDecode(response.body);
    return data;
  }
}
