import 'package:attendify_lite/app/features/employer/team/data/repositories/team_repo.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/config/routes/app_router.dart';
import '../../../../settings/data/models/work_hrs_model.dart';
import '../../../data/models/team_model.dart';

part 'work_time_event.dart';
part 'work_time_state.dart';

class WorkTimeBloc extends Bloc<WorkTimeEvent, WorkTimeState> {
  TeamRepoImpl teamRepo;
  WorkTimeBloc({required this.teamRepo}) : super(const WorkTimeState()) {
    on<FetchEmpWorkHoursEvent>(_fetchWorkHours);
    on<UpdateEmpHrsEvent>(_onUpdateEmpWorkingHrs);
    on<PostEmpWorkHrsEvent>(_onPostEmpWorkingHrs);
  }

  _fetchWorkHours(
      FetchEmpWorkHoursEvent event, Emitter<WorkTimeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final response = await teamRepo.fetchEmployeeWorkHours(event.team);
    final teamState = response.fold<WorkTimeState>(
        (l) => state.copyWith(status: Status.error, workHrs: null),
        (r) => state.copyWith(status: Status.success, workHrs: r));
    emit(teamState);
  }

  _onUpdateEmpWorkingHrs(
      UpdateEmpHrsEvent event, Emitter<WorkTimeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final response = await teamRepo.updateEmployeeWorkHours(
      user: event.team,
      workHrs: event.workHrs,
    );
    final newstate = response.fold<WorkTimeState>(
      (l) {
        return state.copyWith(
          status: Status.error,
        );
      },
      (r) => state.copyWith(
        status: Status.success,
        workHrs: r,
      ),
    );
    emit(newstate);
    router.popForced();
  }

  _onPostEmpWorkingHrs(
      PostEmpWorkHrsEvent event, Emitter<WorkTimeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final response = await teamRepo.postEmployeeWorkHours(
      user: event.team,
      workHrs: event.workHrs,
    );
    final newstate = response.fold<WorkTimeState>(
      (l) {
        return state.copyWith(
          status: Status.error,
          workHrs: null,
        );
      },
      (r) => state.copyWith(
        status: Status.success,
        workHrs: r,
      ),
    );
    emit(newstate);
    router.popForced();
  }
}
