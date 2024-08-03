// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

class AuthEmrState extends Equatable {
  final Status status;
  final UserEmrModel? user;
  final String errorMessage;
  final File? image;
  final String otpCode;
  final int interval;
  const AuthEmrState({
    this.status = Status.initial,
    this.user,
    this.errorMessage = '',
    this.image,
    this.otpCode = '',
    this.interval = 0,
  });

  @override
  List<Object?> get props =>
      [status, user, errorMessage, image, otpCode, interval];

  AuthEmrState copyWith(
      {Status? status,
      UserEmrModel? user,
      String? errorMessage,
      File? image,
      String? otpCode,
      int? interval}) {
    return AuthEmrState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        image: image ?? this.image,
        otpCode: otpCode ?? this.otpCode,
        interval: interval ?? this.interval);
  }
}

class ShowImageDialogState extends AuthEmrState {
  final File newimage;
  const ShowImageDialogState({required this.newimage});

  @override
  List<Object?> get props => [newimage];
}
