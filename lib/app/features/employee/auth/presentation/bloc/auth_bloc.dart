// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/auth/data/datasources/local_db.dart';
import 'package:attendify_lite/app/features/employee/auth/data/models/login_model.dart';
import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/app/features/employee/auth/data/repositories/emp_auth_repo.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/functions/functions.dart';
import '../../../../../../injection_container.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthEmpBloc extends Bloc<AuthEmpEvent, AuthEmpState> {
  final AuthRepoEmpImpl authRepo;
  final picker = ImagePicker();
  final authLocal = AuthLocalDBEmpImpl(box: sl());

  init() async {
    emit(state.copyWith(countryCode: await getCountryCode()));
    add(CheckUserEvent());
  }

  AuthEmpBloc({required this.authRepo}) : super(const AuthEmpState()) {
    on<ObscurePasswordEvent>((event, emit) {
      emit(state.copyWith(
          obscureText: !state.obscureText, status: Status.initial));
    });
    on<ObscureNewPasswordEvent>((event, emit) {
      log('Calling New Password Obscure');
      emit(state.copyWith(
          isNewPassObscure: !state.isNewPassObscure, status: Status.initial));
    });
    on<ObscureConfirmPasswordEvent>((event, emit) {
      log('Calling Confirm Password Obscure');

      emit(state.copyWith(
          isConfirmPassObscure: !state.isConfirmPassObscure,
          status: Status.initial));
    });
    on<ChangeCountryCodeEvent>((event, emit) {
      emit(state.copyWith(countryCode: event.countryCode));
    });
    on<UserSignInEvent>(_onSignIn);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<ResendCodeEvent>(_onResendCode);
    on<ResetPasswordEvent>(_onPasswordReset);
    on<CheckUserEvent>(_checkUserEvent);
    on<LogoutEvent>(_onLogout);
    on<GetLocationDataEvent>(_onGetLocationData);
    on<PickImageEvent>(_onPickImage);
    on<UploadProfileImageEvent>(_onUploadProfile);
    on<SetCodeEvent>(_onCodeSet);
    on<ChangePhoneEvent>(_onChangePhone);
  }
  _onCodeSet(
    SetCodeEvent event,
    Emitter<AuthEmpState> emit,
  ) {
    // emit(state.copyWith(otpCode: event.code));
    emit(state.copyWith(otpCode: '123456'));
  }

  _onPasswordReset(
    ResetPasswordEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final response =
        await authRepo.resetPassword(event.phoneNumber, event.password);
    final newstate = response.fold<AuthEmpState>(
      (l) => state.copyWith(status: Status.error),
      (r) => state.copyWith(status: Status.success),
    );
    emit(newstate);
  }

  _onResendCode(
    ResendCodeEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    final code = getRandomInt();
    final isMessageSent = await sendTwilioOTPSMS(
      phoneNumber: '+${event.phoneNumber.trim()}',
      otp: code,
    );
    if (isMessageSent) {
      emit(state.copyWith(otpCode: code.toString()));
      showToast(msg: 'OTP Sent');
      return;
    }
    debugPrint('Error Occured While Sending Message');
  }

  _onVerifyOTP(
    VerifyOTPEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    if (event.otpTimer < 90) {
      if (state.otpCode == event.recievedCode) {
        await Future.delayed(const Duration(seconds: 1))
            .then((value) => emit(state.copyWith(status: Status.success)));
        showToast(msg: 'Verification Successful');

        switch (event.navigationType) {
          case 1:
            router.replaceAll([const BaseEmpRoute()]);
            break;
          /*  case 2:
            debugPrint(event.phoneNumber);
            router.popAndPush(
                ResetPasswordEmpRoute(phoneNumber: event.phoneNumber));
            break; */
          case 2:
            await Future.delayed(const Duration(seconds: 1)).then(
                (value) => add(ChangePhoneEvent(phone: event.phoneNumber)));

          default:
            showToast(msg: 'Invalid Case');
        }
        // router.replaceAll([const BaseEmpRoute()]);
        return;
      }
      emit(state.copyWith(status: Status.error));
      showToast(msg: 'Either OTP is invalid or is expired');
    } else {
      showToast(msg: 'OTP Expired');
    }
  }

  _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    final phoneNumber = '${state.countryCode}${event.phoneNumber.trim()}';
    // emit(state.copyWith(status: Status.loading));
    /*  final code = getRandomInt();
    final isMessageSent =
        await sendTwilioOTPSMS(phoneNumber: phoneNumber, otp: code);
    if (isMessageSent) {
      showToast(msg: 'OTP Sent'); */
    emit(state.copyWith(status: Status.success));
    /* final backResponse = await */ router.push(ResetPasswordEmpRoute(
      phoneNumber: phoneNumber, /*  navigationType: 2 */
    ));

    /* if (backResponse ?? false) {
        router.popAndPush(ResetPasswordEmpRoute(phoneNumber: phoneNumber));
      } */
    /*    return;
    }
    debugPrint('Error Occured While Sending Message');
    emit(state.copyWith(status: Status.error)); */
  }

  _onSignIn(
    UserSignInEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final response = await authRepo.signIn(event.phoneNumber, event.password);
    final newstate = response.fold<AuthEmpState>(
      (l) {
        return state.copyWith(status: Status.error);
      },
      (r) {
        _handleNavigation(r, event.phoneNumber);
        return state;
      },
    );
    emit(newstate);
  }

  FutureOr _handleNavigation(
    LoginModel model,
    String phoneNumber,
  ) async {
    if (model.response != 'User Authorized') {
      emit(state.copyWith(
        status: Status.error,
        response: model,
      ));
      return;
    }
    final res = await authRepo.getUserDataPhone(phoneNumber);
    res.fold(
      (fail) {
        emit(state.copyWith(status: Status.error));
      },
      (user) async {
        emit(state.copyWith(user: user));
        final res = await authRepo.saveToken(
            employeeID: user.employeeId, employerID: user.employerId);
        res.fold((l) => log('${l}jafdjasvdfjkv'), (r) => log(r.toString()));
      },
    );
    if (model.count! > 0) {
      emit(state.copyWith(status: Status.success));
      router.replaceAll([const BaseEmpRoute()]);
      return;
    }

    final code = getRandomInt();
    log(" OTP CODE ====> $code");
    final isMessageSent = await sendTwilioOTPSMS(
      phoneNumber: '+${phoneNumber.trim()}',
      otp: code,
    );
    emit(state.copyWith(status: Status.success, otpCode: code.toString()));
    if (isMessageSent) {
      showToast(msg: 'OTP Sent');
      /*  final backResponse = await */ router.push(VerificationEmpRoute(
          phoneNumber: phoneNumber, code: code.toString(), navigationType: 1));
      /* if (backResponse case (null || false)) return;
        router.replaceAll([const BaseEmpRoute()]); */
      // }
    }

    return;
  }

  FutureOr<void> _checkUserEvent(
    CheckUserEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    emit(state.copyWith(countryCode: await getCountryCode()));
    final res = await authRepo.getCurrentUserData();
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
        router.replaceAll([const BaseEmpRoute()]);
      },
    );
  }

  FutureOr<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    await authRepo.logout();
    await authRepo.clearToken(
      employeeID: event.empId,
      employerID: event.emrId,
    );
  }

  FutureOr<void> _onGetLocationData(
    GetLocationDataEvent event,
    Emitter<AuthEmpState> emit,
  ) {}

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    final xFile = await picker.pickImage(source: event.source);
    if (xFile == null) return;
    final image = File(xFile.path);
    final prev = state;
    emit(ShowImageDialogState(newimage: image));
    emit(prev);
  }

  FutureOr<void> _onUploadProfile(
    UploadProfileImageEvent event,
    Emitter<AuthEmpState> emit,
  ) async {
    authRepo.uploadProfileImage(event.newImage, state.user!.employeeId);
    emit(state.copyWith(image: event.newImage));
  }

  _onChangePhone(ChangePhoneEvent event, Emitter<AuthEmpState> emit) async {
    emit(state.copyWith(isPhoneChanged: false, status: Status.loading));
    final updatedPhone = event.phone.replaceAll(RegExp(r'[^\w\s]+'), '');

    final data = await authRepo.changePhone(
        employeeID: state.user!.employeeId,
        newPhone: updatedPhone,
        employerID: state.user!.employersId,
        createdBy: state.user!.employersId);
    data.fold((l) {
      emit(state.copyWith(isPhoneChanged: false, status: Status.error));
      router.popForced();
      showToast(
        msg: 'Can\'t change your phone number right now. Try Again Later',
      );
    }, (r) async {
      if (r) {
        final user = state.user!.copyWith(phoneNumber: updatedPhone);
        authLocal.setCurrentUser(user);

        emit(state.copyWith(
            isPhoneChanged: true, status: Status.success, user: user));

        Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isPhoneChanged: false));
        router.popForced();
        await Future.delayed(const Duration(seconds: 1));

        //  router.maybePop();
        // router.replaceAll([const UserSelectionRoute()]);
        // router.maybePop();

        router.replaceAll([
          const BaseEmpRoute(children: [SettingsEmpRoute()])
        ]);
      } else {
        router.replaceAll([
          const BaseEmpRoute(children: [SettingsEmpRoute()])
        ]);
        showToast(
          msg: 'Can\'t change your phone number right now. Try Again Later',
        );

        emit(state.copyWith(
          status: Status.error,
          isPhoneChanged: false,
        ));
      }
    });
  }
}
