// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'leave_emr_bloc.dart';

class LeaveEmrState extends Equatable {
  final Status status;
  final List<LeavePolicyModel> leaveList;
  final String leaveStatus;
  const LeaveEmrState(
      {this.status = Status.initial,
      this.leaveList = const [],
      this.leaveStatus = ''});

  @override
  List<Object?> get props => [status, leaveList, leaveStatus];

  LeaveEmrState copyWith({
    Status? status,
    List<LeavePolicyModel>? leaveList,
    String? leaveStatus,
  }) {
    return LeaveEmrState(
        status: status ?? this.status,
        leaveList: leaveList ?? this.leaveList,
        leaveStatus: leaveStatus ?? this.leaveStatus);
  }
}
