import 'dart:async';
import 'dart:developer';

import 'package:attendify_lite/app/features/employee/leave/data/models/leave_count_model.dart';
import 'package:attendify_lite/app/features/employee/leave/data/repositories/leave_repo_emp.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/enums/status.dart';
import '../../data/models/leave_transaction_model.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveRepoEmpImpl repo;
  LeaveBloc({required this.repo}) : super(const LeaveState()) {
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });

    on<FetchLeaveCountsEvent>(_onFetchLeaveCount);
    on<FetchLeaveTransactionsEvent>(_onFetchLeaveTransactions);
  }

  FutureOr<void> _onFetchLeaveCount(
      FetchLeaveCountsEvent event, Emitter<LeaveState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final response = await repo.fetchTotalLeavesCount(
      employerID: event.employerID,
      employeeID: event.employeeID,
    );
    final leaveState = response.fold<LeaveState>((l) {
      log(l.toString());
      return state.copyWith(status: Status.error);
    },
        (r) => state.copyWith(
              status: Status.success,
              leaveCount: r,
            ));
    emit(leaveState);
  }

  FutureOr<void> _onFetchLeaveTransactions(
      FetchLeaveTransactionsEvent event, Emitter<LeaveState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final response = await repo.fetchLeaveTransactions(
      employeeID: event.employeeID,
      startDate: event.startDate,
    );
    final leaveState = response.fold<LeaveState>((l) {
      log(l.toString());
      return state.copyWith(status: Status.error);
    }, (r) {
      log("ALL REQUEST ======> ${r.length}");
      final pendingList = r
          .where(
              (e) => (e.requestApproved == null || e.requestApproved == false))
          .toList();

      log("PENDING REQUEST ======> ${pendingList.toList().length}");
      final approvedList = r.where((e) => e.requestApproved == true).toList();
      log("APPROVED REQUEST ======> ${approvedList.toList().length}");

      return state.copyWith(
          status: Status.success,
          pendingLeaveList: pendingList,
          approvedLeaveList: approvedList);
    });
    emit(leaveState);
  }
}
