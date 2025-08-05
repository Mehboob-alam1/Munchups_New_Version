import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/global_data/global_data.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class CommanImagePicker extends StatefulWidget {
  String networkImage1 = '';
  String networkImage2 = '';
  String networkImage3 = '';
  CommanImagePicker({
    super.key,
    required this.networkImage1,
    required this.networkImage2,
    required this.networkImage3,
  });

  @override
  State<CommanImagePicker> createState() => _CommanImagePickerState();
}

class _CommanImagePickerState extends State<CommanImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showImagePicker(context, 1);
          },
          child: SizedBox(
            height: SizeConfig.getSizeHeightBy(context: context, by: 0.1),
            width: SizeConfig.getSizeWidthBy(context: context, by: 0.2),
            child: imageFile.path.isNotEmpty
                ? Image.file(imageFile, fit: BoxFit.contain)
                : widget.networkImage1.isNotEmpty
                    ? Image.network(widget.networkImage1)
                    : Image.asset('assets/images/icon_camera.png'),
          ),
        ),
        InkWell(
          onTap: () {
            showImagePicker(context, 2);
          },
          child: SizedBox(
            height: SizeConfig.getSizeHeightBy(context: context, by: 0.1),
            width: SizeConfig.getSizeWidthBy(context: context, by: 0.2),
            child: imageFile2.path.isNotEmpty
                ? Image.file(imageFile2, fit: BoxFit.contain)
                : widget.networkImage2.isNotEmpty
                    ? Image.network(widget.networkImage2)
                    : Image.asset('assets/images/add_more.png'),
          ),
        ),
        InkWell(
          onTap: () {
            showImagePicker(context, 3);
          },
          child: SizedBox(
            height: SizeConfig.getSizeHeightBy(context: context, by: 0.1),
            width: SizeConfig.getSizeWidthBy(context: context, by: 0.2),
            child: imageFile3.path.isNotEmpty
                ? Image.file(imageFile3, fit: BoxFit.contain)
                : widget.networkImage3.isNotEmpty
                    ? Image.network(widget.networkImage3)
                    : Image.asset('assets/images/add_more.png'),
          ),
        ),
      ],
    );
  }

  Future<void> _getImage(ImageSource source, int number) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (number == 1) {
          imageFile = File(pickedFile.path);
        } else if (number == 2) {
          imageFile2 = File(pickedFile.path);
        } else {
          imageFile3 = File(pickedFile.path);
        }
      });
    }
  }

  void showImagePicker(BuildContext context, int number) {
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
                  _getImage(ImageSource.gallery, number);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  _getImage(ImageSource.camera, number);
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
}
