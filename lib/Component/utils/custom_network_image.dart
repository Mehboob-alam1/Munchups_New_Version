import 'package:flutter/material.dart';
import 'package:munchups_app/Component/color_class/color_class.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? height;
  final double? width;

  const CustomNetworkImage({
    super.key,
    required this.url,
    this.fit,
    this.height,
    this.width,
  });

  String? _sanitizeUrl(String? raw) {
    if (raw == null) {
      return null;
    }
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final upper = trimmed.toUpperCase();
    if (upper == 'NA' || upper == 'NULL') {
      return null;
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = _sanitizeUrl(url);
    if (normalizedUrl == null) {
      return Image.asset(
        'assets/images/image_not_found.png',
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
      );
    }

    return Image.network(
      normalizedUrl,
      fit: fit ?? BoxFit.fill,
      height: height,
      width: width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height ?? 100,
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
          fit: fit ?? BoxFit.cover,
          height: height,
          width: width,
        );
      },
    );
  }
}
