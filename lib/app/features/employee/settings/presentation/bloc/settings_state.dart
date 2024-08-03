// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'settings_bloc.dart';

class SettingsEmpState extends Equatable {
  final String firstCode;
  final String secondCode;
  final Status status;
  final bool obscureTextOne;
  final bool obscureTextTwo;
  final bool obscureTextThree;

  const SettingsEmpState({
    this.firstCode = "+92",
    this.secondCode = "+92",
    this.status = Status.initial,
    this.obscureTextOne = true,
    this.obscureTextTwo = true,
    this.obscureTextThree = true,
  });

  @override
  List<Object> get props => [
        firstCode,
        secondCode,
        status,
        obscureTextOne,
        obscureTextTwo,
        obscureTextThree,
      ];

  SettingsEmpState copyWith({
    String? firstCode,
    String? secondCode,
    Status? status,
    bool? obscureTextOne,
    bool? obscureTextTwo,
    bool? obscureTextThree,
  }) {
    return SettingsEmpState(
      firstCode: firstCode ?? this.firstCode,
      secondCode: secondCode ?? this.secondCode,
      status: status ?? this.status,
      obscureTextOne: obscureTextOne ?? this.obscureTextOne,
      obscureTextTwo: obscureTextTwo ?? this.obscureTextTwo,
      obscureTextThree: obscureTextThree ?? this.obscureTextThree,
    );
  }
}
