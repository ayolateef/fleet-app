import '../../../utilis/models/base.dart';

class LoginResponseModel extends BaseModel {
  LoginResponseModel({
    this.email,
    this.phoneNumber,
  });

  String? email;
  String? phoneNumber;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        email: json["email"],
        phoneNumber: json["phoneNumber"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "email": email,
        "phoneNumber": phoneNumber,
      };
}
