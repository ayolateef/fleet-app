import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'asset_images.dart';
import 'button.dart';
import 'colors.dart';
import 'config/app_startup.dart';
import 'custom_styles.dart';
import 'navigation/navigation_service.dart';

class NotificationMessage {
  static showError(BuildContext context, {required String message}) {
    _showMessage(context, message: message, isError: true, title: "Error");
  }

  static showSuccess(BuildContext context, {required String message}) {
    _showMessage(context, message: message, isError: false, title: "Success");
  }

  static successDialog(
      {context, text, VoidCallback? onClose, String? btnText}) {
    appSuccessDialog(
        height: 350.h,
        content: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 35.h),
              SvgPicture.asset(AssetResources.SUCCESS),
              SizedBox(height: 15.h),

              // Your personal details has been successfully updated
              Text("Success",
                  style: AppStyles.largeText
                      .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w900)),
              SizedBox(height: 10.h),

              Text(text,
                  textAlign: TextAlign.center,
                  style: AppStyles.smallText.copyWith(
                    fontSize: 12.sp,
                    // fontWeight: FontWeight.w400
                  )),
              SizedBox(height: 35.h),
              AppButton(
                color: AppColors.darkBlue,
                text: btnText ?? "Close",
                onPressed: onClose,
              ),
            ],
          ),
        ),
        context: context);
  }

  static comingSoonDialog(context) {
    appSuccessDialog(
        height: 350.h,
        content: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 35.h,
              ),
              Icon(
                Icons.info_outline,
                size: 65.sp,
                color: AppColors.darkBlue,
              ),

              SizedBox(height: 15.h),
              Text("Feature coming soon",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 10.h),
              Text("Please check back later",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400)),
              SizedBox(height: 35.h),
              AppButton(
                text: 'Okay',
                onPressed: () {
                  getIt<NavigationService>().back();
                },
              ),
              // modalButton(
              //   buttonText: 'Okay',
              //   buttonType: ModalButtonType.solid,
              //   onPressed: () {
              //     locator<NavigationService>().pop();
              //   },
              // ),
            ],
          ),
        ),
        context: context);
  }

  static showNeutralMessage(BuildContext context,
      {required String message, required String title, Function? undo}) {
    _showMessage(context,
        message: message, isError: null, title: title, undo: undo);
  }

  static Future _showMessage(BuildContext context,
      {required String message,
      required bool? isError,
      required String title,
      Function? undo}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.h,
        left: 16.w,
        child: _Messenger(
          message: message,
          isErrorMessage: isError,
          title: title,
          undo: undo,
        ),
      ),
    );
    overlayState.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 3));
    overlayEntry.remove();
  }
}

class _Messenger extends StatefulWidget {
  final String message;
  final bool? isErrorMessage;
  final String title;
  final Function? undo;
  const _Messenger(
      {required this.message,
      required this.isErrorMessage,
      required this.title,
      this.undo});

  @override
  State<_Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<_Messenger>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..animateTo(1.5);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(1.5, 0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: 343.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          height: 60.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.toastBorderColor,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.white),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: widget.isErrorMessage == null
                          ? AppColors.grey[35]
                          : widget.isErrorMessage!
                              ? AppColors.cabyRed
                              : AppColors.green,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Text(
                    widget.message,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: widget.isErrorMessage == null
                          ? AppColors.grey[35]
                          : widget.isErrorMessage!
                              ? AppColors.cabyRed
                              : AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

appSuccessDialog({
  required BuildContext context,
  required double height,
  Color? color,
  // required String title,
  // required String subtitle,
  double? width,
  bool hasClip = false,
  required Widget content,
}) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25.w),
          height: height,
          width: width ?? 315.w,
          padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: [
              content,
            ],
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
    },
  );
}
