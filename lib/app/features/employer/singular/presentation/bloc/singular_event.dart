// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'singular_bloc.dart';

abstract class SingularEvent extends Equatable {
  const SingularEvent();

  @override
  List<Object> get props => [];
}

class AddSetup1Event extends SingularEvent {
  final int pin;
  const AddSetup1Event({
    required this.pin,
  });
}

class ClearPin1Event extends SingularEvent {}

class AddSetup2Event extends SingularEvent {
  final int pin;
  const AddSetup2Event({
    required this.pin,
  });
}

class ClearPin2Event extends SingularEvent {}

class AddSetup3Event extends SingularEvent {
  final int pin;
  const AddSetup3Event({
    required this.pin,
  });
}

class ClearPin3Event extends SingularEvent {}

class OpenFaceDialogEvent extends SingularEvent {}

class CheckUserAndClock extends SingularEvent {
  final String emrId;
  final File file;
  const CheckUserAndClock({
    required this.emrId,
    required this.file,
  });
}
