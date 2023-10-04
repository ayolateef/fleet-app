import 'app_startup.dart';

class AppConfig {
  // ignore: constant_identifier_names
  static const String MAPAPIKEY = "AIzaSyAxiW1_orIPWXwL4qYCwaXXaE5qS3eFnfs";
  static const int resendOtpTime = 120;
  static const AgoraAppId = "05f499ebf6ed473ea27fedd0912973fa";
  static const FIREBASEKEY =
      "AAAANTCdMkw:APA91bEy7TM52-vA8JE8gRiFX0wjWBoZLNITBWEUqVH5GcSuH3jKJQ74DZVxgdRa3UkTVg4ZX7f1D1Vqf28UxCeI6qDfPRRNH_Z232gsdg8GN7ycnl0CVE_NmsNsyK5UdbzXqsTt0Hlg";
}

class AppURL {
  static const String deviceToken = "add-device-token";
  static const String removeDeviceToken = "remove-device-token";
  static const String baseUrl = String.fromEnvironment("baseUrl",
      defaultValue: "https://dev-api.gocaby.com/");
  static const String auth = "auth/";
  static const String login = "login";
  static const String authenticate = "authenticate";
  static const String me = "me";
  static const String account = "account";
  static const String request = "request/";
  static const String preference = "preference";
  static const String payment = "payment/";
  static const String vehicle = "vehicle/";
  static const String trip = "trip/";
  static const String earning = "earning/";
  static const String messaging = "messaging/";
  static const String basePaymentUrl = '$baseUrl/payment/v1/';
  static const String googleMapUrl = "https://www.google.com/maps/dir/?api=1&";
}

class AppConstants {
  static const String addressObject = "addressObject";
  static const String deviceTokenAdded = "deviceTokenAdded";
  static const String isUserFirstTime = "isUserFirstTime";
  static const String userObject = "userObject";
  static const String walletObject = "walletObject";
  static const String userToken = "userToken";
  static const String refreshToken = "refreshToken";
  static late Environment environment;
  static String requests =
      AppURL.baseUrl.contains("dev-api") ? "requests_dev" : "requests";
  static const String drivers = "drivers";
  static const String appIDIOS = "1668681299";
  static const String appPackageAndroid = "";
  static const String currentRequest = "currentRequest";
  static const String anErrorOccurred = "An Error Occurred";
  static const double lagosNorth = 6.697265;
  static const double lagosSouth = 6.371339;
  static const double lagosEast = 4.350063;
  static const double lagosWest = 2.701359;

  // Abuja bounding box
  static const double abujaNorth = 9.1881;
  static const double abujaSouth = 8.77083;
  static const double abujaEast = 7.6934;
  static const double abujaWest = 6.7804;

  static const String appsFlyerId = "nfL6dWYWAz7EcuESK2RdqM";
  static const String androidPackageId = "com.gocaby.driverapp";
}
