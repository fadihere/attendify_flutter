// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchReportLogsEvent extends ReportEvent {
  final TeamModel team;
  final String employerID;
  FetchReportLogsEvent({
    required this.employerID,
    required this.team,
  });
}

class FetchPdfRecordsEvent extends ReportEvent {
  final TeamModel team;
  final String employerID;
  FetchPdfRecordsEvent({
    required this.employerID,
    required this.team,
  });
}

class SelectDayEvent extends ReportEvent {
  final DateTime selectedDay;
  final TeamModel team;
  SelectDayEvent({
    required this.selectedDay,
    required this.team,
  });
}
