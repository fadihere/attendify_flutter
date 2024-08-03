part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserStateInitial extends UserState {}

class UserNotLoggedIn extends UserState {}

class EmpLoggedIn extends UserState {}

class EmrLoggedIn extends UserState {}
class MockLocation extends UserState{}

class SingularLoggedIn extends UserState {}
