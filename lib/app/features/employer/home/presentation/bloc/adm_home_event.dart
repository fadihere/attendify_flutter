// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'adm_home_bloc.dart';

abstract class AdmHomeEvent extends Equatable {
  const AdmHomeEvent();

  @override
  List<Object> get props => [];
}

class GetAttendenceSummaryEvent extends AdmHomeEvent {
  final String employerId;

  const GetAttendenceSummaryEvent({
    required this.employerId,
  });
}

class GetRequestsEvent extends AdmHomeEvent {
  final String employerId;

  const GetRequestsEvent({required this.employerId});
}

class FetchAttendanceRecordEvent extends AdmHomeEvent {
  final String employerID;
  final DateTime? startDate;
  final DateTime? endDate;
  const FetchAttendanceRecordEvent({
    required this.employerID,
    this.startDate,
    this.endDate,
  });
}

class RejectOrApproveReqEvent extends AdmHomeEvent {
  final String transID;
  final String employerID;
  final bool approvalStatus;
  final String employeeID;

  const RejectOrApproveReqEvent(
      {required this.transID,
      required this.employerID,
      required this.approvalStatus,
      required this.employeeID});
}

class FilterListByStatusEvent extends AdmHomeEvent {
  final String attendanceStatus;
  const FilterListByStatusEvent({
    required this.attendanceStatus,
  });
}

class AdmShowNotificationEvent extends AdmHomeEvent {
  final bool status;
  const AdmShowNotificationEvent({required this.status});
}
