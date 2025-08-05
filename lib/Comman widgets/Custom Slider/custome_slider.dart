import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munchups_app/Comman%20widgets/full_image_view.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';
import 'package:munchups_app/Component/navigatepage/navigate_page.dart';
import 'package:munchups_app/Component/utils/custom_network_image.dart';
import 'package:munchups_app/Component/utils/sizeConfig/sizeConfig.dart';

class CustomSlider extends StatefulWidget {
  List list;
  CustomSlider({super.key, required this.list});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  PageController pageController = PageController();
  Timer timer = Timer(const Duration(seconds: 0), () {});

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    scrollPageView();
  }

  void scrollPageView() {
    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (currentPage < widget.list.length) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        widget.list.isEmpty
            ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.35,
                child: const Text('No Image available'),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: DynamicColor.black,
                        child: InkWell(
                          onTap: () {
                            PageNavigateScreen().push(context,
                                FullImageView(url: widget.list[index]));
                          },
                          child: CustomNetworkImage(
                            url: widget.list[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }),
              ),
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.only(left: 10),
          margin: EdgeInsets.only(
              left: SizeConfig.getSize25(context: context),
              top: SizeConfig.getSize15(context: context)),
          alignment: Alignment.center,
          // decoration: BoxDecoration(
          //     color: DynamicColor.themeColor,
          //     borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: () {
              PageNavigateScreen().back(context);
            },
            child: const Icon(Icons.arrow_back_ios,
                color: DynamicColor.white, size: 25),
          ),
        )
      ],
    );
  }
}
