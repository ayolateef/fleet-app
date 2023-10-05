import '../../../utilis/models/base.dart';

class Login extends BaseModel {
  Login({
    this.identifier,
    this.password,
  });

  String? identifier;
  String? password;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        identifier: json["username"],
        password: json["password"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "username": identifier,
        "password": password,
      };
}
