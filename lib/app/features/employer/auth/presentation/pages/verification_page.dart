import 'dart:async';

import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/res/constants.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../bloc/auth_bloc.dart';

@RoutePage<bool>()
class VerificationEmrPage extends StatefulWidget {
  final String email;
  final String code;
  final int navigationType;
  final String? employerID;

  const VerificationEmrPage({
    super.key,
    required this.email,
    required this.code,
    required this.navigationType,
    this.employerID,
  });

  @override
  State<VerificationEmrPage> createState() => _VerificationEmrPageState();
}

class _VerificationEmrPageState extends State<VerificationEmrPage> {
  int otpTimer = 90;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  @override
  void initState() {
    context.read<AuthEmrBloc>().add(SetCodeEvent(otp: widget.code));
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
      appBar: AppBar(
        title: const Text(
          AppConstants.verifyYourEmail,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.hellix,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Please enter the code sent to\n your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.color.hintColor,
                    fontSize: 18,
                  ),
                ),
                const Gap(30),
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
                    context.read<AuthEmrBloc>().add(
                          VerifyOTPEmrEvent(
                            code: widget.code,
                            incomingCode: _otpController.text,
                            currentTime: otpTimer,
                            navigationType: widget.navigationType,
                            email: widget.email,
                            employerID: widget.employerID,
                          ),
                        );
                    // context.read<AuthBloc>().add();
                  },
                  enableInteractiveSelection: false,
                  codeLength: 6,
                ),
                const Gap(12),
                BlocBuilder<AuthEmrBloc, AuthEmrState>(
                  builder: (context, state) {
                    return AppButtonWidget(
                      isLoading: state.status == Status.loading,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;

                        context.read<AuthEmrBloc>().add(
                              VerifyOTPEmrEvent(
                                code: widget.code,
                                incomingCode: _otpController.text,
                                currentTime: otpTimer,
                                navigationType: widget.navigationType,
                                email: widget.email,
                                employerID: widget.employerID,
                              ),
                            );
                      },
                      text: AppConstants.verify.toUpperCase(),
                      margin: EdgeInsets.only(top: 15.sp, bottom: 20.sp),
                    );
                  },
                ),
                Text.rich(
                  TextSpan(
                      text: AppConstants.recieveCode,
                      style: TextStyle(color: context.color.hint),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              otpTimer = 90;
                              resend(context);
                              setState(() {});
                            },
                          text: AppConstants.resend,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: context.color.primary,
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

  void resend(
    BuildContext context,
  ) {
    context.read<AuthEmrBloc>().add(ResendCodeEvent(email: widget.email));
  }
}
