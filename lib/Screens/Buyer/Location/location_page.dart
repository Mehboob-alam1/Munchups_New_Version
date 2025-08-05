// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
// import 'package:munchups_app/Comman%20widgets/app_bar/without_back_icon_appbar.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Chef/Chef%20Profile/chef_profile.dart';
// import 'package:munchups_app/Screens/Grocer/Grocer%20Profile/grocer_profile.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GoogleMapPage extends StatefulWidget {
//   String type;
//   dynamic postalCode;
//   GoogleMapPage({super.key, required this.type, required this.postalCode});
//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState();
// }
//
// class _GoogleMapPageState extends State<GoogleMapPage> {
//   late GoogleMapController mapController;
//   Location location = Location();
//   LatLng currentLocation = const LatLng(0.0, 0.0);
//
//   Timer timer = Timer(const Duration(seconds: 0), () {});
//
//   List<Marker> markers = [];
//   BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
//
//   bool isLoading = true;
//
//   dynamic checkLocation;
//
//   double latitude = 51.5072;
//   double longitude = 0.1276;
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocation(context);
//     setCustomMarker();
//     Timer(const Duration(seconds: 5), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   saveUserLatLong(latlong) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setString('guestLatLong', jsonEncode(latlong));
//     });
//   }
//
//   Future<void> _getLocation(context) async {
//     try {
//       bool _serviceEnabled;
//
//       _serviceEnabled = await location.serviceEnabled();
//       if (!_serviceEnabled) {
//         _serviceEnabled = await location.requestService();
//         if (!_serviceEnabled) {
//           showDialog(
//               context: context,
//               barrierDismissible: Platform.isAndroid ? false : true,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Center(
//                       child: Text('Location Error', style: secondry18bold)),
//                   content: const Text('Location services are disabled.',
//                       style: TextStyle(
//                           color: DynamicColor.redColor,
//                           fontWeight: FontWeight.w500)),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           openAppSettings().then((value) {
//                             setState(() {});
//                           });
//                         },
//                         child: const Text('Enable'))
//                   ],
//                 );
//               });
//           return;
//         }
//       }
//
//       if (await Permission.location.isDenied) {
//         await location.requestPermission();
//         if (await Permission.location.isPermanentlyDenied) {
//           showDialog(
//               context: context,
//               barrierDismissible: Platform.isAndroid ? false : true,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Center(
//                       child: Text('Location Error', style: secondry18bold)),
//                   content: const Text('Location permissions are denied!',
//                       style: TextStyle(
//                           color: DynamicColor.redColor,
//                           fontWeight: FontWeight.w500)),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           openAppSettings().then((value) {
//                             setState(() {});
//                           });
//                         },
//                         child: const Text('Enable'))
//                   ],
//                 );
//               });
//
//           return;
//         }
//       }
//       await location.getLocation().then((value) {
//         setState(() {
//           currentLocation = LatLng(value.latitude!, value.longitude!);
//           latitude = value.latitude!;
//           longitude = value.longitude!;
//           var s = {
//             'lat': value.latitude.toString(),
//             'long': value.longitude.toString(),
//           };
//           saveUserLatLong(s);
//         });
//       });
//     } catch (e) {
//       log("Error getting location: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: widget.type == 'direct'
//               ? WithoutBackIconCustomAppBar(title: 'Nearby Services')
//               : BackIconCustomAppBar(title: 'Nearby Services')),
//       body: Stack(
//         children: [
//           isLoading
//               ? const Center(
//                   child: CircularProgressIndicator(
//                       color: DynamicColor.primaryColor))
//               : GoogleMap(
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                   buildingsEnabled: true,
//                   initialCameraPosition: CameraPosition(
//                     target: currentLocation == const LatLng(0.0, 0.0)
//                         ? const LatLng(51.5072, 0.1276)
//                         : currentLocation,
//                     zoom: 12.0,
//                   ),
//                   circles: {
//                     Circle(
//                       circleId: const CircleId('current_location'),
//                       center: currentLocation == const LatLng(0.0, 0.0)
//                           ? const LatLng(51.5072, 0.1276)
//                           : currentLocation,
//                       radius: 500,
//                       fillColor: Colors.blue.withOpacity(0.2),
//                       strokeColor: Colors.blue,
//                       strokeWidth: 1,
//                     ),
//                   },
//                   onMapCreated: onMapCreated,
//                   markers: Set<Marker>.of(markers),
//                 ),
//         ],
//       ),
//     );
//   }
//
//   void onMapCreated(GoogleMapController controller) {
//     setState(() {
//       mapController = controller;
//       getAllUsersListApiCall();
//       Timer(const Duration(seconds: 1), () {
//         _getLocation(context);
//       });
//     });
//   }
//
//   void getAllUsersListApiCall() async {
//     try {
//       await GetApiServer()
//           .getAllUserLatLongApi(
//         latitude.toString(),
//         longitude.toString(),
//         widget.postalCode,
//       )
//           .then((value) {
//         if (value['success'] == 'true') {
//           // Clear existing markers
//           markers.clear();
//
//           // Add markers for each location
//           for (var location in value['data']) {
//             setState(() {
//               markers.add(
//                 Marker(
//                     markerId: MarkerId(location['user_id'].toString()),
//                     position: LatLng(double.parse(location['latitude']),
//                         double.parse(location['longitude'])),
//                     onTap: () {
//                       showCustomInfoWindow(location);
//                     },
//                     icon: customIcon
//                     // infoWindow: InfoWindow(
//                     //   title: location['first_name'] + ' ' + location['last_name'],
//                     //   onTap: () {},
//                     // ),
//                     ),
//               );
//             });
//           }
//         } else {
//           Utils().myToast(context, msg: value['msg']);
//         }
//       });
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   Future<void> setCustomMarker() async {
//     customIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(
//           size: Size(24, 24)), // Set the standard size here
//       'assets/images/logo_pin.png',
//     );
//     setState(() {});
//   }
//
//   void showCustomInfoWindow(data) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 30,
//                     backgroundImage: AssetImage('assets/images/profile.jpg'),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data['first_name'] + ' ' + data['last_name'],
//                           style: primary17w6,
//                         ),
//                         RatingBar.builder(
//                           initialRating:
//                               double.parse(data['avg_rating'].toString()),
//                           minRating: 1,
//                           direction: Axis.horizontal,
//                           allowHalfRating: false,
//                           tapOnlyMode: false,
//                           ignoreGestures: true,
//                           itemCount: 5,
//                           itemSize: 15.0,
//                           itemBuilder: (context, _) => const Icon(
//                             Icons.star,
//                             color: Colors.amber,
//                           ),
//                           onRatingUpdate: (rating) {
//                             setState(() {
//                               //  _rating = rating;
//                             });
//                           },
//                         ),
//                         Text(
//                           'Miles: ${double.parse(data['distance'].toString()).toStringAsFixed(2)}',
//                           style: white14w5,
//                         ),
//                         data['category_name'] != null
//                             ? Text(
//                                 data['category_name'],
//                                 style: white14w5,
//                               )
//                             : Container(),
//                       ],
//                     ),
//                   ),
//                   CircleAvatar(
//                     radius: 27,
//                     backgroundColor: DynamicColor.boxColor,
//                     child: InkWell(
//                         onTap: () {
//                           PageNavigateScreen().back(context);
//                           if (data['user_type'] == 'chef') {
//                             PageNavigateScreen().push(
//                                 context,
//                                 ChefProfilePage(
//                                     userId: data['user_id'],
//                                     userType: data['user_type'],
//                                     currentUser: 'buyer'));
//                           } else if (data['user_type'] == 'grocer') {
//                             PageNavigateScreen().push(
//                                 context,
//                                 GrocerProfilePage(
//                                     userId: data['user_id'],
//                                     userType: data['user_type'],
//                                     currentUser: 'buyer'));
//                           }
//                         },
//                         child: const Icon(Icons.arrow_forward_ios)),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/without_back_icon_appbar.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Screens/Chef/Chef%20Profile/chef_profile.dart';
import 'package:munchups_app/Screens/Grocer/Grocer%20Profile/grocer_profile.dart';

class GoogleMapPage extends StatefulWidget {
  final String type;
  final dynamic postalCode;

  const GoogleMapPage({super.key, required this.type, required this.postalCode});

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController mapController;

  LatLng currentLocation = const LatLng(51.5072, 0.1276); // Mocked London coords
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    setMarkers();
  }

  void setMarkers() {
    final List<dynamic> mockData = [
      {
        'user_id': '1',
        'first_name': 'John',
        'last_name': 'Doe',
        'avg_rating': 4.2,
        'distance': 2.5,
        'category_name': 'Chef',
        'latitude': 51.5075,
        'longitude': 0.1278,
        'user_type': 'chef',
      },
      {
        'user_id': '2',
        'first_name': 'Alice',
        'last_name': 'Smith',
        'avg_rating': 4.8,
        'distance': 3.1,
        'category_name': 'Grocer',
        'latitude': 51.5079,
        'longitude': 0.1282,
        'user_type': 'grocer',
      },
    ];

    for (var data in mockData) {
      markers.add(
        Marker(
          markerId: MarkerId(data['user_id']),
          position: LatLng(data['latitude'], data['longitude']),
          onTap: () => showCustomInfoWindow(data),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: widget.type == 'direct'
            ? WithoutBackIconCustomAppBar(title: 'Nearby Services')
            : BackIconCustomAppBar(title: 'Nearby Services'),
      ),
      body: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        buildingsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 12.0,
        ),
        markers: Set<Marker>.of(markers),
      ),
    );
  }

  void showCustomInfoWindow(dynamic data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data['first_name']} ${data['last_name']}', style: primary17w6),
                    RatingBarIndicator(
                      rating: double.parse(data['avg_rating'].toString()),
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 15.0,
                    ),
                    Text('Miles: ${data['distance'].toStringAsFixed(2)}', style: white14w5),
                    if (data['category_name'] != null)
                      Text(data['category_name'], style: white14w5),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 27,
                backgroundColor: DynamicColor.boxColor,
                child: InkWell(
                  onTap: () {
                    PageNavigateScreen().back(context);
                    if (data['user_type'] == 'chef') {
                      PageNavigateScreen().push(
                        context,
                        ChefProfilePage(
                          userId: data['user_id'],
                          userType: data['user_type'],
                          currentUser: 'buyer',
                        ),
                      );
                    } else if (data['user_type'] == 'grocer') {
                      PageNavigateScreen().push(
                        context,
                        GrocerProfilePage(
                          // userId: data['user_id'],
                          // userType: data['user_type'],
                          currentUser: 'buyer',
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
