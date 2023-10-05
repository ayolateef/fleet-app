import 'package:enum_to_string/enum_to_string.dart';

import '../../../utilis/models/base.dart';

class Preference extends BaseModel {
  String? homeLocationCord;
  String? workLocationCord;
  String? homeLocationName;
  String? workLocationName;
  ServiceTypes? serviceType;

  Preference(
      {this.homeLocationCord,
      this.workLocationCord,
      this.homeLocationName,
      this.workLocationName,
      this.serviceType});

  Preference.fromJson(Map<String, dynamic> json) {
    homeLocationCord = json['homeLocationCord'];
    workLocationCord = json['workLocationCord'];
    homeLocationName = json['homeLocationName'];
    workLocationName = json['workLocationName'];

    if (json['serviceType'] != null) {
      serviceType = ServiceTypes.values.firstWhere(
          (element) => element.name == json['serviceType'],
          orElse: () => ServiceTypes.RIDE);
    } else {
      serviceType = null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['homeLocationCord'] = homeLocationCord;
    data['workLocationCord'] = workLocationCord;
    data['homeLocationName'] = homeLocationName;
    data['workLocationName'] = workLocationName;
    data['serviceType'] =
        serviceType == null ? null : EnumToString.convertToString(serviceType);
    return data;
  }
}

class User extends BaseModel {
  String? phoneNumber;
  String? email;
  String? fullName;
  String? address;
  String? accountType;
  String? dataRegistered;
  String? userId;
  Preference? preference;
  Setup? setup;
  num? rating;
  String? lastLoggedIn;
  String? profilePic;

  User(
      {this.phoneNumber,
      this.email,
      this.fullName,
      this.address,
      this.accountType,
      this.dataRegistered,
      this.userId,
      this.preference,
      this.setup,
      this.rating,
      this.profilePic,
      this.lastLoggedIn});

  User.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    fullName = json['fullName'];
    address = json['address'];
    profilePic = json["profilePicUrl"];
    accountType = json['accountType'];
    dataRegistered = json['dataRegistered'];
    userId = json['userId'];

    preference = json['preference'] != null
        ? Preference.fromJson(json['preference'])
        : null;
    setup = json['setup'] != null ? Setup.fromJson(json['setup']) : null;
    rating = json['rating'];
    lastLoggedIn = json['lastLoggedIn'];
  }

  get hasUploadDocument => null;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['fullName'] = fullName;
    data['address'] = address;
    data['accountType'] = accountType;
    data['dataRegistered'] = dataRegistered;
    data['userId'] = userId;
    data['profilePicUrl'] = profilePic;

    if (preference != null) {
      data['preference'] = preference?.toJson();
    }
    if (setup != null) {
      data['setup'] = setup!.toJson();
    }
    data['rating'] = rating;
    data['lastLoggedIn'] = lastLoggedIn;
    return data;
  }
}

class Setup {
  bool? hasVehicleSetup;
  bool? hasKyc;
  bool? verified;
  bool? hasDrivingLicense;
  bool? hasWalletSetup;
  bool? hasCarImageUploaded;

  Setup(
      {this.hasVehicleSetup,
      this.hasKyc,
      this.verified,
      this.hasWalletSetup,
      this.hasDrivingLicense,
      this.hasCarImageUploaded});

  Setup.fromJson(Map<String, dynamic> json) {
    hasVehicleSetup = json['hasVehicleSetup'];
    hasKyc = json['hasKyc'];
    hasWalletSetup = json['hasWalletSetup'];
    hasDrivingLicense = json['hasDrivingLicense'];
    hasCarImageUploaded = json['hasCarImageUploaded'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasVehicleSetup'] = hasVehicleSetup;
    data['hasWalletSetup'] = hasWalletSetup;
    data['hasKyc'] = hasKyc;
    data['hasCarImageUploaded'] = hasCarImageUploaded;
    data['verified'] = verified;

    data['hasDrivingLicense'] = hasDrivingLicense;
    return data;
  }
}

enum ServiceTypes { RIDE, DELIVERY, TOWING, RIDE_DELIVERY }
