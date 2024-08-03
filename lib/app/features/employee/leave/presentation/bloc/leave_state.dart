part of 'leave_bloc.dart';

class LeaveState extends Equatable {
  final Status status;
  final String errorMessage;
  final int currentIndex;
  final LeaveCountModel? leaveCount;
  final List<LeaveTransactionModel> pendingLeaveList;
  final List<LeaveTransactionModel> approvedLeaveList;

  const LeaveState(
      {this.status = Status.initial,
      this.errorMessage = '',
      this.currentIndex = 0,
      this.pendingLeaveList = const [],
      this.approvedLeaveList = const [],
      this.leaveCount});

  @override
  List<Object?> get props {
    return [
      status,
      errorMessage,
      currentIndex,
      leaveCount,
      pendingLeaveList,
      approvedLeaveList,
    ];
  }

  LeaveState copyWith({
    Status? status,
    String? errorMessage,
    int? currentIndex,
    LeaveCountModel? leaveCount,
    List<LeaveTransactionModel>? pendingLeaveList,
    List<LeaveTransactionModel>? approvedLeaveList,
  }) {
    return LeaveState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      leaveCount: leaveCount ?? this.leaveCount,
      pendingLeaveList: pendingLeaveList ?? this.pendingLeaveList,
      approvedLeaveList: approvedLeaveList ?? this.approvedLeaveList,
    );
  }
}
