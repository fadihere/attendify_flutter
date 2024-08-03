// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'leave_emr_bloc.dart';

abstract class LeaveEmrEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchLeavesPolicyEvent extends LeaveEmrEvent {
  final String employerID;
  FetchLeavesPolicyEvent({
    required this.employerID,
  });
}

class ChangeLeaveStatusEvent extends LeaveEmrEvent {
  final String leaveStatus;
  ChangeLeaveStatusEvent({
    required this.leaveStatus,
  });
}

class DeleteLeavePolicyEvent extends LeaveEmrEvent {
  final String employerID;
  final int policyID;
  DeleteLeavePolicyEvent({
    required this.employerID,
    required this.policyID,
  });
}

class UpdateLeavePolicyEvent extends LeaveEmrEvent {
  final LeavePolicyModel leaveModel;
  final String categoryName;
  final String allowance;
  final String fromDate;
  final String toDate;
  UpdateLeavePolicyEvent({
    required this.leaveModel,
    required this.categoryName,
    required this.allowance,
    required this.fromDate,
    required this.toDate,
  });
}

class CreateLeavePolicyEvent extends LeaveEmrEvent {
  final String employerID;
  final String categoryName;
  final String allowance;
  final String fromDate;
  final String toDate;
  CreateLeavePolicyEvent({
    required this.employerID,
    required this.categoryName,
    required this.allowance,
    required this.fromDate,
    required this.toDate,
  });
}

class UpdateLeavePolicyPeriodEvent extends LeaveEmrEvent {
  final String employerID;
  final String fromDate;
  final String toDate;
  UpdateLeavePolicyPeriodEvent({
    required this.employerID,
    required this.fromDate,
    required this.toDate,
  });
}
