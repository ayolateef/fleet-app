import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'asset_images.dart';
import 'colors.dart';

enum ButtonType { primary }

class AppButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final ButtonType buttonType;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final Color? color;
  final Color? borderColor;
  final double? verticalPadding;
  final TextStyle? textStyle;
  final double? radius;
  final double? width;
  final double? height;
  final bool? disabled;
  const AppButton(
      {Key? key,
      this.child,
      this.radius,
      this.color,
      this.text,
      this.borderColor,
      this.buttonType = ButtonType.primary,
      this.onPressed,
      this.isLoading,
      this.verticalPadding,
      this.width,
      this.height,
      this.textStyle,
      this.disabled})
      : assert(text != null || child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55.h,
      width: width ?? 395.w,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            FocusScope.of(context).unfocus();
            onPressed!();
          }
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((states) => 0),
          padding: MaterialStateProperty.resolveWith<EdgeInsets>(
            (states) => EdgeInsets.symmetric(vertical: verticalPadding ?? 12.h),
          ),
          fixedSize: MaterialStateProperty.resolveWith<Size>(
            (states) => Size(334.w, 57.h),
          ),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor ?? color ?? Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(radius ?? 8.r),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled) ||
                  onPressed == null) {
                return color?.withOpacity(0.5) ??
                    AppColors.primaryColor.withOpacity(0.5);
              }
              return color ?? AppColors.primaryColor;
              // Use the component's default.
            },
          ),
        ),
        child: (isLoading ?? false)
            ? _loadingWidget()
            : child ??
                Text(
                  text!,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        color: Colors.white,
                      ),
                ),
      ),
    );
  }
}

Widget _loadingWidget() => Center(
      child: Image.asset(
        AssetResources.LOADING_GIF,
        fit: BoxFit.fill,
        height: 200.w,
        width: 200.w,
      ),
    );
