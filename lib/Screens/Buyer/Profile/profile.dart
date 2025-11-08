import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/address_list_popup.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/profession_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Buyer/Home/buyer_home.dart';
import 'package:munchups_app/Screens/Chef/Home/chef_home.dart';
import 'package:munchups_app/Screens/Grocer/grocer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:munchups_app/presentation/providers/data_provider.dart';
import 'package:munchups_app/presentation/providers/settings_provider.dart';
import 'package:munchups_app/domain/usecases/data/update_profile_usecase.dart';

class BuyerProfilePage extends StatefulWidget {
  const BuyerProfilePage({super.key});

  @override
  State<BuyerProfilePage> createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool _providerApplied = false;

  String latitude = "51.5072";
  String longitude = "0.1276";

  dynamic userData;

  File imageFile = File('');

  List addressList = [];
  List selectedFood = [];

  String getUserType = 'Buyer';
  String image = '';
  String firstName = '';
  String lastName = '';
  String userName = '';
  String shopName = '';
  String emailID = '';
  String mobileNo = '';
  String postalCode = '';

  dynamic selectedProfession;

  Map<String, dynamic> _mapFromAny(Map source) {
    return source.map((key, value) => MapEntry(key.toString(), value));
  }

  Map<String, dynamic> _extractProfileData(Map<String, dynamic> source) {
    if (source['profile_data'] is Map) {
      return _mapFromAny(source['profile_data'] as Map);
    }
    if (source['data'] is Map) {
      return _mapFromAny(source['data'] as Map);
    }
    return _mapFromAny(source);
  }

  getUsertype() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      if (prefs.getString("user_type") != null) {
        getUserType = prefs.getString("user_type").toString();
      }
      userData = jsonDecode(prefs.getString('data').toString());
      if (userData != null) {
        intData(userData);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUsertype();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DataProvider>().fetchUserProfile(forceRefresh: true);
      }
    });
  }

  void intData(value, {bool fromProvider = false}) async {
    setState(() {
      userData = value;
      image = value['image'] ?? image;
      firstName = value['first_name']?.toString() ?? firstName;
      lastName = value['last_name']?.toString() ?? lastName;
      userName = value['user_name']?.toString() ?? userName;
      emailID = value['email']?.toString() ?? emailID;
      mobileNo = value['phone']?.toString() ?? mobileNo;
      if (value['address'] != null && value['address'] != 'NA') {
        addressController.text = value['address'];
      }
      if (value['postal_code'] != null && value['postal_code'] != 'NA') {
        postalCode = value['postal_code'].toString();
        getOnlineAddress(postalCode);
      }
      if (getUserType == 'chef') {
        selectedProfession = value['profession_id']?.toString();
        selectedFood.clear();
        if (value['category'] is List) {
          for (var element in value['category']) {
            selectedFood.add(element['category_id']);
          }
        }
      }
      if (getUserType == 'grocer') {
        shopName = value['shop_name']?.toString() ?? shopName;
      }
      if (value['latitude'] != null && value['latitude'] != 'NA') {
        latitude = value['latitude'].toString();
      }
      if (value['longitude'] != null && value['longitude'] != 'NA') {
        longitude = value['longitude'].toString();
      }
      if (fromProvider) {
        _providerApplied = true;
      }
    });

    if (fromProvider) {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    addressController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final profileFromProvider = _extractProfileData(dataProvider.userProfile);

    if (!_providerApplied && profileFromProvider.isNotEmpty) {
      _providerApplied = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        intData(profileFromProvider, fromProvider: true);
      });
    }

    final isBusy = isLoading || (dataProvider.isLoading && !_providerApplied);

    return Scaffold(
      body: isBusy
          ? const Center(
              child:
                  CircularProgressIndicator(color: DynamicColor.primaryColor))
          : SingleChildScrollView(
              child: Form(
                  key: globalKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.getSize25(context: context),
                        right: SizeConfig.getSize25(context: context)),
                    child: Column(
                      children: [
                        SizedBox(
                            height: SizeConfig.getSize50(context: context)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                PageNavigateScreen().back(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: DynamicColor.white,
                              )),
                        ),
                        uesrImage(),
                        SizedBox(
                            height: SizeConfig.getSize30(context: context)),
                        firstNameFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        lastNameFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        userNameFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        Visibility(
                          visible: getUserType.contains('grocer'),
                          child: Column(
                            children: [
                              shopNameFiled(),
                              SizedBox(
                                  height:
                                      SizeConfig.getSize10(context: context)),
                            ],
                          ),
                        ),
                        emialFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        mobileFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        postalCodeFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        addressFiled(),
                        SizedBox(
                            height: SizeConfig.getSize10(context: context)),
                        Visibility(
                          visible: getUserType.toString().contains('chef'),
                          child: Column(
                            children: [
                              ProfessionDropDown(
                                  title: 'Select Profession',
                                  type: 'Select Profession',
                                  selectedData: selectedProfession,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedProfession = value;
                                    });
                                  }),
                              SizedBox(
                                  height:
                                      SizeConfig.getSize10(context: context)),
                              FoodCategoryDropDown(
                                  title: 'Select Category',
                                  type: 'Food Category',
                                  selectedData: selectedFood,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFood = value;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: SizeConfig.getSize30(context: context)),
                        SizedBox(
                            height: SizeConfig.getSize25(context: context)),
                        buttons(),
                        SizedBox(
                            height: SizeConfig.getSize40(context: context)),
                      ],
                    ),
                  )),
            ),
    );
  }

  Widget uesrImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () {
            showImagePicker(context);
          },
          child: imageFile.path.isNotEmpty
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: DynamicColor.lightGrey,
                  backgroundImage: FileImage(imageFile),
                )
              : image.isNotEmpty
                  ? CircleAvatar(
                      radius: 60,
                      backgroundColor: DynamicColor.lightGrey,
                      backgroundImage: NetworkImage(image),
                    )
                  : const CircleAvatar(
                      radius: 60,
                      backgroundColor: DynamicColor.lightGrey,
                      backgroundImage:
                          AssetImage('assets/images/user_icon.jpg'),
                    ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.getSize60(context: context) +
                    SizeConfig.getSize10(context: context),
                top: SizeConfig.getSize40(context: context) +
                    SizeConfig.getSize25(context: context)),
            child: InkWell(
              onTap: () {
                showImagePicker(context);
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: DynamicColor.primaryColor,
                child: Icon(
                  Icons.camera_alt,
                  color: DynamicColor.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget firstNameFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: firstName,
        labelText: TextStrings.textKey['first_name'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            firstName = value;
          });
        });
  }

  Widget lastNameFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: lastName,
        labelText: TextStrings.textKey['last_name'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            lastName = value;
          });
        });
  }

  Widget userNameFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: userName,
        labelText: TextStrings.textKey['user_name'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            userName = value;
          });
        });
  }

  Widget shopNameFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: shopName,
        labelText: 'Shop Name',
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {});
        });
  }

  Widget emialFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: emailID,
        labelText: TextStrings.textKey['email_add'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            emailID = value;
          });
        });
  }

  Widget mobileFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: mobileNo,
        labelText: TextStrings.textKey['your_no'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            mobileNo = value;
          });
        });
  }

  Widget postalCodeFiled() {
    return InputFieldsWithLightWhiteColor(
        initialValue: postalCode,
        labelText: TextStrings.textKey['zip'],
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            postalCode = value;
            addressController.text = '';
            getOnlineAddress(value);
          });
        });
  }

  Widget addressFiled() {
    return InputFieldsWithLightWhiteColor(
        onTap: () {
          if (postalCode.isNotEmpty) {
            // if (addressList.isNotEmpty) {
            showDialog(
                context: context,
                barrierDismissible: Platform.isAndroid ? false : true,
                builder: (context) => AddressPopupPopUp(list: addressList));
            // } else {
            //   Utils().myToast(context, msg: 'Address not found!');
            // }
          } else {
            Utils().myToast(context, msg: 'Please enter postal code');
          }
        },
        readOnly: true,
        controller: addressController,
        labelText: TextStrings.textKey['address'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.streetAddress,
        style: black15bold,
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          size: 35,
          color: DynamicColor.primaryColor,
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {});
  }

  Widget buttons() {
    return CommanButton(
        heroTag: 1,
        shap: 10.0,
        width: MediaQuery.of(context).size.width * 0.5,
        buttonName: TextStrings.textKey['update']!.toUpperCase(),
        onPressed: () {
          updateProfileApiCall(context);
        });
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void showImagePicker(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: DynamicColor.redColor,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getOnlineAddress(getPostalCode) async {
    addressList.clear();
    try {
      await GetApiServer().getOnlineAddressApi(getPostalCode).then((value) {
        if (value['suggestions'].isNotEmpty) {
          setState(() {
            for (var element in value['suggestions']) {
              addressList.add(element['address']);
            }
          });
        }
      });
    } catch (e) {
      print('BuyerProfile: ${e.toString()}');
    }
  }

  void updateProfileApiCall(context) async {
    Utils().showSpinner(context);
    final dataProvider = context.read<DataProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    Map<String, dynamic> body;
    final userId = userData['user_id']?.toString() ?? '';

    if (getUserType == 'buyer') {
      body = {
        'user_id': userId,
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'user_name': userName.trim(),
        'email': emailID.trim(),
        'address': addressController.text.trim(),
        'mobile_number': mobileNo.trim(),
        'postal_code': postalCode.trim(),
        'player_id': playerID,
        'device_type': deviceType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };
    } else if (getUserType == 'chef') {
      body = {
        'user_id': userId,
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'user_name': userName.trim(),
        'email': emailID.trim(),
        'address': addressController.text.trim(),
        'mobile_number': mobileNo.trim(),
        'postal_code': postalCode.trim(),
        'profession_id': selectedProfession?.toString() ?? '',
        'category_id': jsonEncode(selectedFood),
        'player_id': playerID,
        'device_type': deviceType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };
    } else {
      body = {
        'user_id': userId,
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'user_name': userName.trim(),
        'shop_name': shopName.trim(),
        'email': emailID.trim(),
        'address': addressController.text.trim(),
        'mobile_number': mobileNo.trim(),
        'postal_code': postalCode.trim(),
        'player_id': playerID,
        'device_type': deviceType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };
    }

    try {
      final params = UpdateProfileParams(
        body: body,
        imagePath: imageFile.path.isNotEmpty ? imageFile.path : null,
      );
      final success = await settingsProvider.updateProfile(params);
      Utils().stopSpinner(context);

      if (success) {
        addressController.text = '';
        _providerApplied = false;
        await dataProvider.fetchUserProfile(forceRefresh: true);
        final message = settingsProvider.submitMessage.isNotEmpty
            ? settingsProvider.submitMessage
            : 'Profile updated successfully';
        Utils().myToast(context, msg: message);

        Timer(const Duration(milliseconds: 600), () {
          if (getUserType == 'buyer') {
            PageNavigateScreen().pushRemovUntil(context, const BuyerHomePage());
          } else if (getUserType == 'chef') {
            PageNavigateScreen().pushRemovUntil(context, const ChefHomePage());
          } else {
            PageNavigateScreen().pushRemovUntil(context, const GrocerHomePage());
          }
        });
      } else {
        final error = settingsProvider.submitError.isNotEmpty
            ? settingsProvider.submitError
            : 'Profile update failed';
        Utils().myToast(context, msg: error);
      }
    } catch (e) {
      Utils().stopSpinner(context);
      Utils().myToast(context, msg: e.toString());
      print('BuyerProfile: ${e.toString()}');
    } finally {
      settingsProvider.clearSubmitState();
    }
  }
}
