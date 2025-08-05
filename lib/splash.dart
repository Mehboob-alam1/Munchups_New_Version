import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:munchups_app/Screens/search_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // late AnimationController controller;
  // late Animation<double> animation;
  // LocalStorage storage = LocalStorage('user');

  Location location = Location();

  dynamic user;
  dynamic checkTenant;

  @override
  void initState() {
    super.initState();

    // controller =
    //     AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // controller.forward();
    getLocation();
    Timer(const Duration(seconds: 3), () {
      // controller.reset();
      navigateToNextScreen();
    });
  }

  navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = jsonDecode(prefs.getString('data').toString());
    if (prefs.getString('country_symbol') != null) {
      setState(() {
        currencySymbol = prefs.getString('country_symbol').toString();
      });
    }

    // log(user.toString());
    // dynamic screen = LoginPage();
    dynamic screen = const SearchLocationPage();
    //OnboardingScreen();
    // GoogleMapPage(type: 'direct');

    if (user != null && user.isNotEmpty) {
      if (user['user_type'] == 'buyer') {
        screen = const BuyerHomePage();
      } else if (user['user_type'] == 'chef') {
        screen = const ChefHomePage();
      } else if (user['user_type'] == 'grocer') {
        screen = const GrocerHomePage();
      }
    }

    PageNavigateScreen().normalpushReplesh(context, screen);
  }

  saveUserLatLong(latlong) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('guestLatLong', jsonEncode(latlong));
    });
  }

  Future<void> getLocation() async {
    try {
      PermissionStatus _permissionGranted;

      var _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      await location.getLocation().then((value) {
        var s = {
          'lat': value.latitude.toString(),
          'long': value.longitude.toString(),
        };
        saveUserLatLong(s);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: DynamicColor.white,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/onboarding8.jpeg',
            // fit: BoxFit.fitHeight,
            //   height: 300,
          )),
      // logo(),
    );
  }

  // Widget logo() {
  //   return ScaleTransition(
  //     scale: Tween<double>(
  //       begin: 0.0,
  //       end: 1.0,
  //     ).animate(
  //       CurvedAnimation(
  //         parent: animation,
  //         curve: Curves.easeIn,
  //       ),
  //     ),
  //     child: SizedBox(
  //       child: Hero(
  //         tag: 'hero',
  //         child: Align(
  //           child: Image.asset(
  //             'assets/images/logo.png',
  //             height: 300,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
}
