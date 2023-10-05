abstract class AuthState {}

class AuthLoadingState extends AuthState {}

class AuthIdleState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState({required this.errorMessage});
}

class SetPrefLoading extends AuthState {}

class SetPrefError extends AuthState {
  final String errorMessage;

  SetPrefError({required this.errorMessage});
}

class SetPrefSuccess extends AuthState {}

class UpdatePrefLoading extends AuthState {}

class UpdatePrefSuccess extends AuthState {}

class UpdatePrefError extends AuthState {
  final String message;
  UpdatePrefError({required this.message});
}

class UpdateNinLoading extends AuthState {}

class UpdateNinError extends AuthState {
  final String errorMessage;

  UpdateNinError({required this.errorMessage});
}

class UpdateNinSuccess extends AuthState {}

class FileUploadLoading extends AuthState {}

class FileUploadError extends AuthState {
  final String errorMessage;

  FileUploadError({required this.errorMessage});
}

class FileUploadSuccess extends AuthState {}

class VehicleRegLoading extends AuthState {}

class VehicleRegError extends AuthState {
  final String errorMessage;

  VehicleRegError({required this.errorMessage});
}

class VehicleRegSuccess extends AuthState {}
