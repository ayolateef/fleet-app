import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import 'colors.dart';

enum ImageType { svg, png }

class GoCabyCacheImage extends StatelessWidget {
  final String imgUrl;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  final double borderRadius;
  final Widget? errorWidget;
  final int? memCacheHeight;
  final int? memCacheWidth;

  const GoCabyCacheImage({
    Key? key,
    this.height,
    this.width,
    required this.imgUrl,
    this.borderRadius = 0,
    this.boxFit = BoxFit.cover,
    this.errorWidget,
    this.memCacheHeight = 400,
    this.memCacheWidth = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: getImageType(imgUrl) == ImageType.svg
          ? svgImageViewer()
          : CachedNetworkImage(
              imageUrl: imgUrl,
              placeholder: (context, url) => shimmerContainer(),
              errorWidget: (context, url, error) => SizedBox(
                height: 20.h,
                width: 20.w,
                child: errorWidget ?? Container(),
              ),
              height: height,
              width: width,
              fit: boxFit,
              memCacheHeight: memCacheHeight,
              memCacheWidth: memCacheWidth,
            ),
    );
  }

  Widget svgImageViewer() {
    return SvgPicture.network(imgUrl,
        height: height,
        width: width,
        fit: boxFit,
        placeholderBuilder: (BuildContext context) => shimmerContainer());
  }

  ImageType getImageType(String url) {
    var path = url.split(".");
    String ext = path[path.length - 1];
    if (ext == "svg") return ImageType.svg;
    return ImageType.png;
  }

  Widget shimmerContainer() => Shimmer.fromColors(
        baseColor: AppColors.grey[60]!,
        highlightColor: AppColors.white,
        child: Container(
          height: height,
          width: width,
          margin: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey[60]!,
                offset: const Offset(0, 0),
                blurRadius: 8.r,
              )
            ],
          ),
        ),
      );
}
