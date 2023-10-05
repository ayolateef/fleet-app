import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../utilis/config/app_configs.dart';
import '../../../utilis/network/network_request.dart';

class SignInApiService {
  final HttpService http;
  SignInApiService({required this.http});

  Future<Response> loginUser(body) async {
    return http.post("account/v1/${AppURL.authenticate}", data: body);
  }

  Future<Response> getProfile() async {
    return http.getRequest("account/v1/${AppURL.me}");
  }

  Future<Response> addDeviceToken(body) async {
    return http.post("messaging/v1/register-device", data: body);
  }

  Future<Response> getUserData() async {
    return http.getRequest("");
  }

  Future<Response> sendOTP(Object body) async {
    return http.post("account/v1/otp/send", data: body);
  }

  Future<Response> verifyOtp(String otp, String phone) async {
    String url = "account/v1/otp/verify";

    final Map<String, String> body = {
      "oneTimeToken": otp,
      "phoneNumber": phone,
      "accountType": "DRIVER"
    };

    var response = await http.post(
      url,
      data: jsonEncode(body),
    );

    return response;
  }
}
