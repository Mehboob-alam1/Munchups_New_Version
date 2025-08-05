import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/Input%20Fields/input_fields_with_lightwhite.dart';
import 'package:munchups_app/Comman%20widgets/comman_button/comman_botton.dart';
import 'package:munchups_app/Component/Strings/strings.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/styles/styles.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class AddressPopupPopUp extends StatefulWidget {
  List list;
  AddressPopupPopUp({
    super.key,
    required this.list,
  });

  @override
  State<AddressPopupPopUp> createState() => _AddressPopupPopUpState();
}

class _AddressPopupPopUpState extends State<AddressPopupPopUp> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: widget.list.isEmpty
            ? SizeConfig.getSizeHeightBy(context: context, by: 0.2)
            : SizeConfig.getSizeHeightBy(context: context, by: 0.5),
        width: MediaQuery.of(context).size.width,
        child: widget.list.isEmpty
            ? const Center(child: Text('No address found'))
            : ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  dynamic data = widget.list[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        addressController.text = data;
                      });
                      PageNavigateScreen().back(context);
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                                child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.location_on,
                                color: DynamicColor.lightGrey,
                              ),
                            )),
                            Expanded(flex: 10, child: Text(data.toString())),
                          ],
                        ),
                        const Divider(
                          color: DynamicColor.lightGrey,
                        )
                      ],
                    ),
                  );
                }),
      ),
      actions: [
        CommanButton(
            heroTag: 1,
            shap: 10.0,
            textSize: 14.0,
            hight: 40.0,
            width: MediaQuery.of(context).size.width - 155,
            buttonName: TextStrings.textKey['add_your_address']!.toUpperCase(),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: Platform.isAndroid ? false : true,
                  builder: (context) => const AddYourAddressPopup());
            })
      ],
    );
  }
}

class AddYourAddressPopup extends StatefulWidget {
  const AddYourAddressPopup({super.key});

  @override
  State<AddYourAddressPopup> createState() => _AddYourAddressPopupState();
}

class _AddYourAddressPopupState extends State<AddYourAddressPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Text('Add Address', style: primary15w6),
      content: InputFieldsWithLightWhiteColor(
          controller: addressController,
          labelText: 'Enter ${TextStrings.textKey['address']!}',
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.streetAddress,
          style: black15bold,
          validator: (val) {
            if (val.isEmpty) {
              return TextStrings.textKey['field_req']!;
            }
          },
          onChanged: (value) {}),
      actions: [
        CommanButton(
            heroTag: 1,
            shap: 10.0,
            textSize: 14.0,
            width: MediaQuery.of(context).size.width * 0.5,
            buttonName: TextStrings.textKey['save']!.toUpperCase(),
            onPressed: () {
              PageNavigateScreen().back(context);
              PageNavigateScreen().back(context);
            })
      ],
    );
  }
}
