import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'navigation/navigation_service.dart';

class CabyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingIcon;
  final String? titleText;
  final Widget? titleWidget;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool centerTitle;
  final double? elevation;
  final Color? shadowColor;
  final double? appHeight;
  final double? leadingWidth;
  final bool showUnderline;

  const CabyAppBar(
      {Key? key,
      this.leadingIcon,
      this.titleText,
      this.titleWidget,
      this.trailing,
      this.centerTitle = true,
      this.elevation = 0,
      this.shadowColor = Colors.white,
      this.backgroundColor,
      this.leadingWidth = 56.0,
      this.appHeight = 60,
      this.showUnderline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor ?? Colors.white,
      leadingWidth: leadingWidth,
      toolbarHeight: 74.h,
      centerTitle: centerTitle,
      bottom: PreferredSize(
        preferredSize: Size(1.sw, 1.h),
        child: showUnderline
            ? Divider(
                height: 1.h,
                color: AppColors.borderGrey,
              )
            : const SizedBox(),
      ),
      title: titleWidget ??
          Text(
            titleText ?? "",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
      leading: leadingIcon ??
          GestureDetector(
            onTap: () {
              GetIt.I.get<NavigationService>().back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 24.h,
              color: AppColors.darkBlue,
            ),
          ),
      actions: [trailing ?? const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appHeight!);
}
