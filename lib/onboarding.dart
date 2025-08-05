import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Screens/search_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //  height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage('assets/images/tutorial.png'),
        //   fit: BoxFit.fitHeight,
        // )),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            OnboardingPage(
              imageUrl: 'assets/images/onboarding5.jpeg',
            ),
            OnboardingPage(
              imageUrl: 'assets/images/onboarding3.jpeg',
            ),
            OnboardingPage(
              imageUrl: 'assets/images/onboarding6.jpeg',
            ),
            OnboardingPage(
              imageUrl: 'assets/images/onboarding8.jpeg',
              isLastPage: true,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: SizeConfig.getSize30(context: context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.getSize30(context: context)),
                child: Text('Swipe to learn how',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.amber[200],
                        fontWeight: FontWeight.w500)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.getSize30(context: context), top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 9,
                    backgroundColor:
                        count == 1 ? Colors.green : DynamicColor.white,
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 9,
                    backgroundColor:
                        count == 2 ? Colors.green : DynamicColor.white,
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 9,
                    backgroundColor:
                        count == 3 ? Colors.green : DynamicColor.white,
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 9,
                    backgroundColor:
                        count == 4 ? Colors.green : DynamicColor.white,
                  ),
                ],
              ),
            ),
            FloatingActionButton(
              backgroundColor: DynamicColor.primaryColor,
              onPressed: () {
                if (_pageController.page! < 3) {
                  setState(() {
                    count++;
                  });
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                } else {
                  PageNavigateScreen()
                      .pushRemovUntil(context, const SearchLocationPage());
                }
              },
              child: count == 4
                  ? const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        color: DynamicColor.secondryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  final String imageUrl;
  final bool isLastPage;

  OnboardingPage({
    Key? key,
    required this.imageUrl,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool isLoading = true;
  Location location = Location();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 800), () {
      getLocation();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        widget.imageUrl,
        // fit: BoxFit.fitHeight,
        // height: MediaQuery.of(context).size.height,
      ),
    );
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
}
