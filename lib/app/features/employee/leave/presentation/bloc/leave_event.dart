// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'leave_bloc.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object> get props => [];
}

class ChangeTabEvent extends LeaveEvent {
  final int index;
  const ChangeTabEvent({required this.index});
  @override
  List<Object> get props => [index];
}

class FetchLeaveCountsEvent extends LeaveEvent {
  final String employerID;
  final String employeeID;
  const FetchLeaveCountsEvent({
    required this.employerID,
    required this.employeeID,
  });
}

class FetchLeaveTransactionsEvent extends LeaveEvent {
  final String employeeID;
  final DateTime startDate;
  const FetchLeaveTransactionsEvent({
    required this.employeeID,
    required this.startDate,
  });
}
