import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:munchups_app/Component/providers/main_provider.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:munchups_app/Screens/search_location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Component/providers/app_provider.dart';
import 'Component/providers/auth_provider.dart';
import 'Component/providers/cart_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  Location location = Location();
  dynamic user;
  dynamic checkTenant;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize providers
      await context.read<AppProvider>().initializeApp();
      await context.read<AuthProvider>().initializeAuth();
      await context.read<CartProvider>().initializeCart();
      
      // Get location
      await getLocation();
      
      // Navigate after delay
      Timer(const Duration(seconds: 3), () {
        navigateToNextScreen();
      });
    } catch (e) {
      debugPrint('Error initializing app: $e');
      // Still navigate after delay even if there's an error
      Timer(const Duration(seconds: 3), () {
        navigateToNextScreen();
      });
    }
  }

  navigateToNextScreen() async {
    try {
      // Get user data from provider
      final authProvider = context.read<AuthProvider>();
      final appProvider = context.read<AppProvider>();
      
      if (authProvider.isAuthenticated) {
        user = authProvider.userData;
        
        // Update currency symbol if available
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('country_symbol') != null) {
          // Note: You might want to add currency symbol to AppProvider
          // For now, keeping the existing logic
        }
      }

      dynamic screen = const SearchLocationPage();

      if (user != null && user.isNotEmpty) {
        if (user['user_type'] == 'buyer') {
          screen = const BuyerHomePage();
        } else if (user['user_type'] == 'chef') {
          screen = const ChefHomePage();
        } else if (user['user_type'] == 'grocer') {
          screen = const GrocerHomePage();
        }
      }

      if (mounted) {
        PageNavigateScreen().normalpushReplesh(context, screen);
      }
    } catch (e) {
      debugPrint('Error navigating: $e');
      // Fallback to search location page
      if (mounted) {
        PageNavigateScreen().normalpushReplesh(context, const SearchLocationPage());
      }
    }
  }

  saveUserLatLong(latlong) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('guestLatLong', jsonEncode(latlong));
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
      debugPrint("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/images/onboarding8.jpeg',
        ),
      ),
    );
  }
}
