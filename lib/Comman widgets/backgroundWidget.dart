import 'package:flutter/material.dart';

class BackGroundWidget extends StatelessWidget {
  final Widget child;
  final String backgroundImage;
  final BoxFit fit;
  const BackGroundWidget({
    super.key,
    required this.child,
    required this.backgroundImage,
    this.fit = BoxFit.fitWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          backgroundImage,
          fit: fit,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        child,
      ],
    );
  }
}
