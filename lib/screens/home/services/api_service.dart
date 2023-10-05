import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../utilis/config/app_configs.dart';
import '../../utilis/network/network_request.dart';

class ProfileApiService {
  final HttpService http;
  ProfileApiService({required this.http});

  Future<Response> updateProfile(
      String fullName, String email, String address, String dob) async {
    return http.put(
      "${AppURL.baseUrl}${AppURL.account}/v1/me",
      data: jsonEncode(
        {"fullName": fullName, "email": email, "address": address, "dob": dob},
      ),
    );
  }

  Future<Response> updateBankAccount(
      {String? bankCode,
      String? name,
      String? number,
      String? bankName,
      String? bankAccountId}) async {
    return http.put(
      "${AppURL.baseUrl}${AppURL.payment}v1/bank-accounts/$bankAccountId",
      data: jsonEncode(
        {
          "bankCode": bankCode,
          "name": name,
          "number": number,
          "bankName": bankName,
        },
      ),
    );
  }

  Future<Response> getBanks() async {
    return http.getRequest(
      "${AppURL.baseUrl}${AppURL.payment}v1/data/banks",
    );
  }

  Future<Response> deleteMyData() async {
    return http.post(
      "${AppURL.baseUrl}${AppURL.account}/v1/delete-my-data",
    );
  }

  Future<Response> uploadProfilePic() async {
    return http.post(
      "${AppURL.baseUrl}${AppURL.account}/uploads/profile-pic",
    );
  }

  Future<Response> getCards() async {
    return http.getRequest(
      "${AppURL.baseUrl}${AppURL.payment}v1/data/banks",
    );
  }

  Future<Response> deleteCard() async {
    return http.delete(
      "${AppURL.baseUrl}${AppURL.payment}v1/data/banks",
    );
  }

  Future<Response> getBankDetails(String accountNumber, String bankCode) {
    return http.getRequest(
        "${AppURL.baseUrl}${AppURL.payment}v1/data/banks/account-resolutions",
        queryParameters: {
          "account_number": accountNumber,
          "bank_code": bankCode
        });
  }

  Future<Response> addBankAccount(
      String accountNumber, String bankCode, String accountName, bankName) {
    return http.post(
      "${AppURL.baseUrl}${AppURL.payment}v1/bank-accounts",
      data: jsonEncode({
        "bankCode": bankCode,
        "name": accountName,
        "number": accountNumber,
        "bankName": bankName
      }),
    );
  }

  Future<Response> getVehicleManufacture(pageNo, pageSize) {
    return http.getRequest("${AppURL.baseUrl}${AppURL.vehicle}v1/manufacture",
        queryParameters: {"pageNo": pageNo, "pageSize": pageSize});
  }

  Future<Response> getAllVehicles(String userId) {
    return http.getRequest("${AppURL.baseUrl}${AppURL.vehicle}v1/driver",
        queryParameters: {"driver-uuid": userId});
  }

  Future<Response> getVehicleByPlateNumber(String plateNumber) {
    return http.getRequest("${AppURL.baseUrl}${AppURL.vehicle}v1/$plateNumber",
        queryParameters: {"plate-number": plateNumber});
  }

  Future<Response> getAllVehicleManufacture(name) {
    return http.getRequest(
      "${AppURL.baseUrl}${AppURL.vehicle}v1/manufacture/$name/models",
    );
  }

  Future<Response> getBankAccount() {
    return http.getRequest(
      "${AppURL.baseUrl}${AppURL.payment}v1/bank-accounts",
    );
  }

  Future<Response> getVehicleInfo(id) {
    return http.getRequest("${AppURL.baseUrl}${AppURL.vehicle}v1/driver",
        queryParameters: {"driver-uuid": id});
  }

  Future<Response> setVehicleAsPrimary(String userId, String vehicleId) {
    return http.patch("${AppURL.baseUrl}${AppURL.vehicle}v1/make-primary",
        queryParameters: {"x-auth-user": userId, "vehicle-id": vehicleId});
  }

  Future<Response> getProfilePics(String userUUID) {
    return http.getRequest("${AppURL.baseUrl}${AppURL.account}/v1/profile-pic",
        queryParameters: {"userUUID": userUUID, "user-type": 'DRIVER'});
  }

  Future<Response> uploadVehicleImage(
      {File? file,
      String? plateNumber,
      required String? documentType,
      required String documentOwner,
      required String? documentNumber,
      String? expiryDate}) async {
    var formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file!.path,
        filename: file.path.split("/").last,
        contentType: MediaType("application", "png"),
      ),
    });

    // print(formData.files);
    return HttpService(
            baseUrl: "${AppURL.baseUrl}${AppURL.vehicle}",
            isFormType: true,
            hasAuthorization: true)
        .post("v1/document", data: formData, queryParameters: {
      "document-type": documentType,
      "plate-number": plateNumber,
      "document-owner": documentOwner,
      "document-number": documentNumber,
      "expiry-date": expiryDate
    });
  }

  Future<Response> addVehicleInfo(Object body) {
    return http.post("${AppURL.baseUrl}${AppURL.vehicle}v1", data: body);
  }

  Future<Response> getReferralCode() {
    return http.getRequest(
      "${AppURL.baseUrl}${AppURL.request}v1/referrals/me",
    );
  }

  Future<Response> getReferralPerformance() {
    return http.getRequest(
      "${AppURL.baseUrl}${AppURL.request}v1/referrals/me/performance",
    );
  }

  Future<Response> withdrawReferralBonus() {
    return http.post(
      "${AppURL.baseUrl}${AppURL.request}v1/promotions/bonus",
    );
  }

  Future<Response> redeemReferralCode(String code) {
    return http.post(
      "${AppURL.baseUrl}${AppURL.request}v1/promotions/$code/redeem",
    );
  }

  Future<Response> refreshToken(String refreshToken) async {
    return HttpService(
            baseUrl: "${AppURL.baseUrl}${AppURL.account}/v1/",
            hasAuthorization: false)
        .post("token-refresh",
            data: jsonEncode({"refreshToken": refreshToken}));
  }
}

enum DocumentType {
  DRIVERS_LICENSE,
  CAR_REGISTRATION,
  VIO_CERTIFICATE,
  INSPECTION_REPORT,
  CUSTOM_DUTY,
  TINT_PERMIT,
  CAR_IMAGE
}
