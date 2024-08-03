import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/app/features/employee/logs/data/models/logs_model.dart';
import 'package:attendify_lite/app/features/employee/logs/data/repositories/logs_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:ntp/ntp.dart';

import '../../../../../../core/utils/functions/functions.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsRepoImpl logsRepo;

  LogsBloc({required this.logsRepo}) : super(const LogsState()) {
    on<FetchLogsEvent>(_onFetchLogs);
    on<FetchPreviousMonthLogsEvent>(_onPreviousMonthLogs);
    on<FetchNextMonthLogsEvent>(_onNextMonthLogs);
  }
  _onPreviousMonthLogs(
      FetchPreviousMonthLogsEvent event, Emitter<LogsState> emit) {
    final endDate = state.startDate!.previousMonth.endOfMonth;
    final startDate = state.startDate!.previousMonth.startOfMonth;

    if (event.createdOn.isBefore(startDate)) {
      add(FetchLogsEvent(
        user: event.user,
        startDate: startDate,
        endDate: endDate,
      ));
    } else {
      showToast(msg: "Can't select an old month before joining");
    }
  }

  _onNextMonthLogs(FetchNextMonthLogsEvent event, Emitter<LogsState> emit) {
    final endDate = state.startDate!.nextMonth.endOfMonth;
    final startDate = state.startDate!.nextMonth.startOfMonth;
    if (endDate.isAfter(DateTime.now().nextMonth)) {
      showToast(msg: 'Can\'t select an upcoming month');
      return;
    }
    add(FetchLogsEvent(
      user: event.user,
      startDate: startDate,
      endDate: endDate,
    ));
  }

  Future<DateTime> _fetchCurrentDate() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return NTP.now();
    }
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return NTP.now();
    }
    return DateTime.now();
  }

  _onFetchLogs(FetchLogsEvent event, Emitter<LogsState> emit) async {
    final currentDate = await _fetchCurrentDate();
    emit(state.copyWith(
        isLoadingState: true,
        startDate: event.startDate ?? currentDate.startOfMonth,
        endDate: event.endDate ?? currentDate));

    final res = await logsRepo.fetchUserLogs(
      employeeID: event.user.employeeId,
      employerID: event.user.employerId,
      startDate: state.startDate ?? currentDate.startOfMonth,
      endDate: state.endDate ?? currentDate,
    );
    res.fold((left) {
      emit(state.copyWith(
          logsList: [],
          errorMessage: 'Error Occured. Try again later',
          isFailedState: true,
          isLoadingState: false));
    }, (logsList) {
      if (logsList!.isNotEmpty) {
        emit(state.copyWith(
          isLoadingState: false,
          logsList: logsList,
        ));
        return;
      }
      emit(state.copyWith(
        logsList: [],
        isLoadingState: false,
        errorMessage: 'No Data To Show',
      ));
    });
  }
}
