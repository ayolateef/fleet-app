import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppStyles {
  static var focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(color: AppColors.grey[20]!, width: 1.w),
  );
  static var focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(color: AppColors.grey[20] as Color, width: 1.w),
  );
  static customTextStyle(double fontSize, Color? color, FontWeight fontWeight,
          double? height) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );

  static TextStyle style = TextStyle(
      color: AppColors.grey[40], fontSize: 15.sp, fontWeight: FontWeight.w500);

  static TextStyle style3 = TextStyle(
      color: AppColors.grey[10], fontSize: 14.sp, fontWeight: FontWeight.w600);

  static TextStyle style2 = TextStyle(
      color: AppColors.grey[50], fontSize: 12.sp, fontWeight: FontWeight.w400);

  static TextStyle verificationCodeStyle = TextStyle(
      fontSize: 24.sp,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      height: 1.4);

  static TextStyle largeText = TextStyle(
      fontSize: 24.sp,
      color: AppColors.darkBlue,
      fontWeight: FontWeight.w900,
      height: 1.4);

  static TextStyle smallText = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkBlue,
      fontWeight: FontWeight.w400,
      height: 1.4);

  static TextStyle large700 = TextStyle(
      fontSize: 14.sp,
      color: AppColors.darkBlue,
      fontWeight: FontWeight.w700,
      height: 1.4);
}
