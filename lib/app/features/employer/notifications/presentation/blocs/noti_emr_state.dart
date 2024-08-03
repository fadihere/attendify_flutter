part of 'noti_emr_bloc.dart';

class NotiEmrState extends Equatable {
  final Status status;
  final List<NotiModel> notiList;
  final AttendanceRes? attendanceModel;

  const NotiEmrState(
      {this.status = Status.initial,
      this.notiList = const [],
      this.attendanceModel});

  @override
  List<Object?> get props => [status, notiList, AttendanceRes];

  NotiEmrState copyWith(
      {Status? status,
      List<NotiModel>? notiList,
      AttendanceRes? attendanceModel}) {
    return NotiEmrState(
      status: status ?? this.status,
      notiList: notiList ?? this.notiList,
      attendanceModel: attendanceModel ?? this.attendanceModel,
    );
  }
}
