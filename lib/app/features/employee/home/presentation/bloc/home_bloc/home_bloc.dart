import 'dart:developer';

import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/last_in_res.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/location_model.dart';
import 'package:attendify_lite/app/features/employee/home/data/repositories/home_repo_emp.dart';
import 'package:attendify_lite/core/constants/app_colors.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/error/failures.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:m7_livelyness_detection/index.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../core/utils/fcm_helper.dart';
import '../../../../../../shared/datasource/noti_remote_db.dart';
import '../../../../auth/data/models/user_emp_model.dart';
import '../../../data/models/check_in_model.dart';
import '../../../data/models/check_out_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepoEmpImpl remoteRepo;
  HomeBloc({required this.remoteRepo}) : super(const HomeState()) {
    on<InitLivelynessDetectionEvent>(_onInit);
    on<FetchLastTransactionEvent>(_onLastTransactionEvent);
    on<OpenFaceDialogEvent>(_openFaceDialog);
    on<_OpenWFHDialogEvent>(_openWFHDialog);
    on<FetchLocationByIDEvent>(_onFetchLocationByID);
    on<ClockedEvent>(_clockedEvent);
    on<LocationPermissionEvent>(_onLocPermission);
    on<ShowNotificationEvent>(_showNotification);

    on<CheckUserOfficeorHomeEvent>(_checkUserOfficeOrHome);
    on<CheckInternetEvent>(_onInternetCheck);
  }

  _onInit(
    InitLivelynessDetectionEvent event,
    Emitter<HomeState> emit,
  ) {
    final m7 = M7LivelynessDetection.instance;
    m7.configure(
      thresholds: [M7BlinkDetectionThreshold()],
      contourColor: LightColors.primary.withOpacity(0.5),
    );
    emit(state.copyWith(isApproved: state.lastInModel?.requestApproved));
  }

  _onLastTransactionEvent(
    FetchLastTransactionEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final res = await remoteRepo.lastCheckIn(
      employeeID: event.user.employeeId,
      employerID: event.user.employerId,
    );

    res.fold(
      (l) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: 'Error Occured. Try Again Later',
        ));
      },
      (lastIn) {
        // print("state${state.isApproved}");
        emit(state.copyWith(status: Status.success));

        emit(state.copyWith(
          lastInModel: lastIn,
          checkIn: lastIn.recordedTimeIn != null
              ? DateFormat('hh : mm').format(lastIn.recordedTimeIn!)
              : "00 : 00",
          checkOut: lastIn.recordedTimeOut != null
              ? DateFormat('hh : mm').format(lastIn.recordedTimeOut!)
              : "00 : 00",
          totalHours: getTotalHours(
            inTime: lastIn.recordedTimeIn,
            outTime: lastIn.recordedTimeOut,
          ),
          isApproved: lastIn.requestApproved,
        ));
      },
    );
  }

  _openFaceDialog(
    OpenFaceDialogEvent event,
    Emitter<HomeState> emit,
  ) async {
    final prevState = state;
    emit(FaceDialogState());
    emit(prevState);
  }

  _onLocPermission(
    LocationPermissionEvent event,
    Emitter<HomeState> emit,
  ) async {
    final location = loc.Location.instance;
    final locServiceStatus = await location.serviceEnabled();
    final locPermisisonStatus = await location.hasPermission();

    if (!locServiceStatus) {
      final locStatus = await location.requestService();
      if (!locStatus) {
        showToast(msg: 'Enable Location Service');
        emit(state.copyWith(
            isLocPermissionEnabled: false,
            locMessage: 'Location Service is not enabled'));
        return;
      }
      if (locPermisisonStatus == loc.PermissionStatus.denied) {
        final permStatus = await location.requestPermission();
        if (permStatus == loc.PermissionStatus.denied ||
            permStatus == loc.PermissionStatus.deniedForever) {
          emit(state.copyWith(
              isLocPermissionEnabled: false,
              locMessage: "Location Permission Denied"));
          openAppSettings();
          return;
        }
        emit(state.copyWith(
          isLocPermissionEnabled: true,
        ));
        add(FetchLocationByIDEvent(id: event.locationId));
        return;
      }
      openAppSettings();

      return;
    }
    if (locPermisisonStatus == loc.PermissionStatus.denied ||
        locPermisisonStatus == loc.PermissionStatus.deniedForever) {
      final permStatus = await location.requestPermission();
      if (permStatus == loc.PermissionStatus.denied ||
          permStatus == loc.PermissionStatus.deniedForever) {
        emit(state.copyWith(
            isLocPermissionEnabled: false,
            locMessage: "Location Permission Denied"));
        openAppSettings();
        return;
      }
      emit(state.copyWith(
        isLocPermissionEnabled: true,
      ));
      add(FetchLocationByIDEvent(id: event.locationId));
      return;
    }
    emit(state.copyWith(
      isLocPermissionEnabled: true,
    ));
    add(FetchLocationByIDEvent(id: event.locationId));
  }

  _onFetchLocationByID(
      FetchLocationByIDEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isFetchingLocation: Status.loading));
    await Future.delayed(const Duration(seconds: 2));
    final position = await Geolocator.getCurrentPosition();
    log("CHECKING LOCATION IS MOCK  ${position.isMocked.toString()}");

    if (position.isMocked) {
      emit(
        state.copyWith(
            isFetchingLocation: Status.error,
            locMessage: "Mock location is not allowed",
            isLocPermissionEnabled: state.isLocPermissionEnabled,
            isAtOffice: false,
            isMock: true),
      );

      return;
    }
    emit(
      state.copyWith(
          isFetchingLocation: Status.loading, locMessage: null, isMock: false),
    );

    final res = await remoteRepo.fetchLocationByID(locationID: event.id);
    await res.fold(
      (l) async {
        // log(l.toString());
        emit(state.copyWith(
            isFetchingLocation: Status.error,
            isLocPermissionEnabled: state.isLocPermissionEnabled,
            locMessage: "Error Fetching Location"));
        return false;
      },
      (location1) async {
        final lat1 = position.latitude;
        final lon1 = position.longitude;
        final lat2 = double.parse(location1.latitude!);
        final lon2 = double.parse(location1.longitude!);
        final distance = calculateDistance(lat1, lon1, lat2, lon2);
        final allowRadius = double.tryParse(location1.allowedRadius!) ?? 100;

        log(distance.toString());
        if ((distance * 1000) > allowRadius) {
          final placemaker = await geocode.placemarkFromCoordinates(lat1, lon1);
          log(placemaker.toString());
          emit(state.copyWith(
              currentLocName: placemaker.first.name ?? '',
              currentLat: lat1,
              currentLong: lon1,
              isFetchingLocation: Status.success,
              isAtOffice: false,
              isLocPermissionEnabled: state.isLocPermissionEnabled));
          return;
        }
        emit(state.copyWith(
            currentLocName: location1.locationName,
            currentLat: lat1,
            currentLong: lon1,
            isFetchingLocation: Status.success,
            isAtOffice: true,
            isLocPermissionEnabled: state.isLocPermissionEnabled));
      },
    );
  }

  _clockedEvent(
    ClockedEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      status: Status.loading,
    ));

    final inTime = await NTP.now();
    final res = await remoteRepo.verifyFaceScan(
      id: event.user.employeeId,
      file: event.file,
    );
    final isSuccess = res.fold<bool>(
      (fail) {
        showToast(msg: '${fail.response?['status']}');
        emit(state.copyWith(status: Status.error));
        return false;
      },
      (r) {
        emit(state.copyWith(status: Status.success));
        return true;
      },
    );
    if (!isSuccess) return;
    if (event.isClockedIn) {
      final checkOut = CheckOutModel(
        recordedTimeOut: inTime,
        shiftTimeOut: inTime,
        employerId: event.user.employerId,
        employeesId: event.user.employeeId,
        employeeId: event.user.employeeId,
        outLatitude: event.lat.toString(),
        outLongitude: event.lon.toString(),
        outLocationId:
            event.lastIn.attendanceStatus == 'WFH' ? 0 : event.user.locationId,
      );
      emit(state.copyWith(status: Status.loading));
      final clockout = await remoteRepo.clockOut(
        checkout: checkOut,
        lastIn: event.lastIn,
      );

      clockout.fold(
        (fail) {
          if (fail is TimeoutFailure) {
            emit(state.copyWith(status: Status.error));
            showToast(msg: fail.errorMessage);
            return;
          }
          emit(state.copyWith(status: Status.error));
          showToast(msg: 'Something went wrong!');
        },
        (model) {
          emit(state.copyWith(status: Status.success));
          final prev = state;
          emit(ClockedOutDialogState());

          prev.copyWith(
            isClockedOut: true,
            isApproved: null,
          );
          // flutterBackgroundService.invoke('stopService');
          emit(prev);
          add(FetchLastTransactionEvent(user: event.user));
        },
      );

      return;
    }

    if (!event.isAtOffice) {
      final checkin = CheckInModel(
        recordedTimeIn: inTime,
        employerId: event.user.employerId,
        employeesId: event.user.employeeId,
        attendanceChoices: 'WFH',
        inLatitude: event.lat.toString(),
        inLocationId: 0,
        inLongitude: event.lon.toString(),
      );
      final res = await remoteRepo.requestWFH(checkInModel: checkin);
      res.fold(
        (fail) {
          if (fail is TimeoutFailure) {
            emit(state.copyWith(status: Status.error));
            showToast(msg: fail.errorMessage);
            return;
          }
          emit(state.copyWith(status: Status.error));
        },
        (r) async {
          log("TRANSACTION MODEL ====> ${r.toMap().toString()}");
          final prev = state;
          emit(ClockedInDialogState());
          emit(prev.copyWith(status: Status.success));
          add(FetchLastTransactionEvent(user: event.user));

          /*  await initializeBackgroundService();
          flutterBackgroundService.invoke('data', {
            'userModel': event.user,
            'homeLat': event.lat,
            'homeLong': event.lon
          }); */
          log("TRANSACTION ID =======> ${r.id}");
          NotiRemoteDB.sendNotificationAPI(
            title: 'Work From Home Request',
            subTitle:
                '${event.user.employeeName} has requested to do work from home',
            employeeID: event.user.employeeId,
            employerID: event.user.employerId,
            attendanceID: r.id,
            notificationType: "WFH",
          );
          if (event.user.employerToken.isNotEmpty) {
            FCMHelper.sendNotification(
              event.user.employerToken,
              'Work From Home Request',
              '${event.user.employeeName} has requested to do work from home',
              'employer',
            );
          }
        },
      );
      return;
    }

    final checkin = CheckInModel(
      recordedTimeIn: inTime,
      employerId: event.user.employerId,
      employeesId: event.user.employeeId,
      attendanceChoices: 'PRS',
      inLatitude: event.lat.toString(),
      inLocationId: event.user.locationId,
      inLongitude: event.lon.toString(),
    );
    // log("CHECK IN MODEL ====> ${checkin.toJson().toString()}");

    final clockin = await remoteRepo.clockIn(checkInModel: checkin);
    clockin.fold(
      (fail) {
        if (fail is TimeoutFailure) {
          emit(state.copyWith(status: Status.error));
          showToast(msg: fail.errorMessage);
          return;
        }
        showToast(msg: 'Something went wrong!');
      },
      (model) {
        log("CHECK IN REPONSE ====> ${model.toString()}");
        final prev = state;
        emit(ClockedInDialogState());
        emit(prev);
        final difference =
            checkin.recordedTimeIn?.differenceInMinutes(DateTime.now());
        log(difference.toString());
        if (difference! > 30) {
          NotiRemoteDB.sendNotificationAPI(
              title: 'Late Arrival',
              subTitle: '${event.user.employeeName} has arrived late today',
              employeeID: event.user.employeeId,
              employerID: event.user.employerId,
              notificationType: "Late Arrival");

          if (event.user.employerToken.isNotEmpty) {
            FCMHelper.sendNotification(
                event.user.employerToken,
                'Late Arrival',
                '${event.user.employeeName} has arrived late today',
                'employer');
          }
        }

        add(FetchLastTransactionEvent(user: event.user));
      },
    );
  }

  _checkUserOfficeOrHome(
    CheckUserOfficeorHomeEvent event,
    Emitter<HomeState> emit,
  ) {
    if (event.isAtOffice) {
      add(OpenFaceDialogEvent(isAtOffice: event.isAtOffice));
      return;
    }
    add(_OpenWFHDialogEvent());
    return;

    // add(_OpenWFHDialogEvent());
  }

  _openWFHDialog(
    _OpenWFHDialogEvent event,
    Emitter<HomeState> emit,
  ) {
    final prevState = state;
    emit(WFHDialogState());
    emit(prevState);
  }

  _onInternetCheck(CheckInternetEvent event, Emitter<HomeState> emit) async {
    final internetStatus = await checkInternetConnectivity();
    // print("internetStatus$internetStatus");
    emit(state.copyWith(
        isConnected: internetStatus,
        errorMessage: internetStatus ? "" : "No Internet Connection"));
  }

  _showNotification(ShowNotificationEvent event, Emitter<HomeState> emit) {
    // log("NOTIFICATION STATUS BLOC ====> ${event.status.toString()}");
    emit(state.copyWith(showNotification: event.status));
    // log("NOTIFICATION STATUS STATE BLOC ====> ${state.showNotification.toString()}");
  }
}
