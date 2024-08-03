part of 'work_time_bloc.dart';

abstract class WorkTimeEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchEmpWorkHoursEvent extends WorkTimeEvent {
  final TeamModel team;
  FetchEmpWorkHoursEvent({
    required this.team,
  });
}

class PostEmpWorkHrsEvent extends WorkTimeEvent {
  final WorkHrsModel workHrs;
  final TeamModel team;

  PostEmpWorkHrsEvent({required this.workHrs, required this.team});
}

class UpdateEmpHrsEvent extends WorkTimeEvent {
  final WorkHrsModel workHrs;
  final TeamModel team;

  UpdateEmpHrsEvent({required this.workHrs, required this.team});
}

class UpdateEndHrsEvent extends WorkTimeEvent {
  final DateTime endTime;

  UpdateEndHrsEvent({
    required this.endTime,
  });
}

class UpdateGraceHrsEvent extends WorkTimeEvent {
  final DateTime graceTime;

  UpdateGraceHrsEvent({
    required this.graceTime,
  });
}

class UpdateWeekdaysEvent extends WorkTimeEvent {
  final List<String> days;
  UpdateWeekdaysEvent({
    required this.days,
  });
}
