import 'dart:async';

import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../../../core/enums/status.dart';
import '../../../../../../core/gen/assets.gen.dart';
import '../../../../../../core/utils/widgets/buttons.dart';

@RoutePage<bool>()
class VerificationEmpPage extends StatefulWidget {
  final String phoneNumber;
  final String code;
  final int navigationType;

  const VerificationEmpPage(
      {super.key,
      required this.phoneNumber,
      required this.code,
      required this.navigationType});

  @override
  State<VerificationEmpPage> createState() => _VerificationEmpPageState();
}

class _VerificationEmpPageState extends State<VerificationEmpPage> {
  int otpTimer = 90;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  @override
  void initState() {
    context.read<AuthEmpBloc>().add(SetCodeEvent(code: widget.code));
    SmsAutoFill().listenForCode();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer > 0) {
        otpTimer = otpTimer - 1;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Gap(20),
                Assets.icons.verify.svg(
                  colorFilter: ColorFilter.mode(
                    context.color.primary,
                    BlendMode.srcIn,
                  ),
                  width: 75.sp,
                ),
                const Gap(50),
                const Text(
                  AppConstants.verifyYourNumber,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(5),
                Text(
                  '${AppConstants.enterOTPsentTo} ${widget.phoneNumber.replaceRange(6, null, "******")}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.color.disabledColor),
                ),
                const Gap(20),
                PinFieldAutoFill(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: BoxLooseDecoration(
                    strokeColorBuilder: FixedColorBuilder(context.color.hint),
                  ),
                  onCodeChanged: (value) {
                    if (value == null || value.length < 6) {
                      return;
                    }
                    _otpController.text = value.trim();
                    context.read<AuthEmpBloc>().add(
                          VerifyOTPEvent(
                              sentCode: widget.code,
                              recievedCode: value.trim(),
                              phoneNumber: widget.phoneNumber,
                              otpTimer: otpTimer,
                              navigationType: widget.navigationType),
                        );
                  },
                  enableInteractiveSelection: false,
                  codeLength: 6,
                ),
                BlocBuilder<AuthEmpBloc, AuthEmpState>(
                  builder: (context, state) {
                    return AppButtonWidget(
                      isLoading: state.status == Status.loading,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        final auth = context.read<AuthEmpBloc>();
                        auth.add(VerifyOTPEvent(
                          sentCode: widget.code,
                          recievedCode: _otpController.text.trim(),
                          phoneNumber: widget.phoneNumber,
                          otpTimer: otpTimer,
                          navigationType: widget.navigationType,
                        ));
                      },
                      text: AppConstants.verify.toUpperCase(),
                      margin: EdgeInsets.only(top: 15.sp, bottom: 20.sp),
                    );
                  },
                ),
                Text.rich(
                  TextSpan(
                      text: AppConstants.recieveCode,
                      style: TextStyle(
                        color: context.color.hint,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.hellix,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => resend(context),
                          text: AppConstants.resend,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: context.color.primary,
                            fontSize: 14,
                            fontFamily: FontFamily.hellix,
                          ),
                        )
                      ]),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resend(BuildContext context) {
    context
        .read<AuthEmpBloc>()
        .add(ResendCodeEvent(phoneNumber: widget.phoneNumber));
  }
}
