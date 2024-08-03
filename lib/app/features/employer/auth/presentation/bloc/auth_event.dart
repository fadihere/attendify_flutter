// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEmrEvent extends Equatable {
  const AuthEmrEvent();

  @override
  List<Object?> get props => [];
}

class CheckUserEvent extends AuthEmrEvent {}

class SaveTokenEvent extends AuthEmrEvent {
  final String employerID;
  const SaveTokenEvent({required this.employerID});
}

class PostOfficeHoursEvent extends AuthEmrEvent {
  final String employerID;
  const PostOfficeHoursEvent({required this.employerID});
}

class PickImageEvent extends AuthEmrEvent {}

class SigninEvent extends AuthEmrEvent {
  final String email;
  const SigninEvent({required this.email});
}

class CreateOrgEvent extends AuthEmrEvent {
  final String name;
  final String email;
  const CreateOrgEvent({required this.name, required this.email});
}

class VerifyOTPEmrEvent extends AuthEmrEvent {
  final String code;
  final String incomingCode;
  final int currentTime;
  final int navigationType;
  final String email;
  final String? employerID;
  const VerifyOTPEmrEvent({
    required this.code,
    required this.incomingCode,
    required this.currentTime,
    required this.navigationType,
    required this.email,
    this.employerID,
  });
}

class ResendCodeEvent extends AuthEmrEvent {
  final String email;

  const ResendCodeEvent({required this.email});
}

class SetCodeEvent extends AuthEmrEvent {
  final String otp;

  const SetCodeEvent({required this.otp});
}

class LogoutEvent extends AuthEmrEvent {
  final String employerID;
  const LogoutEvent({
    required this.employerID,
  });
}

class UploadProfileImageEvent extends AuthEmrEvent {
  final File newimage;

  const UploadProfileImageEvent(this.newimage);
}

class ChangeEmailEvent extends AuthEmrEvent {
  final String newEmail;
  final String employerID;
  const ChangeEmailEvent({
    required this.newEmail,
    required this.employerID,
  });
}

class SetLogoEvent extends AuthEmrEvent {
  final File newimage;

  const SetLogoEvent(this.newimage);
}

class SetIntervalEvent extends AuthEmrEvent {
  final int interval;
  const SetIntervalEvent({
    required this.interval,
  });
}

class UpdateIntervalEvent extends AuthEmrEvent {
  final UserEmrModel user;
  const UpdateIntervalEvent({
    required this.user,
  });
}
