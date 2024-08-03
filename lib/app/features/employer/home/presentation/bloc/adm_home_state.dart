// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'adm_home_bloc.dart';

class AdmHomeState extends Equatable {
  final Status? status;
  final AttendanceSummaryModel? summaryModel;
  final List<AttendanceModel> requestsList;
  final int totalPresent;
  final List<AttendanceModel> attendanceList;
  final List<AttendanceModel> filtered;
  final String selectedStatus;
  final bool showNotification;
  const AdmHomeState(
      {this.status,
      this.filtered = const [],
      this.summaryModel,
      this.requestsList = const [],
      this.totalPresent = 0,
      this.selectedStatus = 'All',
      this.attendanceList = const [],
      this.showNotification = false});

  @override
  List<Object?> get props => [
        status,
        summaryModel,
        requestsList,
        totalPresent,
        attendanceList,
        selectedStatus,
        filtered,
        showNotification
      ];

  AdmHomeState copyWith(
      {Status? status,
      AttendanceSummaryModel? summaryModel,
      List<AttendanceModel>? requestsList,
      int? totalPresent,
      List<AttendanceModel>? attendanceList,
      List<AttendanceModel>? filtered,
      String? selectedStatus,
      bool? showNotification}) {
    return AdmHomeState(
      status: status ?? this.status,
      summaryModel: summaryModel ?? this.summaryModel,
      requestsList: requestsList ?? this.requestsList,
      totalPresent: totalPresent ?? this.totalPresent,
      attendanceList: attendanceList ?? this.attendanceList,
      filtered: filtered ?? this.filtered,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      showNotification: showNotification ?? this.showNotification,
    );
  }
}
