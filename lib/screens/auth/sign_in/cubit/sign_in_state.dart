part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

// Complete Login States

class SubmittingUserLogin extends SignInState {}

class SubmittedUserLogin extends SignInState {}

class SubmitUserLoginWithError extends SignInState {
  final String message;

  SubmitUserLoginWithError({required this.message});
}

// States for Adding Device Token
class AddingDeviceToken extends SignInState {}

class AddedDeviceToken extends SignInState {}

class AddDeviceTokenWithError extends SignInState {
  final String message;
  AddDeviceTokenWithError({required this.message});
}

// States for Deleting Device Token
class RemovingDeviceToken extends SignInState {}

class RemovedDeviceToken extends SignInState {}

class RemovedTokenWithError extends SignInState {
  final String message;
  RemovedTokenWithError({required this.message});
}

// profile
class GetProfileLoading extends SignInState {}

class GetProfileSuccess extends SignInState {
  final User? user;
  GetProfileSuccess({this.user});
}

class GetProfileError extends SignInState {
  final String message;
  GetProfileError({required this.message});
}

class ActivateWalletLoading extends SignInState {}

class ActivateWalletSuccess extends SignInState {}

class ActivateWalletError extends SignInState {
  final String message;
  ActivateWalletError({required this.message});
}

class SendOtpLoading extends SignInState {}

class SendOtpSuccess extends SignInState {
  final LoginResponseModel loginResponseModel;
  SendOtpSuccess({required this.loginResponseModel});
}

class SendOtpError extends SignInState {
  final String message;
  SendOtpError({required this.message});
}

class VerifyOtpLoading extends SignInState {}

class VerifyOtpError extends SignInState {
  final String errorMessage;

  VerifyOtpError({required this.errorMessage});
}

class VerifyOtpSuccess extends SignInState {}
