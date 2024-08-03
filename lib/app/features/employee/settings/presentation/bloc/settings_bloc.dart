import 'dart:async';

import 'package:attendify_lite/app/features/employee/auth/data/repositories/emp_auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/functions/functions.dart';
import '../../../../../../injection_container.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsEmpBloc extends Bloc<SettingsEmpEvent, SettingsEmpState> {
  AuthRepoEmpImpl authRepo = sl();

  // Settign
  SettingsEmpBloc() : super(const SettingsEmpState()) {
    on<ChangeCountryCodeEvent>(_changeCountryCode);
    on<UploadNewNumberEvent>(_onChangePhone);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ObscurePasswordOneEvent>((event, emit) {
      emit(state.copyWith(
        obscureTextOne: !state.obscureTextOne,
      ));
    });
    on<ObscurePasswordTwoEvent>((event, emit) {
      emit(state.copyWith(
        obscureTextTwo: !state.obscureTextTwo,
      ));
    });
    on<ObscurePasswordThreeEvent>((event, emit) {
      emit(state.copyWith(
        obscureTextThree: !state.obscureTextThree,
      ));
    });
  }

  FutureOr<void> _changeCountryCode(
    ChangeCountryCodeEvent event,
    Emitter<SettingsEmpState> emit,
  ) {
    emit(state.copyWith(
      firstCode: event.firstCode,
      secondCode: event.secondCode,
    ));
  }

  FutureOr<void> _onChangePhone(
      UploadNewNumberEvent event, Emitter<SettingsEmpState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final isMessageSent = await sendTwilioOTPSMS(
        phoneNumber: event.newPhone.trim(), otp: event.code);
    if (isMessageSent) {
      emit(state.copyWith(
        status: Status.success,
      ));
      showToast(msg: 'OTP Sent');
      // emit(state.copyWith(status: Status.success));
      router.push<bool>(VerificationEmpRoute(
          code: event.code.toString(),
          phoneNumber: event.newPhone.trim(),
          navigationType: 2));

      return;
    }
    showToast(
      msg: 'Error occured while sending OTP',
    );
    emit(state.copyWith(status: Status.error));
    router.popForced();
  }

  FutureOr<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<SettingsEmpState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final response = await authRepo.changePassword(
      phoneNumber: event.phoneNumber,
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    response.fold(
        (l) => emit(state.copyWith(
              status: Status.error,
            )), (r) {
      if (r == 'User Authorized') {
        emit(state.copyWith(
          status: Status.success,
        ));
      }
      if (r == 'incorrect Password') {
        emit(state.copyWith(
          status: Status.error,
        ));
        showToast(
          msg: 'Incorrect Password',
        );
      }
      if (r!.isEmpty) {
        showToast(
          msg: 'Can\'t change your password right now. Try Agian Later',
        );
        router.replaceAll([
          const BaseEmpRoute(children: [SettingsEmpRoute()])
        ]);
        emit(state.copyWith(
          status: Status.error,
        ));
      }
    });
  }
}
