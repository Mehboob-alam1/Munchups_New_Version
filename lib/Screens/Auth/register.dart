import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:munchups_app/Apis/get_apis.dart';
import 'package:munchups_app/Apis/post_apis.dart';
import 'package:munchups_app/Comman%20widgets/alert%20boxes/address_list_popup.dart';
import 'package:munchups_app/Comman%20widgets/backgroundWidget.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/custom_drodown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/foodCategory_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman%20dopdown/profession_dropdown.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/images_urls.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';
import 'package:munchups_app/Component/utils/utils.dart';
import 'package:munchups_app/Screens/Auth/otp.dart';
import 'package:munchups_app/Screens/Setting/terms&con.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Comman widgets/Input Fields/input_fields_with_lightwhite.dart';
import '../../Component/Strings/strings.dart';
import '../../Component/providers/auth_flow_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController countryTextController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  Location locationdata = Location();

  List userType = [
    'Buyer',
    'Chef',
    'Grocer',
  ];
  List addressList = [];
  List selectedFood = [];
  File imageFile = File('');

  bool isLoading = false;
  bool passwordVisible = false;

  String firstName = '';
  String lastName = '';
  String userName = '';
  String shopName = '';
  String emailID = '';
  String password = '';
  String mobileNo = '';
  String postalCode = '';
  String countryCode = '+91';
  String countrySortName = 'IN';
  String countrySymbol = '₹';
  String countryFlag = '';

  dynamic roleType;

  dynamic selectedProfession;

  double latitude = 51.5072;
  double longitude = 0.1276;

  saveUserCountry(value, symbol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('country_name', value);
      prefs.setString('country_symbol', symbol);
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    addressController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGroundWidget(
        backgroundImage: AllImages.loginBG,
        fit: BoxFit.fill,
        child: SingleChildScrollView(
          child: Form(
              key: globalKey,
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.getSize25(context: context),
                    right: SizeConfig.getSize25(context: context)),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.getSize50(context: context)),
                    uesrImage(),
                    SizedBox(height: SizeConfig.getSize30(context: context)),
                    CommanDropDown(
                        title: 'Role Type',
                        type: 'Role Type',
                        list: userType,
                        selectedData: roleType,
                        onChanged: (value) {
                          setState(() {
                            roleType = value;
                          });
                          getLocation();
                        }),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    Row(
                      children: [
                        Expanded(child: firstNameFiled()),
                        SizedBox(width: SizeConfig.getSize10(context: context)),
                        Expanded(child: lastNameFiled()),
                      ],
                    ),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    userNameFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    Visibility(
                      visible: roleType.toString().contains('Grocer'),
                      child: Column(
                        children: [
                          shopNameFiled(),
                          SizedBox(
                              height: SizeConfig.getSize10(context: context)),
                        ],
                      ),
                    ),
                    emialFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    passwordFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    mobileFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    postalCodeFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    addressFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    Visibility(
                      visible: roleType.toString().contains('Chef'),
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
                                getLocation();
                              }),
                          SizedBox(
                              height: SizeConfig.getSize10(context: context)),
                          FoodCategoryDropDown(
                              title: 'Select Category',
                              type: 'Food Category',
                              selectedData: selectedFood,
                              onChanged: (value) {
                                setState(() {
                                  selectedFood = value;
                                });
                              }),
                          SizedBox(
                              height: SizeConfig.getSize10(context: context)),
                        ],
                      ),
                    ),
                    countryFiled(),
                    SizedBox(height: SizeConfig.getSize10(context: context)),
                    Row(
                      children: [
                        Expanded(child: stateFiled()),
                        SizedBox(width: SizeConfig.getSize10(context: context)),
                        Expanded(child: cityFiled()),
                      ],
                    ),
                    SizedBox(height: SizeConfig.getSize30(context: context)),
                    bySignin(),
                    SizedBox(height: SizeConfig.getSize25(context: context)),
                    buttons(),
                    SizedBox(height: SizeConfig.getSize20(context: context)),
                    alreadyAcunt(),
                    SizedBox(height: SizeConfig.getSize40(context: context)),
                  ],
                ),
              )),
        ),
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
              : const CircleAvatar(
                  radius: 60,
                  backgroundColor: DynamicColor.lightGrey,
                  backgroundImage: AssetImage('assets/images/user_icon.jpg'),
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
        labelText: TextStrings.textKey['shop_name'],
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
            shopName = value;
          });
        });
  }

  Widget emialFiled() {
    return InputFieldsWithLightWhiteColor(
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

  Widget passwordFiled() {
    return InputFieldsWithLightWhiteColor(
        labelText: TextStrings.textKey['password'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        style: black15bold,
        obsecureText: !passwordVisible,
        maxLines: 1,
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            password = value;
          });
        });
  }

  Widget mobileFiled() {
    return Row(
      children: [
        Expanded(
            child: InkWell(
          onTap: () {
            getCountry(context);
          },
          child: Container(
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DynamicColor.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: countryFlag.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/flag.png',
                        height: 13,
                      ),
                      Text(
                        countryCode,
                        style: black15w5,
                      ),
                    ],
                  )
                : Text(
                    countryFlag + countryCode,
                    style: black15w5,
                  ),
          ),
        )),
        const SizedBox(width: 5),
        Expanded(
          flex: 4,
          child: InputFieldsWithLightWhiteColor(
              labelText: TextStrings.textKey['your_no'],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              style: black15bold,
              // validator: (val) {
              //   if (val.isEmpty) {
              //     return TextStrings.textKey['field_req']!;
              //   }
              // },
              onChanged: (value) {
                setState(() {
                  mobileNo = value;
                });
              }),
        ),
      ],
    );
  }

  Widget postalCodeFiled() {
    return InputFieldsWithLightWhiteColor(
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
      },
    );
  }
  Widget addressFiled() {
    return InputFieldsWithLightWhiteColor(
        controller: addressController,
        labelText: TextStrings.textKey['address'],
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.streetAddress,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {
          setState(() {
            // You can add any logic here if needed
          });
        });
  }
  // Widget addressFiled() {
  //   return InputFieldsWithLightWhiteColor(
  //       onTap: () {
  //         if (postalCode.isNotEmpty) {
  //           // if (addressList.isNotEmpty) {
  //           showDialog(
  //                   context: context,
  //                   barrierDismissible: Platform.isAndroid ? false : true,
  //                   builder: (context) => AddressPopupPopUp(list: addressList))
  //               .then((value) {
  //             if (addressController.text.isNotEmpty) {
  //               getGoogleAddress(addressController.text.trim());
  //             }
  //           });
  //           // } else {
  //           //   Utils().myToast(context, msg: 'Address not found!');
  //           // }
  //         } else {
  //           Utils().myToast(context, msg: 'Please enter postal code');
  //         }
  //       },
  //       readOnly: true,
  //       controller: addressController,
  //       labelText: TextStrings.textKey['address'],
  //       textInputAction: TextInputAction.done,
  //       keyboardType: TextInputType.streetAddress,
  //       style: black15bold,
  //       suffixIcon: const Icon(
  //         Icons.arrow_drop_down,
  //         size: 35,
  //         color: DynamicColor.primaryColor,
  //       ),
  //       validator: (val) {
  //         if (val.isEmpty) {
  //           return TextStrings.textKey['field_req']!;
  //         }
  //       },
  //       onChanged: (value) {});
  // }

  Widget countryFiled() {
    return InputFieldsWithLightWhiteColor(
        labelText: 'Country',
        // readOnly: countryTextController.text.isNotEmpty,
        controller: countryTextController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {});
  }

  Widget stateFiled() {
    return InputFieldsWithLightWhiteColor(
        labelText: 'State',
        // readOnly: stateController.text.isNotEmpty,
        controller: stateController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {});
  }

  Widget cityFiled() {
    return InputFieldsWithLightWhiteColor(
        labelText: 'City',
        //readOnly: cityController.text.isNotEmpty,
        controller: cityController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: black15bold,
        validator: (val) {
          if (val.isEmpty) {
            return TextStrings.textKey['field_req']!;
          }
        },
        onChanged: (value) {});
  }

  Widget bySignin() {
    return Column(
      children: [
        Text(TextStrings.textKey['by_sign']!, style: white17Bold),
        InkWell(
          onTap: () {
            PageNavigateScreen().push(context, TermsAndConditonPage());
            // Utils.launchUrls(context, 'https://standardjcm.com/privacy.html');
          },
          child: Text(
            TextStrings.textKey['term_policy']!,
            style: primary15boldWithUnderline,
          ),
        ),
      ],
    );
  }

  Widget buttons() {
    return CommanButton(
        heroTag: 1,
        shap: 10.0,
        width: MediaQuery.of(context).size.width * 0.5,
        buttonName: TextStrings.textKey['signup']!.toUpperCase(),
        onPressed: () {
          if (globalKey.currentState!.validate()) {
            if (roleType != null) {
              if (mobileNo.isNotEmpty) {
                registerApiCall(context);
              } else {
                Utils().myToast(context, msg: 'Please enter contact number');
              }
            } else {
              Utils().myToast(context, msg: 'Please seclect Role Type');
            }
          }
          // PageNavigateScreen().push(
          //     context,
          //     OtpPage(
          //       emailId: emailID.trim(),
          //     ));
        });
  }

  Widget alreadyAcunt() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(TextStrings.textKey['have_an_acnt']!, style: white14w5),
      GestureDetector(
          onTap: () {
            PageNavigateScreen().back(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(TextStrings.textKey['sing_in']!, style: primary15w5),
          ))
    ]);
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

  void showImagePicker(BuildContext context) {
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

  void getCountry(context) {
    showCountryPicker(
      context: context,
      favorite: <String>['IN'],
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          countryTextController.text = country.name;
          countryCode = '+${country.phoneCode}';
          countrySortName = country.countryCode;

          final format = NumberFormat.simpleCurrency(
              name: CountryCodeUtis.getCountryCode(country.countryCode));
          countryFlag = country.flagEmoji;
          countrySymbol = format.currencySymbol;
          //saveUserCountry(country.countryCode, format.currencySymbol);
        });
      },
      moveAlongWithKeyboard: false,
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
        searchTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
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
      log(e.toString());
    }
  }

  void getGoogleAddress(getPostalCode) async {
    try {
      await GetApiServer().getGoogleAddressApi(getPostalCode).then((value) {
        if (value['status'] == 'OK') {
          countryTextController.text =
              extractPlaceComponent(value['results'][0], 'country');
          stateController.text = extractPlaceComponent(
              value['results'][0], 'administrative_area_level_1');
          cityController.text =
              extractPlaceComponent(value['results'][0], "locality");
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void registerApiCall(context) async {
    Utils().showSpinner(context);
    FocusScope.of(context).requestFocus(FocusNode());

    dynamic body = {};
    if (roleType == 'Buyer') {
      body = {
        'user_type': roleType.toString().toLowerCase(),
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'user_name': userName.trim(),
        'email': emailID.trim(),
        'password': password.trim(),
        'mobile_number': countryCode + mobileNo.trim(),
        'postal_code': postalCode.trim(),
        'address': addressController.text.trim(),
        'country': countryTextController.text.trim(),
        'state': stateController.text.trim(),
        'city': cityController.text.trim(),
        'player_id': playerID,
        'device_type': deviceType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'currency': countrySymbol,
      };
    } else if (roleType == 'Chef') {
      body = {
        'user_type': roleType.toString().toLowerCase(),
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'user_name': userName.trim(),
        'email': emailID.trim(),
        'password': password.trim(),
        'mobile_number': countryCode + mobileNo.trim(),
        'postal_code': postalCode.trim(),
        'address': addressController.text.trim(),
        'profession_id': selectedProfession.toString().trim(),
        'category_id': selectedFood.toString().trim(),
        'country': countryTextController.text.trim(),
        'state': stateController.text.trim(),
        'city': cityController.text.trim(),
        'player_id': playerID,
        'device_type': deviceType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'currency': countrySymbol,
      };
    } else {
      body = {
        'user_type': roleType.toString().toLowerCase(),
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'user_name': userName.trim(),
        'sope_name': shopName.trim(),
        'email': emailID.trim(),
        'password': password.trim(),
        'mobile_number': countryCode + mobileNo.trim(),
        'postal_code': postalCode.trim(),
        'address': addressController.text.trim(),
        'country': countryTextController.text.trim(),
        'state': stateController.text.trim(),
        'city': cityController.text.trim(),
        'player_id': playerID,
        'device_type': deviceType,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'currency': countrySymbol,
      };
    }
    
    try {
      await PostApiServer().registrationApi(body, imageFile).then((value) {
        log('Registration response: $value');
        Utils().stopSpinner(context);

        if (value['success'] == 'true' || value['success'] == true) {
          print('Registration successful');
          Utils().stopSpinner(context);
          
          // Save user data and start OTP verification
          final authFlowProvider = Provider.of<AuthFlowProvider>(context, listen: false);
          authFlowProvider.startRegistration(
            {
              'user_id': value['user_id'],
              'first_name': value['first_name'],
              'last_name': value['last_name'],
              'user_name': value['user_name'],
              'email': value['email'],
              'phone': value['phone'],
              'user_type': value['user_type'],
              'image': value['image'],
            },
            emailID.trim(),
          );
          
          Utils().myToast(context, msg: 'Registration successful! Please verify your email.');
          
          // Navigate to OTP screen
          PageNavigateScreen().push(
            context,
            OtpPage(
              emailId: emailID.trim(),
              type: 'register',
            ),
          );
        } else {
          // Handle error
          Utils().stopSpinner(context);
          Utils().myToast(context, msg: value['msg'] ?? 'Registration failed');
        }
      }).catchError((error) {
        log('Registration catchError: $error');
        Utils().stopSpinner(context);
        Utils().myToast(context, msg: 'Registration failed. Please try again.');
      });
    } catch (e) {
      Utils().stopSpinner(context);
      log('Registration error: $e');
      Utils().myToast(context, msg: 'Registration failed. Please try again.');
    }
  }

  Future<void> getLocation() async {
    try {
      await locationdata.getLocation().then((value) {
        setState(() {
          latitude = value.latitude!;
          longitude = value.longitude!;
        });
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}

String extractPlaceComponent(Map<String, dynamic> placeDetails, String type) {
  for (var component in placeDetails['address_components']) {
    if (component['types'].toString().contains(type)) {
      return component['long_name'];
    }
  }
  return '';
}

class CountryCodeUtis {
  static String getCountryCode(String countryCode) {
    final Map<String, String> countryCurrencyMap = {
      'AF': 'AFN',
      'AX': 'EUR',
      'AL': 'ALL',
      'DZ': 'DZD',
      'AS': 'USD',
      'AD': 'EUR',
      'AO': 'AOA',
      'AI': 'XCD',
      'AQ': 'N/A',
      'AG': 'XCD',
      'AR': 'ARS',
      'AM': 'AMD',
      'AW': 'AWG',
      'AU': 'AUD',
      'AT': 'EUR',
      'AZ': 'AZN',
      'BS': 'BSD',
      'BH': 'BHD',
      'BD': 'BDT',
      'BB': 'BBD',
      'BY': 'BYN',
      'BE': 'EUR',
      'BZ': 'BZD',
      'BJ': 'XOF',
      'BM': 'BMD',
      'BT': 'BTN',
      'BO': 'BOB',
      'BQ': 'USD',
      'BA': 'BAM',
      'BW': 'BWP',
      'BV': 'NOK',
      'BR': 'BRL',
      'IO': 'USD',
      'BN': 'BND',
      'BG': 'BGN',
      'BF': 'XOF',
      'BI': 'BIF',
      'CV': 'CVE',
      'KH': 'KHR',
      'CM': 'XAF',
      'CA': 'CAD',
      'KY': 'KYD',
      'CF': 'XAF',
      'TD': 'XAF',
      'CL': 'CLP',
      'CN': 'CNY',
      'CX': 'AUD',
      'CC': 'AUD',
      'CO': 'COP',
      'KM': 'KMF',
      'CD': 'CDF',
      'CG': 'XAF',
      'CK': 'NZD',
      'CR': 'CRC',
      'HR': 'HRK',
      'CU': 'CUP',
      'CW': 'ANG',
      'CY': 'EUR',
      'CZ': 'CZK',
      'DK': 'DKK',
      'DJ': 'DJF',
      'DM': 'XCD',
      'DO': 'DOP',
      'EC': 'USD',
      'EG': 'EGP',
      'SV': 'USD',
      'GQ': 'XAF',
      'ER': 'ERN',
      'EE': 'EUR',
      'ET': 'ETB',
      'FK': 'FKP',
      'FO': 'DKK',
      'FJ': 'FJD',
      'FI': 'EUR',
      'FR': 'EUR',
      'GF': 'EUR',
      'PF': 'XPF',
      'TF': 'EUR',
      'GA': 'XAF',
      'GM': 'GMD',
      'GE': 'GEL',
      'DE': 'EUR',
      'GH': 'GHS',
      'GI': 'GIP',
      'GR': 'EUR',
      'GL': 'DKK',
      'GD': 'XCD',
      'GP': 'EUR',
      'GU': 'USD',
      'GT': 'GTQ',
      'GG': 'GBP',
      'GN': 'GNF',
      'GW': 'XOF',
      'GY': 'GYD',
      'HT': 'HTG',
      'HM': 'AUD',
      'VA': 'EUR',
      'HN': 'HNL',
      'HK': 'HKD',
      'HU': 'HUF',
      'IS': 'ISK',
      'IN': 'INR',
      'ID': 'IDR',
      'IR': 'IRR',
      'IQ': 'IQD',
      'IE': 'EUR',
      'IM': 'GBP',
      'IL': 'ILS',
      'IT': 'EUR',
      'JM': 'JMD',
      'JP': 'JPY',
      'JE': 'GBP',
      'JO': 'JOD',
      'KZ': 'KZT',
      'KE': 'KES',
      'KI': 'AUD',
      'KP': 'KPW',
      'KR': 'KRW',
      'KW': 'KWD',
      'KG': 'KGS',
      'LA': 'LAK',
      'LV': 'EUR',
      'LB': 'LBP',
      'LS': 'LSL',
      'LR': 'LRD',
      'LY': 'LYD',
      'LI': 'CHF',
      'LT': 'EUR',
      'LU': 'EUR',
      'MO': 'MOP',
      'MK': 'MKD',
      'MG': 'MGA',
      'MW': 'MWK',
      'MY': 'MYR',
      'MV': 'MVR',
      'ML': 'XOF',
      'MT': 'EUR',
      'MH': 'USD',
      'MQ': 'EUR',
      'MR': 'MRU',
      'MU': 'MUR',
      'YT': 'EUR',
      'MX': 'MXN',
      'FM': 'USD',
      'MD': 'MDL',
      'MC': 'EUR',
      'MN': 'MNT',
      'ME': 'EUR',
      'MS': 'XCD',
      'MA': 'MAD',
      'MZ': 'MZN',
      'MM': 'MMK',
      'NA': 'NAD',
      'NR': 'AUD',
      'NP': 'NPR',
      'NL': 'EUR',
      'NC': 'XPF',
      'NZ': 'NZD',
      'NI': 'NIO',
      'NE': 'XOF',
      'NG': 'NGN',
      'NU': 'NZD',
      'NF': 'AUD',
      'MP': 'USD',
      'NO': 'NOK',
      'OM': 'OMR',
      'PK': 'PKR',
      'PW': 'USD',
      'PS': 'ILS',
      'PA': 'PAB',
      'PG': 'PGK',
      'PY': 'PYG',
      'PE': 'PEN',
      'PH': 'PHP',
      'PN': 'NZD',
      'PL': 'PLN',
      'PT': 'EUR',
      'PR': 'USD',
      'QA': 'QAR',
      'RE': 'EUR',
      'RO': 'RON',
      'RU': 'RUB',
      'RW': 'RWF',
      'BL': 'EUR',
      'SH': 'SHP',
      'KN': 'XCD',
      'LC': 'XCD',
      'MF': 'EUR',
      'PM': 'EUR',
      'VC': 'XCD',
      'WS': 'WST',
      'SM': 'EUR',
      'ST': 'STN',
      'SA': 'SAR',
      'SN': 'XOF',
      'RS': 'RSD',
      'SC': 'SCR',
      'SL': 'SLL',
      'SG': 'SGD',
      'SX': 'ANG',
      'SK': 'EUR',
      'SI': 'EUR',
      'SB': 'SBD',
      'SO': 'SOS',
      'ZA': 'ZAR',
      'GS': 'GBP',
      'SS': 'SSP',
      'ES': 'EUR',
      'LK': 'LKR',
      'SD': 'SDG',
      'SR': 'SRD',
      'SJ': 'NOK',
      'SZ': 'SZL',
      'SE': 'SEK',
      'CH': 'CHF',
      'SY': 'SYP',
      'TW': 'TWD',
      'TJ': 'TJS',
      'TZ': 'TZS',
      'TH': 'THB',
      'TL': 'USD',
      'TG': 'XOF',
      'TK': 'NZD',
      'TO': 'TOP',
      'TT': 'TTD',
      'TN': 'TND',
      'TR': 'TRY',
      'TM': 'TMT',
      'TC': 'USD',
      'TV': 'AUD',
      'UG': 'UGX',
      'UA': 'UAH',
      'AE': 'AED',
      'GB': 'GBP',
      'US': 'USD',
      'UM': 'USD',
      'UY': 'UYU',
      'UZ': 'UZS',
      'VU': 'VUV',
      'VE': 'VES',
      'VN': 'VND',
      'VG': 'USD',
      'VI': 'USD',
      'WF': 'XPF',
      'EH': 'MAD',
      'YE': 'YER',
      'ZM': 'ZMW',
      'ZW': 'ZWL'
    };

    return countryCurrencyMap[countryCode] ?? 'USD';
  }
}
