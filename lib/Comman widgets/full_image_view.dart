import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class FullImageView extends StatefulWidget {
  String url;
  FullImageView({super.key, required this.url});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: DynamicColor.black,
            child: Center(child: CustomNetworkImage(url: widget.url)),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.getSize30(context: context),
                  left: SizeConfig.getSize10(context: context)),
              child: IconButton(
                  onPressed: () {
                    PageNavigateScreen().back(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: DynamicColor.white,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
