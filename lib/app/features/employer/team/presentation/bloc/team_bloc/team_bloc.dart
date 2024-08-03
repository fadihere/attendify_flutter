import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/location/data/models/loc_emr_model.dart';
import 'package:attendify_lite/app/features/employer/team/data/repositories/team_repo.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/error/failures.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/team_model.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepoImpl teamRepo;
  final UserEmrModel user;

  TeamBloc({
    required this.teamRepo,
    required this.user,
  }) : super(const TeamState()) {
    on<GetMyTeamEvent>(_getmyteam);
    on<GetActiveTeamEvent>(_getActiveteam);
    on<GetDeactiveTeamEvent>(_getDeactiveteam);
    on<SearchTeamEvent>(_searchteam);
    on<ArchiveTeamEvent>(_archiveteam);
    on<DeleteEmployeeEvent>(_deleteEmployee);
    on<CreateEmployeeEvent>(_createEmployee);
    on<RegisterEmployeeFace>(_registerEmployeeFace);
    on<GetEmployeeIdEvent>(_getEmployeeId);
    on<UpdateEmployeePhoneEvent>(_updateEmployeePhone);
    on<UpdateEmployeeFace>(_onUpdateEmployeeFace);
    on<ChangeCountryCodeEvent>((event, emit) {
      emit(state.copyWith(countryCode: event.countryCode));
    });
  }

  FutureOr<void> _getmyteam(
    GetMyTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    final res = await teamRepo.getmyTeams(event.user);
    res.fold(
      (l) {
        log(l.response!.toString());
      },
      (team) {
        final activeTeam = team.where((e) => e.isActive ?? false);
        final deactiveTeam = team.where((e) => !(e.isActive ?? false));

        emit(state.copyWith(
            myteam: List.of(team),
            activeteam: List.of(activeTeam),
            deactiveteam: List.of(deactiveTeam)));
      },
    );
  }

  FutureOr<void> _getActiveteam(
    GetActiveTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(isActive: true));
  }

  FutureOr<void> _getDeactiveteam(
    GetDeactiveTeamEvent event,
    Emitter<TeamState> emit,
  ) {
    emit(state.copyWith(
      isActive: false,
    ));
  }

  FutureOr<void> _searchteam(
    SearchTeamEvent event,
    Emitter<TeamState> emit,
  ) {
    final result = state.myteam
        .where((e) =>
            e.employeeName.toLowerCase().contains(event.text.toLowerCase()))
        .toList();
    emit(state.copyWith(activeteam: List.of(result)));
    emit(state.copyWith(deactiveteam: List.of(result)));
  }

  FutureOr<void> _archiveteam(
    ArchiveTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final res = await teamRepo.achiveTeam(event.user, event.team, event.action);
    res.fold<bool>(
      (l) {
        emit(state.copyWith(status: Status.error));
        return false;
      },
      (r) {
        emit(state.copyWith(status: Status.success));

        add(GetMyTeamEvent(user: event.user));

        if (event.action) {
          add(GetActiveTeamEvent());
        } else {
          add(GetDeactiveTeamEvent());
        }
        return true;
      },
    );
  }

  FutureOr<void> _createEmployee(
    CreateEmployeeEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final res = await teamRepo.createEmployee(
      event.user,
      event.image,
      event.password,
    );
    final team = res.fold<TeamModel?>(
      (fail) {
        emit(state.copyWith(status: Status.error, failure: fail));
        return null;
      },
      (team) {
        emit(state.copyWith(status: Status.success, failure: null));

        return team;
      },
    );
    if (team != null) {
      final prev = state;
      emit(ShowFaceScanDialog(team));
      add(GetMyTeamEvent(user: user));

      emit(prev);
    }
  }

  FutureOr<void> _getEmployeeId(
    GetEmployeeIdEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final res = await teamRepo.getEmployeeId(event.employerId);

    res.fold((l) {
      emit(state.copyWith(status: Status.error));
    }, (code) {
      emit(state.copyWith(status: Status.success, code: code));
    });
  }

  FutureOr<void> _deleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final res = await teamRepo.deleteEmployee(event.team);
    res.fold(
      (l) {
        add(GetMyTeamEvent(user: event.user));
        add(GetDeactiveTeamEvent());
        emit(state.copyWith(status: Status.error));
      },
      (r) {
        add(GetMyTeamEvent(user: event.user));
        add(GetDeactiveTeamEvent());
        emit(state.copyWith(status: Status.success));
      },
    );
  }

  FutureOr<void> _updateEmployeePhone(
    UpdateEmployeePhoneEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    if (event.phoneNo == event.team.phoneNumber) {
      showToast(msg: 'Already using same phone number');
      emit(state.copyWith(status: Status.initial));
      return;
    }
    final res =
        await teamRepo.updateEmployeePhone(event.team, event.phoneNo, user);
    res.fold(
      (l) {
        showToast(msg: l.response?['message']);
        emit(state.copyWith(status: Status.error));
      },
      (r) {
        log(r.toString());
        emit(state.copyWith(status: Status.success));
        showToast(msg: 'Employee Phone Updated Successfully');
        add(GetMyTeamEvent(user: user));
        router.maybePop();
      },
    );
  }

  FutureOr<void> _registerEmployeeFace(
    RegisterEmployeeFace event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final res = await teamRepo.registerEmployeeFace(event.image, event.empId);
    res.fold(
      (l) {
        emit(state.copyWith(status: Status.error));
      },
      (r) {
        emit(state.copyWith(status: Status.success));
        showToast(msg: "Account Created");
        router.maybePop();
      },
    );
  }

  FutureOr<void> _onUpdateEmployeeFace(
    UpdateEmployeeFace event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final res = await teamRepo.registerEmployeeFace(
      event.image,
      event.team.employeeId,
    );
    final teamState = res.fold<TeamState>((l) {
      showToast(msg: 'Cannot update face right now');
      return state.copyWith(status: Status.error);
    }, (r) {
      showToast(msg: 'Employee Face updated Successfully');
      return state.copyWith(status: Status.success);
    });
    emit(teamState);
  }
}
