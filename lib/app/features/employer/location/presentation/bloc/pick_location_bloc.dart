import 'package:attendify_lite/app/features/employer/location/data/repositories/loc_repo_emr.dart';
import 'package:attendify_lite/app/features/employer/place_picker/entities/location_result.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../team/data/models/team_model.dart';
import '../../data/models/loc_emr_model.dart';

part 'pick_location_event.dart';
part 'pick_location_state.dart';

class PickLocationBloc extends Bloc<PickLocationEvent, PickLocationState> {
  final LocRepoEmrImpl locRepo;
  PickLocationBloc({required this.locRepo}) : super(const PickLocationState()) {
    on<FetchAllLocationsEvent>(_onFetchAllLocations);
    on<DeleteLocationEvent>(_deleteLocation);
    on<IncOrDecRadiusEvent>(_onIncOrDecRadius);
    on<SaveLocationEvent>(_onSaveLocation);
    on<SelectLocToAssignEvent>(_onSelectLoc);
    on<UpdateLocEvent>(_onLocationUpdate);
  }

  _onFetchAllLocations(
    FetchAllLocationsEvent event,
    Emitter<PickLocationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final response =
        await locRepo.fetchAllLocations(employerID: event.employerID);

    final locState = response.fold<PickLocationState>(
      (l) => state.copyWith(status: Status.error),
      (r) => state.copyWith(status: Status.success, locationsList: r),
    );
    emit(locState);
  }

  _deleteLocation(
    DeleteLocationEvent event,
    Emitter<PickLocationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final response =
        await locRepo.deleteLocationByID(locationID: event.locationID);

    final locState = response.fold((l) {
      return state.copyWith(status: Status.error);
    }, (r) {
      final list = state.locationsList;

      list.removeWhere(
        (value) => value.locationId == event.locationID,
      );
      return state.copyWith(
        status: Status.success,
        locationsList: list,
      );
    });
    emit(locState);
  }

  _onIncOrDecRadius(
    IncOrDecRadiusEvent event,
    Emitter<PickLocationState> emit,
  ) {
    double radius = state.radius;
    if (event.type == 'increase') {
      radius += 50;
      emit(state.copyWith(radius: radius));
      return;
    }
    if (radius == 50) return;
    radius -= 50;
    emit(state.copyWith(radius: radius));
  }

  _onSaveLocation(
    SaveLocationEvent event,
    Emitter<PickLocationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    if (state.locationsList
        .where((element) => element.locationName == event.locationName)
        .isNotEmpty) {
      showToast(msg: 'Location already exist');
      emit(state.copyWith(status: Status.error));
      return state.copyWith(status: Status.error);
    }
    final response = await locRepo.saveLocation(
        employerID: event.employerID,
        locationResult: event.locationResult,
        radius: state.radius,
        locationName: event.locationName.trim());
    final locState = response.fold<PickLocationState>(
      (l) {
        showToast(msg: 'Cannot add location right now. Try again later');
        return state.copyWith(status: Status.error);
      },
      (r) {
        showToast(msg: 'Location Added Successfully');
        final list = state.locationsList;
        list.add(r);

        return state.copyWith(status: Status.success, locationsList: list);
      },
    );
    emit(locState);
    router.popForced();
    router.popForced();
  }

  _onSelectLoc(
    SelectLocToAssignEvent event,
    Emitter<PickLocationState> emit,
  ) {
    emit(state.copyWith(selectedAssignLoc: event.locModel));
  }

  _onLocationUpdate(
    UpdateLocEvent event,
    Emitter<PickLocationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final res = await locRepo.updateEmployeeLocation(event.user);
    res.fold((l) {
      showToast(msg: 'Cannot Assign Location Right Now');
      emit(state.copyWith(status: Status.error));
    }, (r) {
      showToast(msg: 'Location Assigned Successfully');
      emit(state.copyWith(status: Status.success));
      router.maybePop();
    });
  }
}
