import 'dart:developer';

import 'package:attendify_lite/app/features/employer/leave/data/repositories/leave_repo.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../data/models/leave_policy.dart';
import '../../data/models/leave_policy_model.dart';

part 'leave_emr_event.dart';
part 'leave_emr_state.dart';

class LeaveEmrBloc extends Bloc<LeaveEmrEvent, LeaveEmrState> {
  final LeaveRepoImpl repo;
  LeaveEmrBloc({required this.repo}) : super(const LeaveEmrState()) {
    on<FetchLeavesPolicyEvent>(_onFetchLeavesPolicy);
    on<CreateLeavePolicyEvent>(_onCreatePolicy);
    on<ChangeLeaveStatusEvent>(_onChangeLeaveStatus);
    on<UpdateLeavePolicyEvent>(_onUpdateLeavePolicy);
    on<DeleteLeavePolicyEvent>(_onDeleteLeavePolicy);
    on<UpdateLeavePolicyPeriodEvent>(_onUpdateLeavePolicyPeriod);
  }
  _onFetchLeavesPolicy(
      FetchLeavesPolicyEvent event, Emitter<LeaveEmrState> emit) async {
    // emit(state.copyWith(status: Status.loading));
    final response = await repo.fetchLeavesPolicy(employerID: event.employerID);
    final tempState = response.fold((l) => state.copyWith(status: Status.error),
        (r) => state.copyWith(status: Status.success, leaveList: r));

    emit(tempState);
  }

  _onCreatePolicy(
      CreateLeavePolicyEvent event, Emitter<LeaveEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final policy = LeavePolicy(
        categoryName: event.categoryName,
        status: state.leaveStatus,
        allowance: int.parse(event.allowance),
        employersId: event.employerID,
        employerId: event.employerID,
        fromDate: event.fromDate,
        toDate: event.toDate);
    final response = await repo.createLeavePolicy(leavePolicy: policy);
    final tempState =
        response.fold((l) => state.copyWith(status: Status.error), (r) {
      showToast(msg: 'Leave Category Added Successfully');
      add(FetchLeavesPolicyEvent(employerID: event.employerID));
      return state.copyWith(status: Status.success);
    });

    emit(tempState);
    router.maybePop();
  }

  _onChangeLeaveStatus(
      ChangeLeaveStatusEvent event, Emitter<LeaveEmrState> emit) {
    log(event.leaveStatus);
    emit(state.copyWith(leaveStatus: event.leaveStatus));
  }

  _onUpdateLeavePolicy(
      UpdateLeavePolicyEvent event, Emitter<LeaveEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final policy = LeavePolicy(
        categoryName: event.categoryName,
        status: state.leaveStatus.isEmpty
            ? event.leaveModel.status!
            : state.leaveStatus,
        allowance: int.parse(event.allowance),
        employersId: event.leaveModel.employersId!,
        employerId: event.leaveModel.employerId!,
        fromDate: event.fromDate,
        toDate: event.toDate);

    final response = await repo.updateLeavePolicy(
        leavePolicy: policy, policyID: event.leaveModel.id.toString());
    final tempState =
        response.fold((l) => state.copyWith(status: Status.error), (r) {
      showToast(msg: 'Leave Category Updated Successfully');
      return state.copyWith(status: Status.success);
    });

    add(FetchLeavesPolicyEvent(employerID: event.leaveModel.employerId!));
    emit(tempState);
    router.maybePop();
  }

  _onDeleteLeavePolicy(
      DeleteLeavePolicyEvent event, Emitter<LeaveEmrState> emit) async {
    final response = await repo.deleteLeavePolicy(policyID: event.policyID);
    final tempState = response.fold((l) {
      log(l.toString());
      showToast(msg: 'Cannot delete right now');
      return state.copyWith(status: Status.error);
    }, (r) {
      showToast(msg: 'Leave Category Deleted Successfully');
      return state.copyWith(status: Status.success);
    });

    add(FetchLeavesPolicyEvent(employerID: event.employerID));
    emit(tempState);
  }

  _onUpdateLeavePolicyPeriod(
      UpdateLeavePolicyPeriodEvent event, Emitter<LeaveEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final response = await repo.updateLeavePolicyPeriod(
        fromDate: event.fromDate,
        toDate: event.toDate,
        employerID: event.employerID);
    final tempState =
        response.fold((l) => state.copyWith(status: Status.error), (r) {
      showToast(msg: 'Leave Period Updated Successfully');
      return state.copyWith(status: Status.success);
    });

    add(FetchLeavesPolicyEvent(employerID: event.employerID));
    emit(tempState);
  }
}
