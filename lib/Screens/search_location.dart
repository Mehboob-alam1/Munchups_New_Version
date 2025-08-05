// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/discloser_popup.dart';
// import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/images_urls.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Auth/login.dart';
// import 'package:munchups_app/Screens/Buyer/Location/location_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SearchLocationPage extends StatefulWidget {
//   const SearchLocationPage({super.key});
//
//   @override
//   State<SearchLocationPage> createState() => _SearchLocationPageState();
// }
//
// class _SearchLocationPageState extends State<SearchLocationPage> {
//   TextEditingController textEditingController = TextEditingController();
//   Location location = Location();
//
//   dynamic userData;
//   dynamic checkDiscloser;
//
//   @override
//   void initState() {
//     super.initState();
//     getLocation();
//     getUserData();
//   }
//
//   getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userData = jsonDecode(prefs.getString('data').toString());
//       checkDiscloser = prefs.get('discloser');
//     });
//
//     if (checkDiscloser == null) {
//       showDialog(
//           barrierDismissible: Platform.isAndroid ? false : true,
//           context: context,
//           builder: (context) => const DiscloserPopup());
//     }
//   }
//
//   Future<void> getLocation() async {
//     try {
//       await location.getLocation().then((value) {
//         var s = {
//           'lat': value.latitude.toString(),
//           'long': value.longitude.toString(),
//         };
//         saveUserLatLong(s);
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   saveUserLatLong(latlong) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setString('guestLatLong', jsonEncode(latlong));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: alreadyAcunt(),
//       body: SingleChildScrollView(
//         child: BackGroundWidget(
//           backgroundImage: AllImages.loginBG,
//           fit: BoxFit.fill,
//           child: Column(
//             children: [
//               SizedBox(height: SizeConfig.getSize55(context: context)),
//               Center(
//                 child: Image.asset(
//                   appLogoUrl,
//                   fit: BoxFit.fitHeight,
//                   height: 200,
//                 ),
//               ),
//               SizedBox(height: SizeConfig.getSize55(context: context)),
//               searchFiled(),
//               SizedBox(height: SizeConfig.getSize35(context: context)),
//               buttons(),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//               InkWell(
//                 onTap: () {
//                   PageNavigateScreen().push(
//                       context,
//                       GoogleMapPage(
//                         type: 'indirect',
//                         postalCode: null,
//                       ));
//                 },
//                 child: Container(
//                     height: 30,
//                     padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(color: DynamicColor.white)),
//                     child: Text('Find Nearby', style: white17Bold)),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget searchFiled() {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.getSize30(context: context),
//           right: SizeConfig.getSize30(context: context)),
//       child: InputFieldsWithLightWhiteColor(
//           labelText: 'Location (Postal Code)',
//           controller: textEditingController,
//           textInputAction: TextInputAction.done,
//           keyboardType: TextInputType.text,
//           textCapitalization: TextCapitalization.characters,
//           style: black15bold,
//           fillColor: DynamicColor.white.withOpacity(0.2),
//           borderStyle: OutlineInputBorder(
//             borderSide: const BorderSide(
//                 style: BorderStyle.solid, color: DynamicColor.lightBlack),
//             borderRadius: BorderRadius.circular(50),
//           ),
//           validator: (val) {
//             if (val.isEmpty) {
//               return TextStrings.textKey['field_req']!;
//             }
//           },
//           onChanged: (value) {
//             setState(() {});
//           }),
//     );
//   }
//
//   Widget buttons() {
//     return CommanButton(
//         heroTag: 1,
//         shap: 50.0,
//         width: MediaQuery.of(context).size.width - 60,
//         buttonName: TextStrings.textKey['search']!,
//         onPressed: () {
//           if (textEditingController.text.isNotEmpty) {
//             PageNavigateScreen().push(
//                 context,
//                 GoogleMapPage(
//                   type: 'indirect',
//                   postalCode: textEditingController.text.trim(),
//                 ));
//           } else {
//             Utils().myToast(context, msg: 'Please Enter postal code');
//           }
//         });
//   }
//
//   Widget alreadyAcunt() {
//     return Visibility(
//       visible: userData == null ? true : false,
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text(TextStrings.textKey['have_an_acnt']!, style: white14w5),
//         GestureDetector(
//             onTap: () {
//               PageNavigateScreen().push(context, const LoginPage());
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(left: 5),
//               child: Text(TextStrings.textKey['sing_in']!, style: primary15w5),
//             ))
//       ]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/images_urls.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/login.dart';
import 'package:munchups_app/Screens/Buyer/Location/location_page.dart';

import '../Component/global_data/global_data.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: alreadyAcunt(),
      body: SingleChildScrollView(
        child: BackGroundWidget(
          backgroundImage: AllImages.loginBG,
          fit: BoxFit.fill,
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getSize55(context: context)),
              Center(
                child: Image.asset(
                  appLogoUrl,
                  fit: BoxFit.fitHeight,
                  height: 200,
                ),
              ),
              SizedBox(height: SizeConfig.getSize55(context: context)),
              searchFiled(),
              SizedBox(height: SizeConfig.getSize35(context: context)),
              buttons(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              InkWell(
                onTap: () {
                  PageNavigateScreen().push(
                    context,
                    GoogleMapPage(
                      type: 'indirect',
                      postalCode: null,
                    ),
                  );
                },
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: DynamicColor.white),
                  ),
                  child: Text('Find Nearby', style: white17Bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getSize30(context: context),
      ),
      child: InputFieldsWithLightWhiteColor(
        labelText: 'Location (Postal Code)',
        controller: textEditingController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        style: black15bold,
        fillColor: DynamicColor.white.withOpacity(0.2),
        borderStyle: OutlineInputBorder(
          borderSide: const BorderSide(
              style: BorderStyle.solid, color: DynamicColor.lightBlack),
          borderRadius: BorderRadius.circular(50),
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget buttons() {
    return CommanButton(
      heroTag: 1,
      shap: 50.0,
      width: MediaQuery.of(context).size.width - 60,
      buttonName: TextStrings.textKey['search']!,
      onPressed: () {
        if (textEditingController.text.isNotEmpty) {
          PageNavigateScreen().push(
            context,
            GoogleMapPage(
              type: 'indirect',
              postalCode: textEditingController.text.trim(),
            ),
          );
        } else {
          Utils().myToast(context, msg: 'Please Enter postal code');
        }
      },
    );
  }

  Widget alreadyAcunt() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(TextStrings.textKey['have_an_acnt']!, style: white14w5),
      GestureDetector(
        onTap: () {
          PageNavigateScreen().push(context, const LoginPage());
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(TextStrings.textKey['sing_in']!, style: primary15w5),
        ),
      ),
    ]);
  }
}
