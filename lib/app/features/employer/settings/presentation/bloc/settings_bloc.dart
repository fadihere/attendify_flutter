// ignore_for_file: unused_field, unused_local_variable

import 'dart:developer';

import 'package:attendify_lite/app/features/employer/settings/data/models/work_hrs_model.dart';
import 'package:attendify_lite/app/features/employer/settings/data/repositories/settings_repositories_emr.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/config/routes/app_router.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsEmrBloc extends Bloc<SettingsEmrEvent, SettingsEmrState> {
  final SettingRepoEmrImpl settingRepoEmr;

  SettingsEmrBloc({required this.settingRepoEmr})
      : super(const SettingsEmrState()) {
    on<SettingsEmrEvent>((event, emit) {});
    // on<UpdateStartOfficeHrsEvent>(_updateStartOfficeHrs);
    on<UpdateOfficeHrsEvent>(_updateOfficeHrs);
    // on<UpdateGraceOfficeHrsEvent>(_updateGraceOfficeHrs);
    // on<UpdateOfficeWeekdaysEvent>(_updateOfficeWeekdays);
    on<FetchOfficeHrsEvent>(_fetchOfficeHrs);
    on<DeleteEmployerEvent>(_onDeleteEmployer);
  }

  _fetchOfficeHrs(
    FetchOfficeHrsEvent event,
    Emitter<SettingsEmrState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    emit(state.copyWith(status: Status.loading));
    log(event.employerID);

    final response = await settingRepoEmr.settingFetchOfficeHrs(
      employerID: event.employerID,
    );
    final newstate = response.fold<SettingsEmrState>(
      (l) => state.copyWith(status: Status.error, loading: false),
      (r) => state.copyWith(
          status: Status.success, officeHrsModel: r, loading: false),
    );
    emit(newstate);
  }

  _updateOfficeHrs(
    UpdateOfficeHrsEvent event,
    Emitter<SettingsEmrState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    emit(state.copyWith(loading: true));
    log(event.employerID);

    final response = await settingRepoEmr.settingUpdateOfficeHrs(
      employerID: event.employerID,
      model: event.workHrsModel,
    );
    response.fold(
        (l) => emit(state.copyWith(status: Status.error, loading: false)), (r) {
      router.maybePop();
      emit(
        state.copyWith(
            status: Status.success, officeHrsModel: r, loading: false),
      );
    });
  }

  _onDeleteEmployer(
    DeleteEmployerEvent event,
    Emitter<SettingsEmrState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    log(event.employerID);

    final res = await settingRepoEmr.deleteEmployer(
      employerID: event.employerID,
    );
    final settingState = res.fold<SettingsEmrState>((l) {
      showToast(msg: 'Cannot delete right now. Try again later');
      return state.copyWith(status: Status.error);
    }, (r) {
      showToast(msg: 'Organization Deleted Successfully');
      return state.copyWith(status: Status.success);
    });
    emit(settingState);
    router.popAndPush(const UserSelectionRoute());
  }
}
