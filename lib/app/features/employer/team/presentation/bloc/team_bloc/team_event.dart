// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'team_bloc.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object?> get props => [];
}

class GetMyTeamEvent extends TeamEvent {
  final UserEmrModel user;
  const GetMyTeamEvent({
    required this.user,
  });
  @override
  List<Object?> get props => [user];
}

class GetActiveTeamEvent extends TeamEvent {}

class FetchInvoiceEvent extends TeamEvent {}

class ChangeCountryCodeEvent extends TeamEvent {
  final String countryCode;
  const ChangeCountryCodeEvent({required this.countryCode});
}

class DeleteEmployeeEvent extends TeamEvent {
  final TeamModel team;
  final UserEmrModel user;

  const DeleteEmployeeEvent({
    required this.team,
    required this.user,
  });
}

class UpdateEmployeeFace extends TeamEvent {
  final File image;
  final TeamModel team;
  const UpdateEmployeeFace({
    required this.image,
    required this.team,
  });
}

class UpdateEmployeePhoneEvent extends TeamEvent {
  final TeamModel team;
  final String phoneNo;
  const UpdateEmployeePhoneEvent({
    required this.team,
    required this.phoneNo,
  });
}

class GetEmployeeIdEvent extends TeamEvent {
  final int employerId;
  const GetEmployeeIdEvent({
    required this.employerId,
  });
}

class GetDeactiveTeamEvent extends TeamEvent {}

class CreateEmployeeEvent extends TeamEvent {
  final TeamModel user;
  final File? image;
  final LocEmrModel location;
  final String password;
  const CreateEmployeeEvent({
    required this.user,
    required this.image,
    required this.location,
    required this.password,
  });
}

class SearchTeamEvent extends TeamEvent {
  final String text;
  const SearchTeamEvent({
    required this.text,
  });
}

class ArchiveTeamEvent extends TeamEvent {
  final TeamModel team;
  final UserEmrModel user;
  final bool action;
  const ArchiveTeamEvent({
    required this.team,
    required this.user,
    required this.action,
  });
}

class RegisterEmployeeFace extends TeamEvent {
  final File image;
  final String empId;
  const RegisterEmployeeFace({
    required this.image,
    required this.empId,
  });
}
