import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_fleet/screens/auth/sign_in/widget/otp_page.dart';
import 'package:go_fleet/screens/utilis/asset_images.dart';
import 'package:go_fleet/screens/utilis/button.dart';
import 'package:go_fleet/screens/utilis/colors.dart';
import 'package:go_fleet/screens/utilis/config/app_configs.dart';
import 'package:go_fleet/screens/utilis/config/app_startup.dart';
import 'package:go_fleet/screens/utilis/custom_text_field.dart';
import 'package:go_fleet/screens/utilis/navigation/navigation_service.dart';
import 'package:go_fleet/screens/utilis/storage.dart';
import 'package:go_fleet/screens/utilis/string.dart';
import 'package:go_fleet/screens/utilis/validator.dart';

import '../../utilis/dialog.dart';
import '../../utilis/messenger.dart';
import '../route/routes.dart';
import 'cubit/sign_in_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    LocalStorageUtils.write(AppConstants.isUserFirstTime, "true");
  }

  String selectedCountryCode = "234";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
          bloc: getIt.get<SignInCubit>(),
          listener: (context, state) {
            if (state is SendOtpSuccess) {
              DialogUtil.dismissLoadingDialog();
              getIt<NavigationService>().toWithParameters(
                routeName: AuthRoutes.otp,
                args: {
                  "phone": formatPhoneNumber(phoneController.text.trim()),
                  "type": LinkFrom.login,
                  "email": state.loginResponseModel.email
                },
              );
            }

            if (state is SendOtpError) {
              DialogUtil.dismissLoadingDialog();
              NotificationMessage.showError(context, message: state.message);
            }

            if (state is SendOtpLoading) {
              DialogUtil.showLoadingDialog(context);
            }
          },
          builder: (BuildContext context, Object? state) {
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
                              StringResources.WELCOME_BACK,
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
                              StringResources.SEE_YOUR_FLEET,
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 111.h,
                            ),
                            CustomTextField(
                              textEditingController: phoneController,
                              header: "700 0000 000",
                              validator: Validator.validateMobile,
                              textInputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11)
                              ],
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            SizedBox(
                              height: 83.h,
                            ),
                            AppButton(
                              onPressed: () {
                                signInPressed();
                              },
                              radius: 56.r,
                              text: StringResources.SIGN_IN,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              height: 52.h,
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  getIt<NavigationService>()
                                      .to(routeName: AuthRoutes.signUp);
                                },
                                child: Text(
                                  StringResources.BECOME_A_FLEET_MANAGER,
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]);
          }),
    );
  }

  formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("0")) {
      return "$selectedCountryCode${phoneNumber.substring(1)}";
    } else {
      return "$selectedCountryCode$phoneNumber";
    }
  }

  signInPressed() {
    if (_formKey.currentState!.validate()) {
      getIt<SignInCubit>().sendOTP(
        formatPhoneNumber(phoneController.text.trim()),
        true,
      );
    }
  }
}
