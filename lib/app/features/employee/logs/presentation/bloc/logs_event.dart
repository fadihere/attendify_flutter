// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'logs_bloc.dart';

abstract class LogsEvent extends Equatable {
  const LogsEvent();

  @override
  List<Object> get props => [];
}

class FetchLogsEvent extends LogsEvent {
  final UserEmpModel user;

  const FetchLogsEvent({
    required this.user,
    this.startDate,
    this.endDate,
  });

  final DateTime? startDate;
  final DateTime? endDate;
}

class FetchPreviousMonthLogsEvent extends LogsEvent {
  final UserEmpModel user;
  const FetchPreviousMonthLogsEvent({
    required this.user,
    required this.createdOn,
  });

  final DateTime createdOn;
}

class FetchNextMonthLogsEvent extends LogsEvent {
  const FetchNextMonthLogsEvent({
    required this.user,
  });

  final UserEmpModel user;
}
