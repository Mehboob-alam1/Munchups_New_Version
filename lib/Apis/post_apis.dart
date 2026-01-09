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
    try {
      String url = Utils.baseUrl() + 'post_dish_or_item.php';
      
      print('=== POST DISH API CALL ===');
      print('URL: $url');
      print('Body: $body');
      print('Body keys: ${body.keys.toList()}');
      print('user_id in body: ${body['user_id']}');
      print('type in body: ${body['type']}');

      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Add each field individually to ensure they're all included
      body.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          request.fields[key] = value.toString();
          print('Added field: $key = $value');
        } else {
          print('Skipping empty field: $key');
        }
      });
      
      if (image1.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'images[]', image1.path,
            filename: image1.path.split('/').last));
        print('Image 1 added: ${image1.path}');
      }
      if (image2.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'images[]', image2.path,
            filename: image2.path.split('/').last));
        print('Image 2 added: ${image2.path}');
      }
      if (image3.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'images[]', image3.path,
            filename: image3.path.split('/').last));
        print('Image 3 added: ${image3.path}');
      }

      var res = await request.send();
      var response = await res.stream.bytesToString();
      
      print('Response status: ${res.statusCode}');
      print('Response body: $response');
      
      dynamic data = jsonDecode(response);
      return data;
    } catch (e) {
      print('Error in postDishApi: $e');
      return {
        'success': 'false',
        'msg': 'Failed to post dish: ${e.toString()}',
        'error': e.toString()
      };
    }
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

  Future updateStripeStatusApi(body) async {
    try {
      String url = Utils.baseUrl() + 'update_stripe_status.php';
      
      print('=== UPDATE STRIPE STATUS API CALL ===');
      print('Endpoint: update_stripe_status.php');
      print('Full URL: $url');
      print('Body: $body');
      print('Method: POST');
      print('====================================');
      
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(body);
      
      print('Sending request...');
      var res = await request.send();
      
      print('Response status code: ${res.statusCode}');
      
      var response = await res.stream.bytesToString();
      print('Response body: $response');
      
      dynamic data = jsonDecode(response);
      return data;
    } catch (e) {
      print('Error in updateStripeStatusApi: $e');
      return {
        'success': 'false',
        'msg': 'Failed to update Stripe status: ${e.toString()}',
        'error': e.toString()
      };
    }
  }

  Future connectStripeAccountApi(body) async {
    try {
      // Primary endpoint - now that it's deployed
      String url = Utils.baseUrl() + 'connect_stripe_account.php';
      
      print('=== STRIPE CONNECT API CALL ===');
      print('Endpoint: connect_stripe_account.php');
      print('Full URL: $url');
      print('Body: $body');
      print('Method: POST');
      print('===============================');
      
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(body);
      
      print('Sending request...');
      var res = await request.send();
      
      print('Response status code: ${res.statusCode}');
      print('Response headers: ${res.headers}');
      
      // Check HTTP status code
      if (res.statusCode == 404) {
        print('ERROR: 404 - Endpoint not found');
        return {
          'success': 'false',
          'msg': 'Server endpoint not found. Please verify that connect_stripe_account.php is uploaded to the server.',
          'error': '404 Not Found',
          'url': url
        };
      } else if (res.statusCode >= 500) {
        print('ERROR: ${res.statusCode} - Server error');
        var errorResponse = await res.stream.bytesToString();
        print('Error response: $errorResponse');
        
        // Prova a parsare la risposta JSON per ottenere il messaggio reale
        try {
          var errorData = jsonDecode(errorResponse);
          String errorMsg = errorData['msg']?.toString() ?? 
                          errorData['message']?.toString() ?? 
                          'Server error. Please check server logs or contact support.';
          
          print('Error data from server: $errorData');
          
          // Se il messaggio contiene informazioni su Stripe SDK, mostralo
          if (errorMsg.contains('Stripe PHP SDK') || 
              errorMsg.contains('stripe_sdk_missing') ||
              errorData['error']?.toString() == 'stripe_sdk_missing') {
            // Include debug info se disponibile
            String fullMsg = errorMsg;
            if (errorData['debug'] != null) {
              fullMsg += '\n\nDebug info: ${errorData['debug']}';
            }
            return {
              'success': 'false',
              'msg': fullMsg,
              'error': 'HTTP ${res.statusCode}',
              'url': url,
              'stripe_sdk_missing': true,
              'debug': errorData['debug']
            };
          }
          
          return {
            'success': 'false',
            'msg': errorMsg,
            'error': 'HTTP ${res.statusCode}',
            'url': url,
            'server_response': errorData
          };
        } catch (e) {
          // Se non è JSON, usa il messaggio generico
          String rawResponse = errorResponse.length > 200 
              ? errorResponse.substring(0, 200) 
              : errorResponse;
          return {
            'success': 'false',
            'msg': 'Server error. Please check server logs or contact support.',
            'error': 'HTTP ${res.statusCode}',
            'url': url,
            'raw_response': rawResponse
          };
        }
      } else if (res.statusCode != 200) {
        print('ERROR: ${res.statusCode} - Unexpected status code');
        var errorResponse = await res.stream.bytesToString();
        print('Error response: $errorResponse');
        return {
          'success': 'false',
          'msg': 'Server returned unexpected status code (${res.statusCode}). Please contact support.',
          'error': 'HTTP ${res.statusCode}',
          'url': url
        };
      }
      
      var response = await res.stream.bytesToString();
      print('Response body: ${response.length > 1000 ? response.substring(0, 1000) + "..." : response}');
      
      // Check if response is empty
      if (response.trim().isEmpty) {
        print('ERROR: Empty response');
        return {
          'success': 'false',
          'msg': 'Empty response from server. Please check server configuration.',
          'error': 'Empty response',
          'url': url
        };
      }
      
      // Check if response is HTML (error page)
      if (response.trim().startsWith('<!DOCTYPE') || 
          response.trim().startsWith('<html') ||
          response.trim().startsWith('<?xml')) {
        print('ERROR: HTML response received (server error page)');
        String preview = response.length > 300 
            ? response.substring(0, 300) 
            : response;
        print('Response preview: $preview');
        return {
          'success': 'false',
          'msg': 'Server returned HTML instead of JSON. Please check if Stripe PHP SDK is installed correctly.',
          'error': 'HTML response received instead of JSON',
          'url': url
        };
      }
      
      // Try to parse JSON
      try {
        dynamic data = jsonDecode(response);
        print('✅ Successfully parsed JSON response');
        print('Response data: $data');
        
        // Return the response (success or error)
        return data;
      } catch (e) {
        // If JSON parsing fails
        print('ERROR: JSON parsing failed: $e');
        String preview = response.length > 500 
            ? response.substring(0, 500) 
            : response;
        print('Response that failed to parse: $preview');
        String rawResponse = response.length > 200 
            ? response.substring(0, 200) 
            : response;
        return {
          'success': 'false',
          'msg': 'Invalid JSON response from server. Please check server configuration.',
          'error': 'JSON parsing failed: ${e.toString()}',
          'url': url,
          'raw_response': rawResponse
        };
      }
    } catch (e) {
      // Handle network errors
      print('EXCEPTION: $e');
      String errorMsg = 'Network error occurred';
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup')) {
        errorMsg = 'No internet connection. Please check your network.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMsg = 'Connection timeout. Please try again.';
      } else {
        errorMsg = 'Network error: ${e.toString()}';
      }
      
      return {
        'success': 'false',
        'msg': errorMsg,
        'error': e.toString()
      };
    }
  }
}
