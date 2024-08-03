// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'team_bloc.dart';

class TeamState extends Equatable {
  final Status status;
  final Failure? failure;
  final List<TeamModel> myteam;
  final List<TeamModel> activeteam;
  final List<TeamModel> deactiveteam;
  final int? code;
  final String countryCode;

  final bool isActive;
  const TeamState({
    this.status = Status.initial,
    this.countryCode = "+92",
    this.failure,
    this.myteam = const [],
    this.activeteam = const [],
    this.deactiveteam = const [],
    this.code,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        myteam,
        isActive,
        activeteam,
        deactiveteam,
        status,
        code,
        failure,
        countryCode,
      ];

  TeamState copyWith({
    Status? status,
    Failure? failure,
    List<TeamModel>? myteam,
    List<TeamModel>? activeteam,
    List<TeamModel>? deactiveteam,
    int? code,
    String? countryCode,
    bool? isActive,
  }) {
    return TeamState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      myteam: myteam ?? this.myteam,
      activeteam: activeteam ?? this.activeteam,
      deactiveteam: deactiveteam ?? this.deactiveteam,
      code: code ?? this.code,
      countryCode: countryCode ?? this.countryCode,
      isActive: isActive ?? this.isActive,
    );
  }
}

class ShowFaceScanDialog extends TeamState {
  final TeamModel team;
  const ShowFaceScanDialog(this.team);
}
