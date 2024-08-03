// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:attendify_lite/app/features/employee/home/data/models/attendance_model.dart';
import 'package:attendify_lite/app/features/employer/home/data/models/attendance_summary_model.dart';
import 'package:attendify_lite/app/shared/datasource/noti_remote_db.dart';
import 'package:attendify_lite/core/utils/fcm_helper.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ntp/ntp.dart';

import '../../../../../../core/enums/status.dart';
import '../../data/repositories/home_repository_emr.dart';

part 'adm_home_event.dart';
part 'adm_home_state.dart';

class AdmHomeBloc extends Bloc<AdmHomeEvent, AdmHomeState> {
  final HomeRepoEmrImpl homeRepoEmr;

  AdmHomeBloc({required this.homeRepoEmr}) : super(const AdmHomeState()) {
    on<GetAttendenceSummaryEvent>(_onFetchAttendenceSummary);
    on<GetRequestsEvent>(_onFetchRequests);
    on<RejectOrApproveReqEvent>(_onRejectOrApproveReq);
    on<FetchAttendanceRecordEvent>(_onFetchAtendanceRecord);
    on<FilterListByStatusEvent>(_onFilterList);
    on<AdmShowNotificationEvent>(_showNotification);
  }
  Future _onFetchAttendenceSummary(
    GetAttendenceSummaryEvent event,
    Emitter<AdmHomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final response =
        await homeRepoEmr.fetchAttendanceSummary(employerID: event.employerId);
    final newstate = response.fold<AdmHomeState>(
      (l) => state.copyWith(status: Status.error),
      (summaryModel) {
        if (summaryModel.count != 0 && summaryModel.present != 0) {
          final totalPresent =
              (summaryModel.present / summaryModel.count) * 100;
          return state.copyWith(
            // status: Status.success,
            summaryModel: summaryModel,
            totalPresent: totalPresent.toInt(),
          );
        }

        return state.copyWith(
          // status: Status.success,
          summaryModel: summaryModel,
          totalPresent: 0,
        );
      },
    );
    emit(newstate);
  }

  Future _onFetchRequests(
    GetRequestsEvent event,
    Emitter<AdmHomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    DateTime endDate = await NTP.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, 1);

    final response = await homeRepoEmr.fetchRequests(
      employerID: event.employerId,
      startDate: startDate.toIso8601String().split('.').first,
      endDate: endDate.toIso8601String().split('.').first,
    );
    final newstate = response.fold<AdmHomeState>(
      (l) => state.copyWith(status: Status.error),
      (r) {
        final list = r.cast<AttendanceModel>();
        final tempList =
            list.takeWhile((value) => value.requestApproved == null).toList();
        tempList.sort((a, b) {
          return b.recordedTimeIn!.compareTo(a.recordedTimeIn!);
        });

        return state.copyWith(status: Status.success, requestsList: tempList);
      },
    );

    emit(newstate);
  }

  Future _onRejectOrApproveReq(
      RejectOrApproveReqEvent event, Emitter<AdmHomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    // print(event.approvalStatus);

    final user =
        await homeRepoEmr.fetchEmployeeDetail(employeeID: event.employeeID);
    log("########event approval status::${event.approvalStatus}");
    final response = await homeRepoEmr.requestApprovalAPI(
        transId: event.transID, request: event.approvalStatus);
    final homeState = response.fold<AdmHomeState>((l) {
      showToast(msg: 'Cannot update request right now');
      return state.copyWith(status: Status.error);
    }, (r) {
      if (event.approvalStatus == true) {}
      add(GetRequestsEvent(employerId: event.employerID));
      return state.copyWith(status: Status.success);
    });
    emit(homeState);

    user.fold((l) => null, (user) {
      if (user.token.isNotEmpty && event.approvalStatus) {
        FCMHelper.sendNotification(user.token, 'Request Approved',
            'Your request for work from home has been approved', "employee");
        NotiRemoteDB.sendNotificationAPI(
            title: 'Request Approved',
            subTitle: 'Your request for work from home has been approved',
            employeeID: event.employeeID,
            employerID: event.employerID,
            attendanceID: int.parse(event.transID),
            notificationType: "Request Approved");
        return;
      }
      if (user.token.isNotEmpty && !event.approvalStatus) {
        FCMHelper.sendNotification(user.token, 'Request Rejected',
            'Your request for work from home has been Rejected', "employee");
        NotiRemoteDB.sendNotificationAPI(
            title: 'Request Rejected',
            subTitle: 'Your request for work from home has been Rejected',
            employeeID: event.employeeID,
            employerID: event.employerID,
            attendanceID: int.parse(event.transID),
            notificationType: "Request Rejected");
        return;
      }
      if (user.token.isEmpty && !event.approvalStatus) {
        NotiRemoteDB.sendNotificationAPI(
            title: 'Request Rejected',
            subTitle: 'Your request for work from home has been Rejected',
            employeeID: event.employeeID,
            employerID: event.employerID,
            attendanceID: int.parse(event.transID),
            notificationType: "Request Rejected");
        return;
      }
      if (user.token.isEmpty && event.approvalStatus) {
        NotiRemoteDB.sendNotificationAPI(
            title: 'Request Approved',
            subTitle: 'Your request for work from home has been Approved',
            employeeID: event.employeeID,
            employerID: event.employerID,
            attendanceID: int.parse(event.transID),
            notificationType: "Request Approved");
        return;
      }
    });
  }

  Future _onFetchAtendanceRecord(
    FetchAttendanceRecordEvent event,
    Emitter<AdmHomeState> emit,
  ) async {
    final startDate = DateTime.now().copyWith(hour: 00, minute: 00, second: 00);
    final endDate = DateTime.now().copyWith(hour: 23, minute: 59, second: 59);
    emit(state.copyWith(status: Status.loading));
    final response = await homeRepoEmr.fetchAttendanceRecord(
      employerID: event.employerID,
      startDate: event.startDate ?? startDate,
      endDate: event.endDate ?? endDate,
    );
    final homeState = response.fold<AdmHomeState>(
      (failure) {
        return state.copyWith(status: Status.error);
      },
      (list) {
        log(list.length.toString());
        final attendanceList = list.cast<AttendanceModel>();
        log(attendanceList.length.toString());
        return state.copyWith(
            status: Status.success,
            attendanceList: attendanceList,
            filtered: attendanceList);
      },
    );
    emit(homeState);
  }

  _onFilterList(
    FilterListByStatusEvent event,
    Emitter<AdmHomeState> emit,
  ) {
    final map = {
      'ALL': 'ALL',
      'PRS': 'PRS',
      'ABS': 'ABS',
      'LATE': 'LTL',
      'WFH': 'WFH',
    };

    if (event.attendanceStatus == 'ALL') {
      emit(state.copyWith(
        filtered: state.attendanceList,
        selectedStatus: event.attendanceStatus,
      ));
      return;
    }
    final list = state.attendanceList.where((e) {
      return e.attendanceStatus == map[event.attendanceStatus];
    }).toList();

    emit(state.copyWith(
      filtered: List.of(list),
      selectedStatus: event.attendanceStatus,
    ));
  }

  _showNotification(
      AdmShowNotificationEvent event, Emitter<AdmHomeState> emit) {
    // log("NOTIFICATION STATUS BLOC ====> ${event.status.toString()}");
    emit(state.copyWith(showNotification: event.status));
    // log("NOTIFICATION STATUS STATE BLOC ====> ${state.showNotification.toString()}");
  }
}
