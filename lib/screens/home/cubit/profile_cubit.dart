import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_fleet/screens/home/cubit/profile_state.dart';
import 'package:go_fleet/screens/utilis/network/network_request.dart';

import '../../auth/sign_in/model/user.dart';
import '../../utilis/config/app_startup.dart';
import '../../utilis/storage.dart';
import '../model/vehicle_info_model.dart';
import '../model/vehicle_model.dart';
import '../model/vehicle_type_model.dart';
import '../services/api_service.dart';
import '../widget/vehicle_infomation.dart';
import '../widget/vehicle_plate.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileApiService apiService;
  ProfileCubit({required this.apiService}) : super(UpdateInitialState());

  Future<void> updateProfile(
      {String? fullName, String? email, String? address, String? dob}) async {
    emit(UpdateProfileLoading());
    try {
      User user = getIt<User>();
      if (fullName != null) user.fullName = fullName;
      if (email != null) user.email = email;
      if (address != null) user.address = address;

      getIt.registerSingleton<User>(user);

      Response response =
          await apiService.updateProfile(fullName!, email!, address!, dob!);

      if (response.isSuccessful) {
        emit(UpdateProfileSuccess(message: "Profile Updated Successfully"));
      } else {
        emit(UpdateProfileError(message: "An error occurred"));
      }
    } on DioError catch (e) {
      emit(UpdateProfileError(message: networkErrorHandler(e)));
    }
  }

  Future<void> getVehicleManufacture({pageNo, pageSize}) async {
    emit(ManufactureVehicleLoading());
    try {
      var response = await apiService.getVehicleManufacture(pageNo, pageSize);

      if (response.isSuccessful) {
        List<CarsModel> cars = [];

        for (var element in (response.data as List)) {
          cars.add(CarsModel(element));
        }

        emit(ManufactureVehicleSuccess(vehicleManufacture: cars));
      } else {
        emit(ManufactureVehicleError(message: "An error occurred"));
      }
    } on DioError catch (e) {
      emit(ManufactureVehicleError(message: networkErrorHandler(e)));
    }
  }

  Future<void> getVehicleByPlateNumber(plateNumber) async {
    emit(DriverVehicleLoading());
    try {
      var response = await apiService.getVehicleByPlateNumber(plateNumber);

      if (response.isSuccessful) {
        var vehicleModel = VehicleModel.fromJson(response.data);

        emit(DriverVehicleSuccess(vehicleModel: vehicleModel));
      } else {
        emit(DriverVehicleError(message: "An error occurred"));
      }
    } catch (e) {
      if (e is DioError) {
        emit(DriverVehicleError(message: networkErrorHandler(e)));
      } else {
        emit(DriverVehicleError(message: "An error occurred"));
      }
    }
  }

  Future<void> getAllVehicleManufacture({name}) async {
    emit(AllManufactureVehicleLoading());
    try {
      var response = await apiService.getAllVehicleManufacture(name);
      if (response.isSuccessful) {
        var list = response.data as Iterable;
        List<VehicleTypeModel> vehicleType =
            list.map((e) => VehicleTypeModel.fromJson(e)).toList();

        emit(AllManufactureVehicleSuccess(allVehicleManufacture: vehicleType));
      } else {
        emit(AllManufactureVehicleError(message: "An error occurred"));
      }
    } on DioError catch (e) {
      emit(AllManufactureVehicleError(message: networkErrorHandler(e)));
    }
  }

  Future<VehicleModel?> getAllVehicles() async {
    emit(GetVehiclesLoading());
    try {
      var user = getIt<User>();
      var response = await apiService.getAllVehicles(user.userId!);

      if (response.isSuccessful) {
        var vehicleData = response.data as Iterable;

        List<VehicleModel> vehicles =
            vehicleData.map((e) => VehicleModel.fromJson(e)).toList();
        VehicleModel? vehicle;

        if (vehicles.isNotEmpty &&
            vehicles.where((element) => element.primaryVehicle).isNotEmpty) {
          vehicle = vehicles.firstWhere((element) => element.primaryVehicle);
          getIt.registerSingleton<VehicleModel>(vehicle);
        }
        if (getIt.isRegistered<List<VehicleModel>>()) {
          getIt.unregister<List<VehicleModel>>();
          getIt.unregister<VehicleModel>();
        }

        getIt.registerSingleton<List<VehicleModel>>(vehicles);

        emit(GetVehiclesSuccess(vehicles: vehicles));
        return vehicle;
      } else {
        emit(GetVehiclesError(message: "An error occurred"));
        return null;
      }
    } on DioError catch (e) {
      emit(
        GetVehiclesError(
          message: networkErrorHandler(e),
        ),
      );
      return null;
    }
  }

  Future<void> getVehicleInfo(id) async {
    emit(VehicleBrandLoading());
    try {
      var response = await apiService.getVehicleInfo(id);

      if (response.isSuccessful) {
        return response.data;
      } else {
        emit(VehicleBrandError(message: " error"));
      }
    } on DioError catch (e) {
      emit(VehicleBrandError(message: networkErrorHandler(e)));
    }
  }

  Future<void> addVehicleInfo(AddVehicleInfo addVehicleInfo) async {
    emit(AddVehicleInfoLoading());

    try {
      Response response =
          await apiService.addVehicleInfo(addVehicleInfo.toJson());

      if (response.isSuccessful) {
        AddVehicleInfo.fromJson(response.data);
        emit(AddVehicleInfoSuccess());
      } else {
        emit(AddVehicleInfoError(message: "An error occurred"));
      }
    } on DioError catch (e) {
      emit(AddVehicleInfoError(message: networkErrorHandler(e)));
    }
  }

  Future<void> uploadVehicle(
      {required List<ImageToSend?> image,
      String? plateNumber,
      required String documentType,
      required String documentOwner,
      // String? documentNumber,
      String? expiryDate}) async {
    emit(UploadVehicleLoading());

    try {
      Response? response;
      for (var imageToSend in image) {
        final File file = File(imageToSend!.file!.path);
        final String type = imageToSend.type!;
        response = await apiService.uploadVehicleImage(
            file: file,
            plateNumber: plateNumber,
            documentOwner: documentOwner,
            documentType: documentType,
            documentNumber: type,
            expiryDate: expiryDate);
      }

      if (response!.isSuccessful) {
        User? user = getIt<User>();
        user.setup?.hasCarImageUploaded = true;
        emit(UploadVehicleSuccess());
      } else {
        emit(UploadVehicleError(message: "An error occurred"));
      }
    } on DioError catch (e) {
      emit(UploadVehicleError(message: networkErrorHandler(e)));
    }
  }

  Future<void> setVehicleAsPrimary(String vehicleId) async {
    emit(SetVehicleAsPrimaryLoading());
    try {
      User user = getIt<User>();
      Response response =
          await apiService.setVehicleAsPrimary(user.userId!, vehicleId);

      if (response.isSuccessful) {
        emit(SetVehiclePrimarySuccess(vehicleId: vehicleId));
      } else {
        emit(SetVehicleAsPrimaryError(message: "An error occurred"));
      }
    } on Exception catch (e) {
      if (e is DioError) {
        emit(SetVehicleAsPrimaryError(message: networkErrorHandler(e)));
      } else {
        emit(SetVehicleAsPrimaryError(message: "An error occurred"));
      }
    }
  }

  Future<void> getProfilePic(String userUUID) async {
    emit(GetProfilePicsLoading());
    try {
      User user = getIt<User>();
      Response response = await apiService.getProfilePics(userUUID);

      if (response.isSuccessful) {
        emit(GetProfilePicsSuccess());
      } else {
        emit(GetProfilePicsLoading());
      }
    } on Exception catch (e) {
      if (e is DioError) {
        emit(GetProfilePicsLoading());
      } else {
        emit(GetProfilePicsLoading());
      }
    }
  }

  Future<String?> refreshToken() async {
    try {
      String? refreshToken = await UserTokenManager.getRefreshToken();
      var res = await apiService.refreshToken(refreshToken!);

      if (res.isSuccessful) {
        UserTokenManager.insertAccessToken(res.data["token"]);

        UserTokenManager.insertRefreshToken(res.data["refreshToken"]);
        return res.data["token"];
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }
}
