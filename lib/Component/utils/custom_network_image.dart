import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';

class CustomNetworkImage extends StatefulWidget {
  String url;
  BoxFit? fit;
  CustomNetworkImage({super.key, required this.url, this.fit});

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url,
      fit: (widget.fit == null) ? BoxFit.fill : widget.fit,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(
              color: DynamicColor.primaryColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, exception, stackTrace) {
        return Image.asset(
          'assets/images/image_not_found.png',
          fit: BoxFit.cover,
          height: 130,
          width: double.infinity,
        );
      },
    );
  }
}
