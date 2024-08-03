// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:attendify_lite/app/features/employee/home/data/repositories/home_repo_emp.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

import 'location_state.dart';

part 'location_event.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final location = Location.instance;
  final geocode = geo.GeocodingPlatform.instance;
  final HomeRepoEmpImpl homeRepo;

  LocationBloc({required this.homeRepo}) : super(const LocationState()) {
    on<ReqLocationServiceEvent>(_reqLocationService);
    on<ReqLocationPermissionEvent>(_reqLocationPermission);
    on<FetchLocationEvent>(_fetchLocation);
    on<ReqEmrLocPermissionEvent>(_reqEmrLocPermission);
    on<IsMockLocationEvent>(_onMock);
  }

  _reqLocationService(
    ReqLocationServiceEvent event,
    Emitter<LocationState> emit,
  ) async {
    final isService = await Location.instance.serviceEnabled();

    if (!isService) {
      showToast(msg: 'Enable Location Service');
      final serviceStatus = await location.requestService();

      emit(state.copyWith(isServiceEnabled: serviceStatus));
      /*   if (serviceStatus) {
        
        return;
      }
      emit(state.copyWith(isServiceEnabled: false));
      return; */
    }
    emit(state.copyWith(isServiceEnabled: isService));
  }

  _onMock(
    IsMockLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(isMock: event.isMocked));
    event.isMocked
        ? const SnackBar(content: Text("Mock location is not allowed"))
        : null;
    log("############message:state:isMocked::${state.isMock}");
  }

  _reqLocationPermission(
    ReqLocationPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    PermissionStatus permission = await location.hasPermission();
    final isPermissionDenied = (permission == PermissionStatus.denied);

    if (isPermissionDenied) {
      permission = await location.requestPermission();
      final isGranted = (permission == PermissionStatus.grantedLimited ||
          permission == PermissionStatus.granted);
      emit(state.copyWith(isPermissionEnabled: isGranted));
      add(FetchLocationEvent(locationId: event.locationId));

      return;
    }

    final isPermissionGranted = (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited);
    if (isPermissionGranted) {
      emit(state.copyWith(
        isPermissionEnabled: isPermissionGranted,
      ));
      add(FetchLocationEvent(locationId: event.locationId));
      return;
    }

    final isDeniedForever = (permission == PermissionStatus.deniedForever);

    if (isDeniedForever) {
      debugPrint("Permission Denied forever");
      return;
    }
  }

  _fetchLocation(
    FetchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.granted) {
      emit(state.copyWith(status: Status.loading));
      final isGranted = (permission == PermissionStatus.grantedLimited ||
          permission == PermissionStatus.granted);
      emit(state.copyWith(isPermissionEnabled: isGranted));
      final res =
          await homeRepo.fetchLocationByID(locationID: event.locationId);
      await res.fold(
        (l) async {
          log(l.toString());
          emit(state.copyWith(status: Status.error));
          return false;
        },
        (location1) async {
          final position = await location.getLocation();
          if (position.isMock ?? false) {
            showToast(msg: "Mock location is not allowed");
            emit(state.copyWith(status: Status.error));
          } else {
            final lat1 = position.latitude;
            final lon1 = position.longitude;
            final lat2 = double.parse(location1.latitude!);
            final lon2 = double.parse(location1.longitude!);
            final distance = calculateDistance(lat1, lon1, lat2, lon2);
            final allowRadius =
                double.tryParse(location1.allowedRadius!) ?? 100;
            log(distance.toString());
            if ((distance * 1000) > allowRadius) {
              final placemaker =
                  await geocode?.placemarkFromCoordinates(lat1!, lon1!);
              log(placemaker!.toString());
              emit(state.copyWith(
                current: placemaker.first.name ?? '',
                lat: lat1,
                long: lon1,
                status: Status.success,
                isAtOffice: false,
              ));

              return false;
            }
            emit(state.copyWith(
              current: location1.locationName,
              lat: lat1,
              long: lon1,
              status: Status.success,
              isAtOffice: true,
            ));
            return true;
          }
        },
      );
    } else {
      showToast(msg: "Must allow location");
    }
  }

  _reqEmrLocPermission(
      ReqEmrLocPermissionEvent event, Emitter<LocationState> emit) async {
    PermissionStatus permission = await location.hasPermission();
    final isPermissionDenied = (permission == PermissionStatus.denied);

    if (isPermissionDenied) {
      permission = await location.requestPermission();
      final isGranted = (permission == PermissionStatus.grantedLimited ||
          permission == PermissionStatus.granted);
      emit(state.copyWith(isPermissionEnabled: isGranted));
      return;
    }

    final isPermissionGranted = (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited);
    if (isPermissionGranted) {
      emit(state.copyWith(
        isPermissionEnabled: isPermissionGranted,
      ));
      return;
    }

    final isDeniedForever = (permission == PermissionStatus.deniedForever);

    if (isDeniedForever) {
      debugPrint("Permission Denied forever");
      return;
    }
  }
}
