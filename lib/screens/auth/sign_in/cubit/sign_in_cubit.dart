import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_fleet/screens/utilis/network/network_request.dart';
import '../../../utilis/config/app_configs.dart';
import '../../../utilis/config/app_startup.dart';
import '../../../utilis/storage.dart';
import '../model/login_response.dart';
import '../model/user.dart';
import '../service/api_service.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInApiService apiService;
  SignInCubit({required this.apiService}) : super(SignInInitial());

  Future<User?> getProfile({required bool isLogin}) async {
    emit(GetProfileLoading());
    try {
      var res = await apiService.getProfile();
      if (res.isSuccessful) {
        User userProfile = User.fromJson(res.body);

        if (userProfile.accountType!.toLowerCase() != "driver") {
          emit(GetProfileError(
              message:
                  "We detected this your account as a user, please download the GoApp to continue"));

          return null;
        }

        LocalStorageUtils.saveObject<User>(
            AppConstants.userObject, userProfile);
        getIt.registerSingleton<User>(userProfile);

        Future.delayed(const Duration(seconds: 1), () {});
        // only call the add device token api if the method call is from login page
        if (isLogin) {
          //addDeviceToken(userProfile.userId!);
        }
        emit(GetProfileSuccess(user: userProfile));
        return userProfile;
      } else {
        emit(GetProfileError(message: "An Error Occurred"));
      }
    } catch (ex) {
      if (ex is DioError) {
        var errorMessage = networkErrorHandler(ex);

        emit(GetProfileError(message: errorMessage));
      } else {
        emit(GetProfileError(message: "An Error Occurred"));
      }
    }
    return null;
  }

  Future<void> verifyOtp(String otp, String phone) async {
    try {
      emit(VerifyOtpLoading());

      Response response = await apiService.verifyOtp(otp, phone);
      if (response.isSuccessful) {
        String token = response.data['token'];
        String refreshToken = response.data['refreshToken'];

        await UserTokenManager.insertAccessToken(token);
        await UserTokenManager.insertRefreshToken(refreshToken);

        User? user = await getProfile(isLogin: true);
        if (user == null) {
          emit(VerifyOtpError(errorMessage: "An error occured"));
        } else if (user.accountType!.toLowerCase() != "driver") {
          emit(VerifyOtpError(
              errorMessage:
                  "We detected this your account as a user, please download the GoApp to continue"));
        } else {
          emit(VerifyOtpSuccess());
        }
      } else {
        emit(VerifyOtpError(errorMessage: "An error occured"));
      }
    } catch (e) {
      if (e is DioError) {
        emit(
          VerifyOtpError(errorMessage: networkErrorHandler(e)),
        );
      } else {
        emit(VerifyOtpError(errorMessage: "An error occured"));
      }
    }
  }

  // void activateWallet() async {
  //   emit(ActivateWalletLoading());
  //   try {
  //     var res = await apiService.activateWallet();
  //     if (res.isSuccessful) {
  //       emit(ActivateWalletSuccess());
  //     }
  //   } catch (ex) {
  //     if (ex is DioError) {
  //       var errorMessage = networkErrorHandler(ex);
  //       emit(ActivateWalletError(message: errorMessage));
  //     } else {
  //       emit(ActivateWalletError(message: AppConstants.anErrorOccurred));
  //     }
  //   }
  // }

  // Future<void> addDeviceToken(String userId) async {
  //   String token = (await FirebaseNotificationManager().deviceToken)!;
  //
  //   try {
  //     var body = {
  //       "deviceToken": token,
  //       "userId": userId,
  //       "deviceModel": Platform.isAndroid ? "Android" : "iOS"
  //     };
  //
  //     var res = await apiService.addDeviceToken(body);
  //
  //     if (res.isSuccessful) {
  //       // Add to local storage that device token has been map to user.
  //       LocalStorageUtils.write(AppConstants.deviceTokenAdded, "true");
  //     }
  //   } on DioError catch (ex) {
  //     String errorMessage;
  //     errorMessage = networkErrorHandler(ex);
  //     emit(SubmitUserLoginWithError(message: errorMessage));
  //   }
  // }

  void sendOTP(phone, existingAccount) async {
    emit(SendOtpLoading());
    var body = {"existingAccount": existingAccount, "phoneNumber": phone};
    try {
      var res = await apiService.sendOTP(body);

      if (res.isSuccessful) {
        LoginResponseModel loginResponseModel =
            LoginResponseModel.fromJson(res.data);
        emit(SendOtpSuccess(loginResponseModel: loginResponseModel));
      } else {
        emit(SendOtpError(message: "An error occurred"));
      }
    } catch (ex) {
      if (ex is DioError) {
        var errorMessage = networkErrorHandler(ex);

        emit(SendOtpError(message: errorMessage));
      } else {
        emit(SendOtpError(message: "An error occurred"));
      }
    }
  }
}
