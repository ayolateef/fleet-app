import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'cache_image.dart';

class CabyAssetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  const CabyAssetImage({Key? key, required this.url, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (getImageType(url) == ImageType.svg) {
      return SvgPicture.asset(url, height: height, width: width);
    } else {
      return Image.asset(url, height: height, width: width);
    }
  }

  ImageType getImageType(String url) {
    var path = url.split(".");
    String ext = path[path.length - 1];
    if (ext == "svg") return ImageType.svg;
    return ImageType.png;
  }
}
