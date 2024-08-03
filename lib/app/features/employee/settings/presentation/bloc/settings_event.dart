// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_bloc.dart';

abstract class SettingsEmpEvent extends Equatable {
  const SettingsEmpEvent();

  @override
  List<Object?> get props => [];
}

class ObscurePasswordOneEvent extends SettingsEmpEvent {}

class ObscurePasswordTwoEvent extends SettingsEmpEvent {}

class ObscurePasswordThreeEvent extends SettingsEmpEvent {}

class ChangePasswordEvent extends SettingsEmpEvent {
  final String phoneNumber;
  final String currentPassword;
  final String newPassword;
  const ChangePasswordEvent({
    required this.phoneNumber,
    required this.currentPassword,
    required this.newPassword,
  });
}

class UploadNewNumberEvent extends SettingsEmpEvent {
  final String newPhone;
  final int code;
  const UploadNewNumberEvent({
    required this.newPhone,
    required this.code,
  });
}

class ChangeCountryCodeEvent extends SettingsEmpEvent {
  final String? firstCode;
  final String? secondCode;
  const ChangeCountryCodeEvent({
    this.firstCode,
    this.secondCode,
  });
}
