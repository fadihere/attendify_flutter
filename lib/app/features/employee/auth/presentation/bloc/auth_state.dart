// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

class AuthEmpState extends Equatable {
  final bool obscureText;
  final bool isNewPassObscure;
  final bool isConfirmPassObscure;
  final Status status;
  final String countryCode;
  final Timer? timer;
  final LoginModel? response;
  final UserEmpModel? user;
  final File? image;
  final String otpCode;
  final bool isPhoneChanged;

  const AuthEmpState(
      {this.obscureText = true,
      this.isNewPassObscure = true,
      this.isConfirmPassObscure = true,
      this.status = Status.initial,
      this.countryCode = "+92",
      this.timer,
      this.response,
      this.user,
      this.image,
      this.otpCode = '123456',
      this.isPhoneChanged = false});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        obscureText,
        isNewPassObscure,
        isConfirmPassObscure,
        status,
        countryCode,
        response,
        timer,
        user,
        image,
        otpCode,
        isPhoneChanged,
      ];

  AuthEmpState copyWith(
      {bool? obscureText,
      bool? isNewPassObscure,
      bool? isConfirmPassObscure,
      Status? status,
      String? countryCode,
      Timer? timer,
      LoginModel? response,
      UserEmpModel? user,
      File? image,
      String? otpCode,
      bool? isPhoneChanged}) {
    return AuthEmpState(
      obscureText: obscureText ?? this.obscureText,
      isNewPassObscure: isNewPassObscure ?? this.isNewPassObscure,
      isConfirmPassObscure: isConfirmPassObscure ?? this.isConfirmPassObscure,
      status: status ?? this.status,
      countryCode: countryCode ?? this.countryCode,
      timer: timer ?? this.timer,
      response: response ?? this.response,
      user: user ?? this.user,
      image: image ?? this.image,
      otpCode: otpCode ?? this.otpCode,
      isPhoneChanged: isPhoneChanged ?? this.isPhoneChanged,
    );
  }
}

class ShowImageDialogState extends AuthEmpState {
  final File newimage;
  const ShowImageDialogState({required this.newimage});

  @override
  List<Object?> get props => [newimage];
}
