import 'dart:convert';

class UserProfileModel {
  String? fullName;
  String? email;

  String? phone;

  UserProfileModel({
    this.email,
    this.fullName,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        "accountType": "DRIVER",
        "email": email,
        "fullName": fullName,
        "phoneNumber": phone,
        "password": "password"
      };

  String encodeData() => jsonEncode(
        toJson(),
      );
}
