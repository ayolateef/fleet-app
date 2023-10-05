import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../route/route.dart';
import '../../../utilis/asset_images.dart';
import '../../../utilis/button.dart';
import '../../../utilis/colors.dart';
import '../../../utilis/config/app_startup.dart';
import '../../../utilis/dialog.dart';
import '../../../utilis/messenger.dart';
import '../../../utilis/models/user.dart';
import '../../../utilis/navigation/navigation_service.dart';
import '../../signup/cubits/auth/auth_cubit.dart';
import '../cubit/sign_in_cubit.dart';

enum LinkFrom { login, signup }

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final LinkFrom linkFrom;
  final String? email;
  const OtpPage(
      {Key? key, required this.phoneNumber, required this.linkFrom, this.email})
      : super(key: key);

  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController newPasswordController = TextEditingController();
  final _codeController = TextEditingController();
  final defaultPinTheme = PinTheme(
    textStyle: GoogleFonts.poppins(
        fontSize: 18, color: AppColors.darkBlue, fontWeight: FontWeight.w700),
    width: 60,
    height: 60,
    decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        shape: BoxShape.circle),
  );
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        bloc: getIt<SignInCubit>(),
        listener: (context, state) {
          if (state is VerifyOtpLoading) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is VerifyOtpError) {
            DialogUtil.dismissLoadingDialog();
            NotificationMessage.showError(context, message: state.errorMessage);
          } else if (state is GetProfileError) {
            DialogUtil.dismissLoadingDialog();
            NotificationMessage.showError(context, message: state.message);
          } else if (state is VerifyOtpSuccess) {
            DialogUtil.dismissLoadingDialog();

            if (widget.linkFrom == LinkFrom.signup) {
              getIt<NavigationService>().clearAllTo(routeName: RootRoutes.home);
              return;
            } else {
              getIt<NavigationService>().clearAllTo(routeName: RootRoutes.home);
            }
          }
          //}
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 1.sw,
                height: 250.h,
                margin: EdgeInsets.only(right: 20.w),
                child: SvgPicture.asset(
                  AssetResources.TOP_BANNER,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter OTP",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "OTP has been sent to\nyour email ${widget.email} \nand phone number ${widget.phoneNumber}.",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 17.sp,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 111.h,
                        ),
                        Center(
                          child: Pinput(
                            length: 6,
                            followingPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                  shape: BoxShape.circle),
                            ),
                            disabledPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                  shape: BoxShape.circle),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                  shape: BoxShape.circle),
                            ),
                            defaultPinTheme: defaultPinTheme,
                            onCompleted: (v) {
                              getIt<SignInCubit>().verifyOtp(
                                _codeController.text,
                                widget.phoneNumber,
                              );
                            },
                            controller: _codeController,
                          ),
                        ),
                        SizedBox(
                          height: 83.h,
                        ),
                        AppButton(
                          onPressed: () {
                            // confirm otp
                            getIt<SignInCubit>().verifyOtp(
                                _codeController.text, widget.phoneNumber);
                          },
                          radius: 56.r,
                          text: "Confirm OTP",
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              resendOtp();
                            },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  resendOtp() {
    getIt.get<AuthCubit>().resendOtp(widget.phoneNumber);
  }
}
