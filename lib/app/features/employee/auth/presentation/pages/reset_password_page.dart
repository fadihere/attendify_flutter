import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/gen/assets.gen.dart';
import '../../../../../../core/utils/res/export.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../widgets/dialogs.dart';

@RoutePage<bool>()
class ResetPasswordEmpPage extends StatelessWidget {
  final String phoneNumber;
  const ResetPasswordEmpPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthEmpBloc, AuthEmpState>(
        listener: (context, state) async {
          if (state.status == Status.success) {
            showAdaptiveDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const PasswordChangedWidget(),
            );
            await Future.delayed(const Duration(seconds: 1));
            router.maybePop();
            router.replaceAll([const SigninEmpRoute()]);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: AppSize.overallPadding,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Gap(20),
                    Assets.icons.changePassword.svg(
                      width: 75.sp,
                      colorFilter: ColorFilter.mode(
                        context.color.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(30),
                    const Center(
                      child: Text(
                        "Reset Your Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(5),
                    Text(
                      AppConstants.resetPasswordDetails,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: context.color.hint,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(25),
                    CustomTextFormField(
                      enableInteractiveSelection: false,
                      controller: passwordController,
                      obscureText: state.isNewPassObscure,
                      // isDense: true,
                      hintText: AppConstants.newPassword,
                      keyboardType: TextInputType.visiblePassword,
                      borderRadius: 25,
                      validator: newPasswordValidator,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context
                                .read<AuthEmpBloc>()
                                .add(ObscureNewPasswordEvent());
                          },
                          icon: state.isNewPassObscure
                              ? Assets.icons.eye.svg(
                                  colorFilter: ColorFilter.mode(
                                  context.color.icon,
                                  BlendMode.srcIn,
                                ))
                              : Assets.icons.crossEye.svg(
                                  colorFilter: ColorFilter.mode(
                                  context.color.icon,
                                  BlendMode.srcIn,
                                ))),
                    ),
                    const Gap(10),
                    CustomTextFormField(
                      enableInteractiveSelection: false,
                      controller: confirmPasswordController,
                      obscureText: state.isConfirmPassObscure,
                      // isDense: true,
                      hintText: AppConstants.confirmPassword,
                      keyboardType: TextInputType.visiblePassword,

                      validator: (value) {
                        return conformPasswordValidator(
                            passwordController.text, value);
                      },
                      borderRadius: 25,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context
                                .read<AuthEmpBloc>()
                                .add(ObscureConfirmPasswordEvent());
                          },
                          icon: state.isConfirmPassObscure
                              ? Assets.icons.eye.svg(
                                  colorFilter: ColorFilter.mode(
                                  context.color.icon,
                                  BlendMode.srcIn,
                                ))
                              : Assets.icons.crossEye.svg(
                                  colorFilter: ColorFilter.mode(
                                  context.color.icon,
                                  BlendMode.srcIn,
                                ))),
                    ),
                    AppButtonWidget(
                      onTap: () {
                        if (!formKey.currentState!.validate()) return;
                        context.read<AuthEmpBloc>().add(
                              ResetPasswordEvent(
                                phoneNumber: phoneNumber.replaceAll(
                                    RegExp(r'[^\w\s]+'), ''),
                                password: passwordController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim(),
                              ),
                            );
                      },
                      borderRadius: 30,
                      text: AppConstants.resetPassword.toUpperCase(),
                      margin: const EdgeInsets.only(top: 20),
                      isLoading: state.status == Status.loading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
