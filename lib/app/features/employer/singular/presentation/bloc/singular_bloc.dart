// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/home/data/models/check_out_model.dart';
import 'package:attendify_lite/app/features/employer/singular/data/repositories/singular_repo.dart';
import 'package:attendify_lite/core/bloc/location_bloc/location_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
import 'package:ntp/ntp.dart';

import '../../../../../../core/utils/fcm_helper.dart';
import '../../../../../shared/datasource/noti_remote_db.dart';
import '../../../../employee/home/data/models/check_in_model.dart';
import '../../../../employee/home/data/repositories/home_repo_emp.dart';

part 'singular_event.dart';
part 'singular_state.dart';

class SingularBloc extends Bloc<SingularEvent, SingularState> {
  final SingularRepoImpl singularRepo;
  final HomeRepoEmpImpl homeRepo;
  final LocationBloc locationBloc;

  SingularBloc({
    required this.singularRepo,
    required this.homeRepo,
    required this.locationBloc,
  }) : super(const SingularState()) {
    on<AddSetup1Event>(_onPin1Add);
    on<ClearPin1Event>(_onClearPin1);
    on<AddSetup2Event>(_onPin2Add);
    on<ClearPin2Event>(_onClearPin2);
    on<AddSetup3Event>(_onPin3Add);
    on<ClearPin3Event>(_onClearPin3);
    on<OpenFaceDialogEvent>(_onOpenFaceDialog);
    on<CheckUserAndClock>(_onCheckAndClock);
  }

  FutureOr<void> _onPin1Add(
    AddSetup1Event event,
    Emitter<SingularState> emit,
  ) {
    String pin = state.pin;
    if (pin.length < 4) {
      pin += event.pin.toString();
      emit(state.copyWith(pin: pin));
    }
    if (pin.length == 4) {
      router.push(SetupPin2Route(title: "Confirm PIN"));
    }
  }

  FutureOr<void> _onClearPin1(
      ClearPin1Event event, Emitter<SingularState> emit) {
    if (state.pin.isNotEmpty) {
      String pin = state.pin;
      pin = pin.substring(0, pin.length - 1);
      emit(state.copyWith(pin: pin));
    }
  }

  FutureOr<void> _onPin2Add(
    AddSetup2Event event,
    Emitter<SingularState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    String cpin = state.confirmPin;
    if (cpin.length < 4) {
      cpin += event.pin.toString();
      emit(state.copyWith(confirmPin: cpin));
    }
    if (cpin.length == 4 && cpin != state.pin) {
      emit(state.copyWith(status: Status.error, confirmPin: cpin));
    }
    if (cpin == state.pin) {
      singularRepo.setPin(cpin);
      router.replaceAll([const CheckInRoute()]);
    }
  }

  FutureOr<void> _onClearPin2(
    ClearPin2Event event,
    Emitter<SingularState> emit,
  ) {
    String pin = state.confirmPin;
    pin = pin.substring(0, pin.length - 1);
    emit(state.copyWith(confirmPin: pin));
  }

  FutureOr<void> _onPin3Add(
    AddSetup3Event event,
    Emitter<SingularState> emit,
  ) async {
    emit(state.copyWith(status: Status.initial));
    String epin = state.exitPin;
    final dbPin = await singularRepo.getPin();
    if (epin.length < 4) {
      epin += event.pin.toString();
      emit(state.copyWith(exitPin: epin));
    }
    if (epin.length == 4 && epin != dbPin) {
      emit(state.copyWith(status: Status.error, exitPin: epin));
    }
    if (epin == dbPin) {
      singularRepo.clearPin();
      router.replaceAll([const BaseEmrRoute()]);
    }
  }

  FutureOr<void> _onClearPin3(
    ClearPin3Event event,
    Emitter<SingularState> emit,
  ) async {
    if (state.exitPin.isNotEmpty) {
      String pin = state.exitPin;
      pin = pin.substring(0, pin.length - 1);
      emit(state.copyWith(exitPin: pin));
    }
  }

  FutureOr<void> _onOpenFaceDialog(
    OpenFaceDialogEvent event,
    Emitter<SingularState> emit,
  ) {
    final prevState = state;
    emit(FaceDialogState());
    emit(prevState);
  }

  FutureOr<void> _onCheckAndClock(
    CheckUserAndClock event,
    Emitter<SingularState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final user = await singularRepo.getEmployee(event.file.path, event.emrId);
    final userModel = await user.fold((l) async => null, (r) async => r);
    if (userModel == null) {
      showToast(msg: "User not Exist");
      emit(state.copyWith(status: Status.initial));
      return;
    }
    final lastIn = await homeRepo.lastCheckIn(
      employerID: event.emrId,
      employeeID: userModel.employeeId,
    );
    final lastInModel = lastIn.fold((l) => null, (r) => r);
    final isClockedIn = lastInModel != null &&
        lastInModel.recordedTimeIn != null &&
        lastInModel.recordedTimeOut == null;
    final time = await NTP.now();
    if (isClockedIn) {
      final clockOut = CheckOutModel(
        recordedTimeOut: time,
        employerId: userModel.employerId,
        employeesId: userModel.employeeId,
        outLatitude: locationBloc.state.lat.toString(),
        outLocationId: userModel.locationId,
        outLongitude: locationBloc.state.long.toString(),
        employeeId: userModel.employeeId,
        shiftTimeOut: time,
      );
      final clockOutRes =
          await homeRepo.clockOut(checkout: clockOut, lastIn: lastInModel);
      clockOutRes.fold(
        (l) {
          emit(state.copyWith(status: Status.error));
          showToast(msg: "Something went wrong");
          return;
        },
        (r) {
          final prev = state;
          emit(ClockedOutDialogState());
          emit(prev.copyWith(status: Status.success));
          return;
        },
      );
      return;
    }
    final clockIn = CheckInModel(
      recordedTimeIn: time,
      employerId: userModel.employerId,
      employeesId: userModel.employeeId,
      attendanceChoices: 'PRS',
      inLatitude: locationBloc.state.lat.toString(),
      inLocationId: userModel.locationId,
      inLongitude: locationBloc.state.long.toString(),
    );

    final clockInRes = await homeRepo.clockIn(checkInModel: clockIn);
    clockInRes.fold(
      (l) {
        emit(state.copyWith(status: Status.error));
        showToast(msg: "Something went wrong");
        return;
      },
      (r) {
        final prev = state;
        emit(ClockedInDialogState());
        emit(prev.copyWith(status: Status.success));
        final difference =
            clockIn.recordedTimeIn?.differenceInMinutes(DateTime.now());
        if (difference! > 15) {
          NotiRemoteDB.sendNotificationAPI(
              title: 'Late Arrival',
              subTitle: '${userModel.employeeName} has arrived late today',
              employeeID: userModel.employeeId,
              employerID: userModel.employerId,
              notificationType: "Late Arrival");

          if (userModel.token.isNotEmpty) {
            FCMHelper.sendNotification(userModel.token, 'Late Arrival',
                '${userModel.employeeName} has arrived late today', 'employer');
          }
        }
        return;
      },
    );
  }
}
