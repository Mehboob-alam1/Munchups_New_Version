// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:munchups_app/Apis/get_apis.dart';
// import 'package:munchups_app/Apis/post_apis.dart';
// import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
// import 'package:munchups_app/Comman%20widgets/alert%20boxes/address_list_popup.dart';
// import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
// import 'package:munchups_app/Comman%20widgets/comman%20dopdown/profession_dropdown.dart';
// import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
// import 'package:munchups_app/Component/Strings/strings.dart';
// import 'package:munchups_app/Component/color_class/color_class.dart';
// import 'package:munchups_app/Component/global_data/global_data.dart';
// import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
// import 'package:munchups_app/Component/styles/styles.dart';
// import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
// import 'package:munchups_app/Component/utils/utils.dart';
// import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
// import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
// import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class BuyerProfilePage extends StatefulWidget {
//   const BuyerProfilePage({super.key});
//
//   @override
//   State<BuyerProfilePage> createState() => _BuyerProfilePageState();
// }
//
// class _BuyerProfilePageState extends State<BuyerProfilePage> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//
//   bool isLoading = false;
//
//   String latitude = "51.5072";
//   String longitude = "0.1276";
//
//   dynamic userData;
//
//   File imageFile = File('');
//
//   List addressList = [];
//   List selectedFood = [];
//
//   String getUserType = 'Buyer';
//   String image = '';
//   String firstName = '';
//   String lastName = '';
//   String userName = '';
//   String shopName = '';
//   String emailID = '';
//   String mobileNo = '';
//   String postalCode = '';
//
//   dynamic selectedProfession;
//
//   getUsertype() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isLoading = true;
//       if (prefs.getString("user_type") != null) {
//         getUserType = prefs.getString("user_type").toString();
//       }
//       userData = jsonDecode(prefs.getString('data').toString());
//       if (userData != null) {
//         intData(userData);
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getUsertype();
//   }
//
//   void intData(value) async {
//     setState(() {
//       image = value['image'];
//       firstName = value['first_name'];
//       lastName = value['last_name'];
//       userName = value['user_name'];
//       emailID = value['email'];
//       mobileNo = value['phone'];
//       if (value['address'] != null) {
//         addressController.text = value['address'];
//       }
//       if (value['postal_code'] != null) {
//         postalCode = userData['postal_code'];
//         getOnlineAddress(postalCode);
//       }
//       if (getUserType == 'chef') {
//         selectedProfession = value['profession_id'].toString();
//         if (value['category'] != 'NA') {
//           if (value['category'].length > 0) {
//             for (var element in value['category']) {
//               selectedFood.add(element['category_id']);
//             }
//           }
//         }
//       }
//       if (getUserType == 'grocer') {
//         shopName = value['shop_name'].toString();
//       }
//       if (value['latitude'] != 'NA' && value['longitude'] != 'NA') {
//         latitude = value['latitude'];
//         longitude = value['longitude'];
//       }
//     });
//     Timer(const Duration(seconds: 1), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     addressController.text = '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? const Center(
//               child:
//                   CircularProgressIndicator(color: DynamicColor.primaryColor))
//           : SingleChildScrollView(
//               child: Form(
//                   key: globalKey,
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         left: SizeConfig.getSize25(context: context),
//                         right: SizeConfig.getSize25(context: context)),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                             height: SizeConfig.getSize50(context: context)),
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: IconButton(
//                               onPressed: () {
//                                 PageNavigateScreen().back(context);
//                               },
//                               icon: const Icon(
//                                 Icons.arrow_back_ios,
//                                 color: DynamicColor.white,
//                               )),
//                         ),
//                         uesrImage(),
//                         SizedBox(
//                             height: SizeConfig.getSize30(context: context)),
//                         firstNameFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         lastNameFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         userNameFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         Visibility(
//                           visible: getUserType.contains('grocer'),
//                           child: Column(
//                             children: [
//                               shopNameFiled(),
//                               SizedBox(
//                                   height:
//                                       SizeConfig.getSize10(context: context)),
//                             ],
//                           ),
//                         ),
//                         emialFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         mobileFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         postalCodeFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         addressFiled(),
//                         SizedBox(
//                             height: SizeConfig.getSize10(context: context)),
//                         Visibility(
//                           visible: getUserType.toString().contains('chef'),
//                           child: Column(
//                             children: [
//                               ProfessionDropDown(
//                                   title: 'Select Profession',
//                                   type: 'Select Profession',
//                                   selectedData: selectedProfession,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedProfession = value;
//                                     });
//                                   }),
//                               SizedBox(
//                                   height:
//                                       SizeConfig.getSize10(context: context)),
//                               FoodCategoryDropDown(
//                                   title: 'Select Category',
//                                   type: 'Food Category',
//                                   selectedData: selectedFood,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedFood = value;
//                                     });
//                                   }),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                             height: SizeConfig.getSize30(context: context)),
//                         SizedBox(
//                             height: SizeConfig.getSize25(context: context)),
//                         buttons(),
//                         SizedBox(
//                             height: SizeConfig.getSize40(context: context)),
//                       ],
//                     ),
//                   )),
//             ),
//     );
//   }
//
//   Widget uesrImage() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         InkWell(
//           onTap: () {
//             showImagePicker(context);
//           },
//           child: imageFile.path.isNotEmpty
//               ? CircleAvatar(
//                   radius: 60,
//                   backgroundColor: DynamicColor.lightGrey,
//                   backgroundImage: FileImage(imageFile),
//                 )
//               : image.isNotEmpty
//                   ? CircleAvatar(
//                       radius: 60,
//                       backgroundColor: DynamicColor.lightGrey,
//                       backgroundImage: NetworkImage(image),
//                     )
//                   : const CircleAvatar(
//                       radius: 60,
//                       backgroundColor: DynamicColor.lightGrey,
//                       backgroundImage:
//                           AssetImage('assets/images/user_icon.jpg'),
//                     ),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: Padding(
//             padding: EdgeInsets.only(
//                 left: SizeConfig.getSize60(context: context) +
//                     SizeConfig.getSize10(context: context),
//                 top: SizeConfig.getSize40(context: context) +
//                     SizeConfig.getSize25(context: context)),
//             child: InkWell(
//               onTap: () {
//                 showImagePicker(context);
//               },
//               child: const CircleAvatar(
//                 radius: 20,
//                 backgroundColor: DynamicColor.primaryColor,
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: DynamicColor.white,
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget firstNameFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: firstName,
//         labelText: TextStrings.textKey['first_name'],
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             firstName = value;
//           });
//         });
//   }
//
//   Widget lastNameFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: lastName,
//         labelText: TextStrings.textKey['last_name'],
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             lastName = value;
//           });
//         });
//   }
//
//   Widget userNameFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: userName,
//         labelText: TextStrings.textKey['user_name'],
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             userName = value;
//           });
//         });
//   }
//
//   Widget shopNameFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: shopName,
//         labelText: 'Shop Name',
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {});
//         });
//   }
//
//   Widget emialFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: emailID,
//         labelText: TextStrings.textKey['email_add'],
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.emailAddress,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             emailID = value;
//           });
//         });
//   }
//
//   Widget mobileFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: mobileNo,
//         labelText: TextStrings.textKey['your_no'],
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.phone,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             mobileNo = value;
//           });
//         });
//   }
//
//   Widget postalCodeFiled() {
//     return InputFieldsWithLightWhiteColor(
//         initialValue: postalCode,
//         labelText: TextStrings.textKey['zip'],
//         textInputAction: TextInputAction.done,
//         textCapitalization: TextCapitalization.characters,
//         keyboardType: TextInputType.text,
//         style: black15bold,
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {
//           setState(() {
//             postalCode = value;
//             addressController.text = '';
//             getOnlineAddress(value);
//           });
//         });
//   }
//
//   Widget addressFiled() {
//     return InputFieldsWithLightWhiteColor(
//         onTap: () {
//           if (postalCode.isNotEmpty) {
//             // if (addressList.isNotEmpty) {
//             showDialog(
//                 context: context,
//                 barrierDismissible: Platform.isAndroid ? false : true,
//                 builder: (context) => AddressPopupPopUp(list: addressList));
//             // } else {
//             //   Utils().myToast(context, msg: 'Address not found!');
//             // }
//           } else {
//             Utils().myToast(context, msg: 'Please enter postal code');
//           }
//         },
//         readOnly: true,
//         controller: addressController,
//         labelText: TextStrings.textKey['address'],
//         textInputAction: TextInputAction.done,
//         keyboardType: TextInputType.streetAddress,
//         style: black15bold,
//         suffixIcon: const Icon(
//           Icons.arrow_drop_down,
//           size: 35,
//           color: DynamicColor.primaryColor,
//         ),
//         validator: (val) {
//           if (val.isEmpty) {
//             return TextStrings.textKey['field_req']!;
//           }
//         },
//         onChanged: (value) {});
//   }
//
//   Widget buttons() {
//     return CommanButton(
//         heroTag: 1,
//         shap: 10.0,
//         width: MediaQuery.of(context).size.width * 0.5,
//         buttonName: TextStrings.textKey['update']!.toUpperCase(),
//         onPressed: () {
//           updateProfileApiCall(context);
//         });
//   }
//
//   Future<void> _getImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   void showImagePicker(
//     BuildContext context,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 onTap: () {
//                   _getImage(ImageSource.gallery);
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 onTap: () {
//                   _getImage(ImageSource.camera);
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text(
//                   'Cancel',
//                   style: TextStyle(
//                       color: DynamicColor.redColor,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void getOnlineAddress(getPostalCode) async {
//     addressList.clear();
//     try {
//       await GetApiServer().getOnlineAddressApi(getPostalCode).then((value) {
//         if (value['suggestions'].isNotEmpty) {
//           setState(() {
//             for (var element in value['suggestions']) {
//               addressList.add(element['address']);
//             }
//           });
//         }
//       });
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   void updateProfileApiCall(context) async {
//     Utils().showSpinner(context);
//     dynamic body = {};
//     if (getUserType == 'buyer') {
//       body = {
//         'user_id': userData['user_id'].toString(),
//         'first_name': firstName.trim(),
//         'last_name': lastName.trim(),
//         'user_name': userName.trim(),
//         'email': emailID.trim(),
//         'address': addressController.text.trim(),
//         'mobile_number': mobileNo.trim(),
//         'postal_code': postalCode.trim(),
//         'player_id': playerID,
//         'device_type': deviceType,
//         'latitude': latitude.toString(),
//         'longitude': longitude.toString(),
//       };
//     } else if (getUserType == 'chef') {
//       body = {
//         'user_id': userData['user_id'].toString(),
//         'first_name': firstName.trim(),
//         'last_name': lastName.trim(),
//         'user_name': userName.trim(),
//         'email': emailID.trim(),
//         'address': addressController.text.trim(),
//         'mobile_number': mobileNo.trim(),
//         'postal_code': postalCode.trim(),
//         'profession_id': selectedProfession.toString().trim(),
//         'category_id': jsonEncode(selectedFood),
//         'player_id': playerID,
//         'device_type': deviceType,
//         'latitude': latitude.toString(),
//         'longitude': longitude.toString(),
//       };
//     } else {
//       body = {
//         'user_id': userData['user_id'].toString(),
//         'first_name': firstName.trim(),
//         'last_name': lastName.trim(),
//         'user_name': userName.trim(),
//         'shop_name': shopName.trim(),
//         'email': emailID.trim(),
//         'address': addressController.text.trim(),
//         'mobile_number': mobileNo.trim(),
//         'postal_code': postalCode.trim(),
//         'player_id': playerID,
//         'device_type': deviceType,
//         'latitude': latitude.toString(),
//         'longitude': longitude.toString(),
//       };
//     }
//     try {
//       await PostApiServer().updateProfileApi(body, imageFile).then((value) {
//         FocusScope.of(context).requestFocus(FocusNode());
//         Utils().stopSpinner(context);
//
//         if (value['success'] == 'true') {
//           addressController.text = '';
//           Utils().myToast(context, msg: value['msg']);
//           if (getUserType == 'buyer') {
//             Timer(const Duration(milliseconds: 600), () {
//               PageNavigateScreen()
//                   .pushRemovUntil(context, const BuyerHomePage());
//             });
//           } else if (getUserType == 'chef') {
//             Timer(const Duration(milliseconds: 600), () {
//               PageNavigateScreen()
//                   .pushRemovUntil(context, const ChefHomePage());
//             });
//           } else {
//             Timer(const Duration(milliseconds: 600), () {
//               PageNavigateScreen()
//                   .pushRemovUntil(context, const GrocerHomePage());
//             });
//           }
//         } else {
//           Utils().myToast(context, msg: value['msg']);
//         }
//       });
//     } catch (e) {
//       Utils().stopSpinner(context);
//       log(e.toString());
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:munchups_app/Comman%20widgets/app_bar/back_icon_appbar.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/styles/styles.dart';

class RateChefPage extends StatefulWidget {
  const RateChefPage({super.key});

  @override
  _RateChefPageState createState() => _RateChefPageState();
}

class _RateChefPageState extends State<RateChefPage> {
  double _rating = 0.0;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void handleSubmit() {
    // Show dialog to simulate feedback submission
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thank You!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("⭐ Rating: $_rating"),
            const SizedBox(height: 10),
            Text("💬 Comment: ${commentController.text.trim()}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackIconCustomAppBar(title: 'Chef Rating'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Rate this Chef', style: primary25bold),
            const SizedBox(height: 20.0),

            // ⭐ Rating bar
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),

            const SizedBox(height: 20.0),

            // 💬 Comment box
            TextField(
              controller: commentController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Write your comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 50.0),

            // ✅ Submit Button
            CommanButton(
              heroTag: 1,
              shap: 10.0,
              hight: 40.0,
              width: MediaQuery.of(context).size.width * 0.4,
              buttonName: TextStrings.textKey['submit']!.toUpperCase(),
              onPressed: handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
