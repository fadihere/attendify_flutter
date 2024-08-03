import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  //Failure([List properties = const <dynamic>[]]);
  final Map<String, dynamic>? response;

  const Failure({this.response});

  @override
  List<Object?> get props => [response];
}

// General failures
class SocketFailure extends Failure {}

class ServerFailure extends Failure {
  const ServerFailure({super.response});
}

class TimeoutFailure extends Failure {
  final String errorMessage;
  const TimeoutFailure({required this.errorMessage});
}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class UnknownFailure extends Failure {}
