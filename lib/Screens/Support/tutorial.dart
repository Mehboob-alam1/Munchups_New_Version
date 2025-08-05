import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  PageController pageController = PageController();

  int currentPage = 0;

  List list = [
    'assets/images/slider-one.png',
    'assets/images/slider-two.png',
    'assets/images/slider-three.png',
    'assets/images/slider-four.png',
    'assets/images/slider-five.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: DynamicColor.primaryColor,
        onPressed: () {
          if (currentPage < list.length) {
            currentPage++;
          } else {
            currentPage = 0;
          }
          pageController.animateToPage(
            currentPage,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeIn,
          );
        },
        child: const Icon(
          Icons.arrow_forward_ios,
          color: DynamicColor.white,
        ),
      ),
      body: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Image.asset(
              list[index],
              fit: BoxFit.fill,
            );
          }),
    );
  }
}
