import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_fleet/screens/utilis/network/network_request.dart';

import '../../../../utilis/string.dart';
import '../../models/signup_data_model.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit({required this.authService}) : super(AuthIdleState());
  late UserProfileModel userProfileModel;

  void setUserProfile(UserProfileModel value) {
    userProfileModel = value;
  }

  Future<void> signUp(UserProfileModel userProfileModel) async {
    try {
      emit(AuthLoadingState());

      var response = await authService.signUp(userProfileModel.encodeData());

      if (response.isSuccessful) {
        emit(
          AuthSuccessState(),
        );
      } else {
        emit(AuthErrorState(
          errorMessage: response.data['message'],
        ));
      }
    } on DioError catch (e) {
      emit(AuthErrorState(
        errorMessage: networkErrorHandler(e),
      ));
    }
  }

  Future<void> updateProfile(String password) async {
    try {
      emit(AuthLoadingState());

      Response response = await authService.updateProfile(userProfileModel);
      if (response.isSuccessful) {
        emit(
          AuthSuccessState(),
        );
      } else {
        emit(
          AuthErrorState(
            errorMessage: StringResources.AN_ERROR_OCCURED,
          ),
        );
      }
    } on DioError catch (e) {
      AuthErrorState(
        errorMessage: networkErrorHandler(e),
      );
    }
  }

  Future<bool> resendOtp(String phone) async {
    Response response = await authService.resendOtp(phone);
    if (response.isSuccessful) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> regNewVehicle(
      String? accountUUID,
      String? color,
      String? model,
      String? operation,
      String? owner,
      String? plateNumber,
      String? primaryVehicle,
      String? vin,
      String? year) async {
    emit(VehicleRegLoading());

    try {
      var res = await authService.regVehicle(accountUUID, color, model,
          operation, owner, plateNumber, primaryVehicle, vin, year);
      if (res.isSuccessful) {
        emit(VehicleRegSuccess());
      } else {
        emit(VehicleRegError(errorMessage: res.data));
      }
    } catch (e) {
      emit(VehicleRegError(errorMessage: e.toString()));
    }
  }
}
