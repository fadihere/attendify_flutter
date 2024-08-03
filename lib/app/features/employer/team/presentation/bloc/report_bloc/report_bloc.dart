import 'package:attendify_lite/app/features/employer/reports/data/datasources/remote_reports.dart';
import 'package:attendify_lite/app/features/employer/team/data/repositories/team_repo.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/config/routes/app_router.dart';
import '../../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../../core/utils/functions/functions.dart';
import '../../../../../employee/logs/data/models/logs_model.dart';
import '../../../../reports/data/models/invoice_model.dart';
import '../../../data/models/team_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final TeamRepoImpl repo;
  final RemoteReportsImpl reportsRepo;
  ReportBloc({required this.repo, required this.reportsRepo})
      : super(const ReportState()) {
    on<FetchReportLogsEvent>(_onFetchReportLogs);
    on<SelectDayEvent>(_onDaySelected);
  }
  _onFetchReportLogs(
      FetchReportLogsEvent event, Emitter<ReportState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final endDate = DateTime.now();

    final invoiceRes = await reportsRepo.getEmployeeInvoiceByEmrID(
      event.team.employeeId,
      event.employerID,
      event.team.createdOn!,
      endDate,
    );

    final response = await repo.fetchEmployeeAttendanceLogs(
        employerID: event.employerID,
        employeeID: event.team.employeeId,
        startDate: event.team.createdOn!,
        endDate: endDate);

    final reportState = response.fold<ReportState>(
      (l) => state.copyWith(status: Status.error),
      (r) {
        final late = r
            .where((element) => element.attendanceStatus == 'LTL')
            .toList()
            .length;
        final present = r
            .where((element) => element.attendanceStatus == 'PRS')
            .toList()
            .length;
        final absent = r
            .where((element) => element.attendanceStatus == 'ABS')
            .toList()
            .length;
        final wfh = r
            .where((element) => element.attendanceStatus == 'WFH')
            .toList()
            .length;

        return state.copyWith(
            status: Status.success,
            logsList: r,
            presents: present + wfh,
            lates: late,
            absents: absent,
            invoice: invoiceRes);
      },
    );
    emit(reportState);
  }

  _onDaySelected(SelectDayEvent event, Emitter<ReportState> emit) {
    if (event.selectedDay.isBefore(event.team.createdOn!)) {
      showToast(msg: 'Cannot select previous date before joining');
      return;
    }

    if (event.selectedDay.isAfter(DateTime.now())) {
      showToast(msg: 'Cannot select upcoming date');
      return;
    }
    // for (var e in state.logsList) {
    //   print(e.createdOn.toString());
    // }
    final todayData = state.logsList
        .where((e) =>
            e.recordedTimeIn!.isSameDay(event.selectedDay) &&
            (e.attendanceStatus == 'PRS' ||
                e.attendanceStatus == 'WFH' ||
                e.attendanceStatus == 'LTL'))
        .toList();

    if (todayData.isNotEmpty) {
      router.push(AdmAttendenceDetailRoute(logsList: todayData));
      return;
    }
    showToast(msg: 'No record available');
    // showToast(msg: 'Only dates with present records will be selected');

    // for (var element in todayData) {
    //   print(element);
    // }
    // final data = state.logsList.firstWhere(
    //   (element) =>
    //       element.recordedTimeIn == event.selectedDay &&
    //       (element.attendanceStatus == 'PRS' ||
    //           element.attendanceStatus == 'WFH'),
    // );
    // print(data.toJson());
    /*  if (!data.isNull) {
      List<LogsModel> logsList = state.logsList
          .where(
            (ele) => (ele.recordedTimeIn!.day == event.selectedDay.day &&
                ele.recordedTimeIn!.month == event.selectedDay.month &&
                ele.recordedTimeIn!.year == event.selectedDay.year),
          )
          .toList();
     
      return;
    }
    showToast(msg: 'Dates with empty record cannot be selected');
    return; */
  }
}
