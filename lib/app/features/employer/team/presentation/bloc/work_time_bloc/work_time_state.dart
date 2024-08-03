// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'work_time_bloc.dart';

class WorkTimeState extends Equatable {
  final Status status;
  final WorkHrsModel? workHrs;
  const WorkTimeState({this.workHrs, this.status = Status.initial});
  @override
  List<Object?> get props => [workHrs, status];

  WorkTimeState copyWith({
    Status? status,
    WorkHrsModel? workHrs,
  }) {
    return WorkTimeState(
      status: status ?? this.status,
      workHrs: workHrs ?? this.workHrs,
    );
  }
}
