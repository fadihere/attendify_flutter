// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthEmpEvent extends Equatable {
  const AuthEmpEvent();

  @override
  List<Object?> get props => [];
}

class ObscurePasswordEvent extends AuthEmpEvent {}

class ObscureNewPasswordEvent extends AuthEmpEvent {}

class ObscureConfirmPasswordEvent extends AuthEmpEvent {}

class SetCodeEvent extends AuthEmpEvent {
  final String code;
  const SetCodeEvent({required this.code});
}

class ChangeCountryCodeEvent extends AuthEmpEvent {
  final String countryCode;
  const ChangeCountryCodeEvent({required this.countryCode});
}

class UserSignInEvent extends AuthEmpEvent {
  final String phoneNumber;
  final String password;
  const UserSignInEvent({
    required this.phoneNumber,
    required this.password,
  });
}

class ChangePhoneEvent extends AuthEmpEvent {
  final String phone;
  const ChangePhoneEvent({required this.phone});
}

class ForgotPasswordEvent extends AuthEmpEvent {
  final String phoneNumber;
  const ForgotPasswordEvent({
    required this.phoneNumber,
  });
}

class VerifyOTPEvent extends AuthEmpEvent {
  final String sentCode;
  final String recievedCode;
  final int otpTimer;
  final String phoneNumber;
  final int navigationType;
  const VerifyOTPEvent({
    required this.sentCode,
    required this.recievedCode,
    required this.otpTimer,
    required this.phoneNumber,
    required this.navigationType,
  });
}

class UploadNewNumberEvent extends AuthEmpEvent {
  final String newPhone;
  final String employeeID;
  final String employerID;
  const UploadNewNumberEvent({
    required this.newPhone,
    required this.employeeID,
    required this.employerID,
  });
}

class ResendCodeEvent extends AuthEmpEvent {
  final String phoneNumber;
  const ResendCodeEvent({
    required this.phoneNumber,
  });
}

class ResetPasswordEvent extends AuthEmpEvent {
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const ResetPasswordEvent({
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });
}

class CheckUserEvent extends AuthEmpEvent {}

class LogoutEvent extends AuthEmpEvent {
  final String empId;
  final String emrId;
  const LogoutEvent({
    required this.empId,
    required this.emrId,
  });
}

class GetLocationDataEvent extends AuthEmpEvent {}

class UploadProfileImageEvent extends AuthEmpEvent {
  final File newImage;

  const UploadProfileImageEvent({required this.newImage});
  @override
  List<Object?> get props => [newImage];
}

class PickImageEvent extends AuthEmpEvent {
  final ImageSource source;
  const PickImageEvent({required this.source});
  @override
  List<Object?> get props => [source];
}
