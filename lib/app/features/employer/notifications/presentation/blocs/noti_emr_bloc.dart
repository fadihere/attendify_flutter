import 'dart:developer';

import 'package:attendify_lite/app/features/employee/home/data/repositories/home_repo_emp.dart';
import 'package:attendify_lite/app/features/employer/notifications/data/respostories/noti_repo.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/fcm_helper.dart';
import '../../../../../shared/datasource/noti_remote_db.dart';
import '../../../../employee/Notifications/data/models/noti_model.dart';
import '../../../../employee/home/data/models/check_out_model.dart';
import '../../data/models/attendance_res.dart';

part 'noti_emr_event.dart';
part 'noti_emr_state.dart';

class NotiEmrBloc extends Bloc<NotiEmrEvent, NotiEmrState> {
  NotiRepoImpl repo;
  HomeRepoEmpImpl homeRepo;

  NotiEmrBloc({required this.repo, required this.homeRepo})
      : super(const NotiEmrState()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<UpdateNotificationEvent>(_onUpdateNotification);
    on<FetchAttendanceDetailByIDEvent>(_onFetchAttendanceDetail);
    on<ClockOutEmployeeEvent>(_onClockOutEmployee);
    on<ClearPreviousNotificationEvent>((event, emit) {
      emit(state.copyWith(status: Status.initial, attendanceModel: null));
    });
  }

  _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotiEmrState> emit,
  ) async {
    final startDate = DateTime.now().copyWith(
      hour: 09,
      minute: 00,
      second: 00,
    );
    final endDate = DateTime.now().copyWith(
      hour: 23,
      minute: 59,
      second: 59,
    );

    emit(state.copyWith(status: Status.loading));

    final response = await repo.fetchEmrNotifications(
      employerID: event.employerID,
      startDate: startDate,
      endDate: endDate,
    );
    if (response.isEmpty) {
      emit(state.copyWith(status: Status.error, notiList: []));
      return;
    }
    emit(state.copyWith(status: Status.success, notiList: response));
  }

  _onUpdateNotification(
    UpdateNotificationEvent event,
    Emitter<NotiEmrState> emit,
  ) async {
    int indexOf = state.notiList.indexWhere((element) =>
        element.notificationId == event.notification.notificationId);
    List<NotiModel> updatedList =
        List.from(state.notiList); // Make a copy of the list
    updatedList[indexOf] =
        updatedList[indexOf].copyWith(isSeen: true); // Update the specific item

    emit(state.copyWith(notiList: updatedList));

    await repo.updateNotificationStatus(
        notificationID: event.notification.notificationId!,
        notiModel: updatedList[indexOf]);
  }

  _onFetchAttendanceDetail(
      FetchAttendanceDetailByIDEvent event, Emitter<NotiEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));
    log("ATTENDANCE ID ===> ${event.attendanceID}");
    final response =
        await repo.fetchAttendanceDetailByID(attendanceID: event.attendanceID);
    response.fold(
        (l) =>
            emit(state.copyWith(status: Status.error, attendanceModel: null)),
        (r) {
      log("ATTENDANCE DETAIL ====> ${r.toJson().toString()}");
      emit(state.copyWith(status: Status.success, attendanceModel: r));
    });
  }

  _onClockOutEmployee(
      ClockOutEmployeeEvent event, Emitter<NotiEmrState> emit) async {
    BotToast.showLoading();
    final attendanceRes = state.attendanceModel;
    if (attendanceRes == null) {
      BotToast.closeAllLoading();
      showToast(msg: 'Cannot clock out employee right now');
      return;
    }
    final model = CheckOutModel(
        employerId: attendanceRes.employerId!,
        employeeId: attendanceRes.employeesId!,
        shiftTimeOut: DateTime.now(),
        employeesId: attendanceRes.employeesId!,
        recordedTimeOut: DateTime.now(),
        outLongitude: event.outLongitude.toString(),
        outLatitude: event.outLatitude.toString(),
        outLocationId: 0);
    log("CLOCK OUT MODEL ====> ${model.toJson().toString()}");
    // BotToast.closeAllLoading();
    final response = await repo.clockOutEmployee(
        attendanceRes: model, attendanceID: attendanceRes.id!);
    response.fold((l) {
      BotToast.closeAllLoading();
      showToast(msg: 'Cannot clock out employee right now');
    }, (r) async {
      BotToast.closeAllLoading();
      showToast(msg: 'Employee has been clocked out');
      final userModelRes = await repo.fetchEmployeeDataByID(
          employeeID: attendanceRes.employeesId!);

      userModelRes.fold((l) {
        return;
      }, (r) {
        NotiRemoteDB.sendNotificationAPI(
          title: "Clocked Out",
          subTitle:
              "You have been clocked out as you were not present at your clocked-in location",
          employeeID: attendanceRes.employeesId!,
          employerID: attendanceRes.employerId!,
          attendanceID: attendanceRes.id,
          notificationType: "Clocked Out",
        );
        FCMHelper.sendNotification(
            r.token,
            "Clocked Out",
            'You have been clocked out as you were not present at your clocked-in location',
            'employee');
      });

      router.popForced();
    });
  }
}
