import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../utilis/config/app_configs.dart';
import '../../../utilis/network/network_request.dart';
import '../models/signup_data_model.dart';

class AuthService {
  final HttpService httpService;

  AuthService({required this.httpService});

  Future<Response> signUp(String userProfile) async {
    return await httpService.post("account/v1", data: userProfile);
  }

  Future<Response> updateProfile(UserProfileModel userProfileModel) async {
    try {
      String url = "account/v1/user/setup-profile";
      var response =
          await httpService.post(url, data: userProfileModel.encodeData());
      return response;
    } on DioError catch (e) {
      return Response(
        requestOptions: RequestOptions(path: ""),
        statusCode: 500,
        data: {
          "message": networkErrorHandler(e),
        },
      );
    }
  }

  Future<Response> resendOtp(String phoneNumber) async {
    return httpService.post(
      "account/v1/otp/send",
      data: jsonEncode(
        {
          "existingAccount": true,
          "phoneNumber": phoneNumber,
        },
      ),
    );
  }

  Future<Response> getProfile() async {
    return httpService.getRequest("account/v1/${AppURL.me}");
  }

  Future<Response> setPref(String type) async {
    return HttpService(baseUrl: AppURL.baseUrl, hasAuthorization: true).put(
        "account/v1/preference/service",
        data: jsonEncode({"serviceType": type}));
  }

  Future<Response> updatePref(Object body) async {
    return HttpService(
            baseUrl: AppURL.baseUrl + AppURL.account, hasAuthorization: true)
        .put("/v1/preference", data: body);
  }

  Future<Response> updateDriverPicture(
    File file,
  ) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      },
    );

    return HttpService(baseUrl: AppURL.baseUrl, hasAuthorization: true).post(
      "account/v1/uploads/profile-pic",
      data: formData,
    );
  }

  Future<Response> updateNin(String nin) {
    return HttpService(baseUrl: AppURL.baseUrl, hasAuthorization: true).put(
        "account/v1/kyc",
        data: jsonEncode({"kycNumber": nin, "kycType": "NIN"}));
  }

  Future<Response> regVehicle(
      String? accountUUID,
      String? color,
      String? model,
      String? operation,
      String? owner,
      String? plateNumber,
      String? primaryVehicle,
      String? vin,
      String? year) {
    return httpService.post(
      "${AppURL.baseUrl}${AppURL.vehicle}v1",
      data: jsonEncode({
        "accountUUID": accountUUID,
        "color": color,
        "model": model,
        "operation": operation,
        "owner": owner,
        "plateNumber": plateNumber,
        "primaryVehicle": primaryVehicle,
        "vin": vin,
        "year": year,
      }),
    );
  }
}
