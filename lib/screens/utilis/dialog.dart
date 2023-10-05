import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'asset_images.dart';
import 'colors.dart';
import 'config/app_startup.dart';
import 'navigation/navigation_service.dart';

class DialogUtil {
  static bool loading = false;
  static void showLoadingDialog(BuildContext context, {String? text}) {
    loading = true;
    showGeneralDialog(
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierDismissible: false,
        barrierColor: AppColors.black.withOpacity(.6),
        transitionDuration: const Duration(milliseconds: 100),
        context: context,
        pageBuilder: (_, __, ___) {
          return Material(
            type: MaterialType.transparency,
            color: AppColors.white,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                AssetResources.LOADING_GIF,
                fit: BoxFit.fill,
                height: 200.w,
                width: 200.w,
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim),
            child: child,
          );
        });
  }

  static void dismissLoadingDialog() {
    if (loading) {
      getIt<NavigationService>().back();
      loading = false;
    }
  }
}
