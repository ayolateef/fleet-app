import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_fleet/screens/route/route.dart';

import '../../utilis/asset_images.dart';
import '../../utilis/button.dart';
import '../../utilis/colors.dart';
import '../../utilis/config/app_startup.dart';
import '../../utilis/custom_text_field.dart';
import '../../utilis/dialog.dart';
import '../../utilis/messenger.dart';
import '../../utilis/navigation/navigation_service.dart';
import '../../utilis/string.dart';
import '../../utilis/validator.dart';
import '../route/routes.dart';
import '../sign_in/widget/otp_page.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/auth/auth_state.dart';
import 'models/signup_data_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedCountryCode = "234";
  bool obscurePassword = true;
  String? phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: Column(
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
                padding: EdgeInsets.only(
                  left: 32.w,
                  right: 32.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringResources.BECOME_A_FLEET_MANAGER,
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
                      StringResources.SIGN_UP_TO_JOIN,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    CustomTextField(
                      textEditingController: firstNameController,
                      header: StringResources.ENTER_FIRST_NAME,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringResources.ENTER_FIRST_NAME;
                        } else if (value.length < 2) {
                          return "Enter at least two letters for the first name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      textEditingController: lastNameController,
                      header: StringResources.ENTER_LAST_NAME,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringResources.ENTER_LAST_NAME;
                        } else if (value.split('').length < 2) {
                          return "Enter at least two letters for the last name";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      textEditingController: phoneNumberController,
                      textInputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11)
                      ],
                      header: "0700 0000 000",
                      validator: Validator.validateMobile,
                      prefix: SizedBox(
                        width: 150.w,
                        child: CountryCodePicker(
                          onChanged: (value) {
                            selectedCountryCode = value.code!;
                          },
                          enabled: false,
                          initialSelection: 'NG',
                          favorite: const ['+234', 'NG'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: true,
                          showFlag: true,
                        ),
                      ),
                      type: FieldType.phone,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      textEditingController: emailController,
                      header: StringResources.ENTER_EMAIL,
                      validator: Validator.validateEmail,
                      type: FieldType.email,
                    ),
                    SizedBox(
                      height: 65.h,
                    ),
                    BlocListener(
                      bloc: getIt<AuthCubit>(),
                      listener: ((context, state) {
                        if (state is AuthLoadingState) {
                          DialogUtil.showLoadingDialog(context);
                        }

                        if (state is AuthSuccessState) {
                          DialogUtil.dismissLoadingDialog();
                          getIt<NavigationService>().toWithParameters(
                              routeName: AuthRoutes.otp,
                              args: {
                                "phone": formatPhoneNumber(
                                    phoneNumberController.text),
                                'email': emailController.text.trim(),
                                "type": LinkFrom.signup
                              });
                        }

                        if (state is AuthErrorState) {
                          DialogUtil.dismissLoadingDialog();
                          NotificationMessage.showError(context,
                              message: state.errorMessage);
                        }
                      }),
                      child: AppButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            UserProfileModel userProfileModel =
                                UserProfileModel(
                              phone:
                                  formatPhoneNumber(phoneNumberController.text),
                              email: emailController.text,
                              fullName:
                                  ("${firstNameController.text} ${lastNameController.text}"),
                            );
                            getIt<AuthCubit>().signUp(userProfileModel);
                          }
                        },
                        radius: 56.r,
                        text: StringResources.CONTINUE,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        getIt<NavigationService>()
                            .to(routeName: RootRoutes.signIn);
                      },
                      child: Center(
                        child: Text(
                          StringResources.ALREADY_HAVE_ACCOUNT,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("0")) {
      return "$selectedCountryCode${phoneNumber.substring(1)}";
    } else {
      return "$selectedCountryCode$phoneNumber";
    }
  }
}
