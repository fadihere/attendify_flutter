// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'singular_bloc.dart';

class SingularState extends Equatable {
  final Status status;
  final String pin;
  final String confirmPin;
  final String exitPin;

  const SingularState({
    this.status = Status.initial,
    this.pin = '',
    this.confirmPin = '',
    this.exitPin = '',
  });

  @override
  List<Object> get props => [status, pin, confirmPin, exitPin];

  SingularState copyWith({
    Status? status,
    String? pin,
    String? confirmPin,
    String? exitPin,
  }) {
    return SingularState(
      status: status ?? this.status,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      exitPin: exitPin ?? this.exitPin,
    );
  }
}

class FaceDialogState extends SingularState {}

class ClockedInDialogState extends SingularState {}

class ClockedOutDialogState extends SingularState {}
