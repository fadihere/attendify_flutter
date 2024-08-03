// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/auth/data/repositories/emr_auth_repo.dart';
import 'package:attendify_lite/app/features/employer/settings/data/repositories/settings_repositories_emr.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/fcm_helper.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../injection_container.dart';
import '../../../singular/data/datasources/singular_local.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthEmrBloc extends Bloc<AuthEmrEvent, AuthEmrState> {
  final AuthRepoEmrImpl auth;
  final SingularLocalImpl singularLocal;

  final imagePicker = ImagePicker();
  AuthEmrBloc({
    required this.auth,
    required this.singularLocal,
  }) : super(const AuthEmrState()) {
    on<SigninEvent>(_onSignin);
    on<VerifyOTPEmrEvent>(_onVerifyCode);
    on<ResendCodeEvent>(_onResendCode);
    on<PickImageEvent>(_onImagePick);
    on<CreateOrgEvent>(_onCreateOrg);
    on<CheckUserEvent>(_onCheckUser);
    on<LogoutEvent>(_onLogout);
    on<UploadProfileImageEvent>(_onUploadProfile);
    on<SetLogoEvent>(_onSetLogo);
    on<ChangeEmailEvent>(_emailChange);
    on<SetCodeEvent>(_onSetCode);
    on<SaveTokenEvent>(_onSaveToken);
    on<PostOfficeHoursEvent>(_onOfficeHoursPost);
    on<SetIntervalEvent>(_onSetInterval);
    on<UpdateIntervalEvent>(_onUpdateInterval);
  }

  void init() => add(CheckUserEvent());

  _onSignin(SigninEvent event, Emitter<AuthEmrState> emit) async {
    if (event.email == AppConst.demoEmployer) {
      emit(state.copyWith(status: Status.loading));
      final response = await auth.signIn(email: event.email);
      response.fold(
        (l) => emit(state.copyWith(
          status: Status.error,
          errorMessage: l.toString(),
        )),
        (user) {
          emit(state.copyWith(
            status: Status.success,
            user: user,
          ));
          router.replaceAll([const BaseEmrRoute()]);
        },
      );
      return;
    }
    final code = getRandomInt();
    log(code.toString());
    emit(state.copyWith(status: Status.loading, otpCode: code.toString()));
    final otpResponse = await auth.sendOTP(
      email: event.email,
      code: code.toString(),
    );

    final isSuccess = otpResponse.fold<bool>(
      (l) {
        debugPrint('OTP sending failed. Try again later');
        emit(state.copyWith(status: Status.error));

        return false;
      },
      (r) {
        emit(state.copyWith(status: Status.success));
        return true;
      },
    );
    if (isSuccess) {
      showToast(msg: 'OTP Sent');
      router.push<bool>(
        VerificationEmrRoute(
          email: event.email,
          code: code.toString(),
          navigationType: 1,
        ),
      );
    }
  }

  _onVerifyCode(VerifyOTPEmrEvent event, Emitter<AuthEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));
    if (event.currentTime > 0 && event.currentTime < 90) {
      log(state.otpCode);
      log(event.incomingCode);

      if (state.otpCode == event.incomingCode) {
        await Future.delayed(const Duration(seconds: 1));

        emit(state.copyWith(status: Status.initial));
        switch (event.navigationType) {
          case 1:
            emit(state.copyWith(status: Status.loading));
            final response = await auth.signIn(email: event.email);
            final value = response.fold<bool>(
              (l) {
                emit(state.copyWith(status: Status.error));
                return false;
              },
              (user) {
                emit(state.copyWith(status: Status.success, user: user));

                showToast(msg: 'Verified');
                Future.delayed(const Duration(seconds: 1))
                    .then((value) => router.replaceAll([const BaseEmrRoute()]));
                return true;
              },
            );
            if (!value) {
              router.push(AddOrganizationRoute(email: event.email));
            }
            break;
          case 2:
            final res = await auth.updateEmail(event.email, event.employerID!);
            res.fold(
              (l) {
                if (l.response?.entries.first.value[0].isNotEmpty) {
                  showToast(msg: l.response?.entries.first.value[0]);
                  return;
                }

                showToast(msg: 'Cannot Change Email Right Now ');
                emit(state.copyWith(status: Status.error));
              },
              (r) async {
                final user = state.user?.copyWith(emailAddress: event.email);
                emit(state.copyWith(user: user, status: Status.success));

                await Future.delayed(const Duration(seconds: 1));

                router.maybePop();
                router.replaceAll([
                  const BaseEmrRoute(children: [AdmSettingsRoute()])
                ]);
              },
            );

          default:
            showToast(msg: 'Invalid Navigation Type');
        }

        return;
      }
      emit(state.copyWith(status: Status.error));
      showToast(msg: 'OTP not matched');

      return;
    }
    emit(state.copyWith(status: Status.error));
    showToast(msg: 'OTP has expired');

    return;
  }

  _onResendCode(ResendCodeEvent event, Emitter<AuthEmrState> emit) async {
    emit(state.copyWith(otpCode: ''));
    final code = getRandomInt();
    debugPrint(code.toString());
    final otpResponse =
        await auth.sendOTP(email: event.email, code: code.toString());

    otpResponse.fold(
      (l) {
        debugPrint('OTP sending failed. Try again later');
      },
      (r) async {
        if (r.isNotEmpty) {
          emit(state.copyWith(otpCode: code.toString()));
          showToast(msg: 'OTP Sent Again');
        }
      },
    );
  }

  _onImagePick(PickImageEvent event, Emitter<AuthEmrState> emit) async {
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    final prev = state;
    if (file != null) {
      emit(ShowImageDialogState(newimage: File(file.path)));
      emit(prev);
      return;
    }
  }

  _onCreateOrg(CreateOrgEvent event, Emitter<AuthEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final lastIDRes = await auth.getLastEmrID();
    final employerID = lastIDRes.fold<int?>((l) => null, (r) => r);

    if (employerID == null) {
      return;
    }

    final res = await auth.createNewEmployer(
      employerID: '${employerID + 1}',
      name: event.name,
      email: event.email,
      file: state.image,
    );

    final isSuccess = res.fold<bool>(
      (l) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: '${l.response!['email_address'][0]}',
        ));
        return false;
      },
      (r) {
        emit(state.copyWith(status: Status.success));
        return true;
      },
    );
    if (!isSuccess) return;
    final response = await auth.signIn(email: event.email);
    response.fold<bool>(
      (l) {
        emit(state.copyWith(status: Status.error));
        return false;
      },
      (user) {
        add(SaveTokenEvent(employerID: '${employerID + 1}'));
        add(PostOfficeHoursEvent(employerID: '${employerID + 1}'));
        emit(state.copyWith(status: Status.success, user: user));
        router.replaceAll([const BaseEmrRoute()]);
        return true;
      },
    );
  }

  FutureOr<void> _onCheckUser(
    CheckUserEvent event,
    Emitter<AuthEmrState> emit,
  ) async {
    final res = await auth.getCurrentUser();
    res.fold(
      (fail) {
        emit(state);
        router.replaceAll([const UserSelectionRoute()]);
      },
      (user) {
        emit(state.copyWith(
          status: Status.success,
          user: user,
        ));
        try {
          singularLocal.getPin();
          router.replaceAll([const CheckInRoute()]);
          return;
        } catch (_) {}
        router.replaceAll([const BaseEmrRoute()]);
      },
    );
  }

  FutureOr<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthEmrState> emit,
  ) async {
    await auth.logout();
    await auth.authRemote.resetToken(employerID: event.employerID);
  }

  FutureOr<void> _onUploadProfile(
    UploadProfileImageEvent event,
    Emitter<AuthEmrState> emit,
  ) async {
    auth.uploadProfileImage(event.newimage, state.user!);
    emit(state.copyWith(image: event.newimage));
  }

  FutureOr<void> _onSetLogo(
    SetLogoEvent event,
    Emitter<AuthEmrState> emit,
  ) async {
    // auth.uploadProfileImage(event.newimage, state.user!);
    emit(state.copyWith(image: event.newimage));
  }

  FutureOr<void> _emailChange(
      ChangeEmailEvent event, Emitter<AuthEmrState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final code = getRandomInt();
    debugPrint(code.toString());
    emit(state.copyWith(otpCode: code.toString()));
    final otpResponse = await auth.sendOTP(
      email: event.newEmail,
      code: code.toString(),
    );

    final isSuccess = otpResponse.fold<bool>(
      (l) {
        debugPrint('OTP sending failed. Try again later');
        emit(state.copyWith(status: Status.error));
        return false;
      },
      (r) {
        emit(state.copyWith(status: Status.initial));

        return true;
      },
    );

    if (isSuccess) {
      showToast(msg: 'OTP Sent');
      await router.push<bool>(
        VerificationEmrRoute(
          email: event.newEmail,
          code: code.toString(),
          navigationType: 2,
          employerID: event.employerID,
        ),
      );
    }
  }

  FutureOr<void> _onSetCode(SetCodeEvent event, Emitter<AuthEmrState> emit) {
    emit(state.copyWith(otpCode: event.otp));
  }

  FutureOr<void> _onSaveToken(
      SaveTokenEvent event, Emitter<AuthEmrState> emit) async {
    await auth.saveToken(employerID: event.employerID);
  }

  _onOfficeHoursPost(
      PostOfficeHoursEvent event, Emitter<AuthEmrState> emit) async {
    const TimeOfDay startTime = TimeOfDay(hour: 09, minute: 0);
    const TimeOfDay endTime = TimeOfDay(hour: 18, minute: 0);
    const TimeOfDay gracePeriod = TimeOfDay(hour: 9, minute: 15);

    final response = await SettingRepoEmrImpl(
            settingRemoteDBEmrImpl: sl(), networkInfo: sl())
        .settingPostOfficeHrs(
      employerID: event.employerID,
      startTime: startTime,
      endTime: endTime,
      gracePeriod: gracePeriod,
      workingDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
    );
    response.fold(
      (l) => log('failure'),
      (r) => log('success'),
    );
  }

  _onSetInterval(
    SetIntervalEvent event,
    Emitter<AuthEmrState> emit,
  ) {
    emit(state.copyWith(interval: event.interval));
  }

  _onUpdateInterval(
    UpdateIntervalEvent event,
    Emitter<AuthEmrState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final response = await SettingRepoEmrImpl(
            settingRemoteDBEmrImpl: sl(), networkInfo: sl())
        .setIntervalForAttendanceCheck(
      user: event.user,
      interval: event.user.intervalValue,
    );
    response.fold((l) => emit(state.copyWith(status: Status.error)), (r) {
      log(event.user.toJson().toString());
      emit(state.copyWith(status: Status.success, user: event.user));

      FCMHelper.sendNotificationToAllEmployee(
          'Interval', 'Testing Notification', 'interval');
      router.popForced();
    });
  }
}
