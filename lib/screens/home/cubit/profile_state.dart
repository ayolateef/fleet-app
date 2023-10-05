import '../model/vehicle_model.dart';
import '../model/vehicle_type_model.dart';
import '../widget/vehicle_infomation.dart';

abstract class ProfileState {}

class UpdateInitialState extends ProfileState {}

class UpdateProfileLoading extends ProfileState {}

class UpdateProfileError extends ProfileState {
  final String message;

  UpdateProfileError({required this.message});
}

class UpdateProfileSuccess extends ProfileState {
  final String message;
  UpdateProfileSuccess({required this.message});
}

class UpdateAddressLoading extends ProfileState {}

class UpdateAddressError extends ProfileState {
  final String message;

  UpdateAddressError({required this.message});
}

class DeleteProfileLoading extends ProfileState {}

class DeleteProfileError extends ProfileState {
  final String message;

  DeleteProfileError({required this.message});
}

class DeleteProfileSuccess extends ProfileState {}

class UploadProfilePicLoading extends ProfileState {}

class UploadProfilePicError extends ProfileState {
  final String message;

  UploadProfilePicError({required this.message});
}

class UploadProfilePicSuccess extends ProfileState {}

class VehicleBrandLoading extends ProfileState {}

class VehicleBrandError extends ProfileState {
  late final String message;

  VehicleBrandError({required this.message});
}

class VehicleBrandSuccess extends ProfileState {
  late final VehicleModel vehicleModel;

  VehicleBrandSuccess({required this.vehicleModel});
}

class DriverVehicleLoading extends ProfileState {}

class DriverVehicleError extends ProfileState {
  late final String message;

  DriverVehicleError({required this.message});
}

class DriverVehicleSuccess extends ProfileState {
  late final VehicleModel vehicleModel;

  DriverVehicleSuccess({required this.vehicleModel});
}

class AddVehicleInfoSuccess extends ProfileState {}

class AddVehicleInfoLoading extends ProfileState {}

class AddVehicleInfoError extends ProfileState {
  final String message;

  AddVehicleInfoError({required this.message});
}

class UploadVehicleSuccess extends ProfileState {}

class UploadVehicleLoading extends ProfileState {}

class UploadVehicleError extends ProfileState {
  final String message;

  UploadVehicleError({required this.message});
}

class ManufactureVehicleSuccess extends ProfileState {
  final List<CarsModel> vehicleManufacture;
  ManufactureVehicleSuccess({required this.vehicleManufacture});
}

class ManufactureVehicleLoading extends ProfileState {}

class ManufactureVehicleError extends ProfileState {
  final String message;

  ManufactureVehicleError({required this.message});
}

class VehiclePlateSuccess extends ProfileState {
  final String vehiclePlate;
  VehiclePlateSuccess({required this.vehiclePlate});
}

class VehiclePlateLoading extends ProfileState {}

class VehiclePlateError extends ProfileState {
  final String message;

  VehiclePlateError({required this.message});
}

class AllManufactureVehicleSuccess extends ProfileState {
  final List<VehicleTypeModel> allVehicleManufacture;
  AllManufactureVehicleSuccess({required this.allVehicleManufacture});
}

class AllManufactureVehicleLoading extends ProfileState {}

class AllManufactureVehicleError extends ProfileState {
  final String message;

  AllManufactureVehicleError({required this.message});
}

class GetVehiclesLoading extends ProfileState {}

class GetVehiclesSuccess extends ProfileState {
  final List<VehicleModel> vehicles;
  GetVehiclesSuccess({required this.vehicles});
}

class GetVehiclesError extends ProfileState {
  final String message;

  GetVehiclesError({required this.message});
}

class SetVehiclePrimarySuccess extends ProfileState {
  final String vehicleId;
  SetVehiclePrimarySuccess({required this.vehicleId});
}

class SetVehicleAsPrimaryLoading extends ProfileState {}

class SetVehicleAsPrimaryError extends ProfileState {
  final String message;

  SetVehicleAsPrimaryError({required this.message});
}

class GetProfilePicsSuccess extends ProfileState {
  // final String userUUID;
  //GetProfilePicsSuccess({});
}

class GetProfilePicsLoading extends ProfileState {}

class GetProfilePicsError extends ProfileState {
  final String message;

  GetProfilePicsError({required this.message});
}

class WithdrawBonusLoading extends ProfileState {}

class WithdrawBonusSuccess extends ProfileState {}

class WithdrawBonusError extends ProfileState {
  final String message;
  WithdrawBonusError({required this.message});
}
