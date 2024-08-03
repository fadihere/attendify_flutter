import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/auth/presentation/widgets/dialogs.dart';
import 'package:attendify_lite/app/features/employee/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:attendify_lite/injection_container.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';

@RoutePage()
class ChangePasswordEmpPage extends StatelessWidget {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fromKey = GlobalKey<FormState>();

  ChangePasswordEmpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthEmpBloc>().state.user;
    return BlocProvider(
      create: (context) => sl<SettingsEmpBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConstants.changePassword,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Padding(
          padding: AppSize.overallPadding,
          child: Form(
            key: fromKey,
            child: BlocConsumer<SettingsEmpBloc, SettingsEmpState>(
              listener: (context, state) async {
                if (state.status == Status.success) {
                  showAdaptiveDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const PasswordChangedWidget(),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  router.maybePop();
                  router.replaceAll([
                    const BaseEmpRoute(
                      children: [
                        SettingsEmpRoute(),
                      ],
                    )
                  ]);
                }
              },
              builder: (context, state) {
                final color = ColorFilter.mode(
                  context.color.icon,
                  BlendMode.srcIn,
                );

                return Column(
                  children: [
                    CustomTextFormField(
                      obscureText: state.obscureTextOne,
                      validator: passwordValidator,
                      controller: currentPasswordController,
                      isDense: true,
                      hintText: AppConstants.currentPassword,
                      borderRadius: 25,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context
                                .read<SettingsEmpBloc>()
                                .add(ObscurePasswordOneEvent());
                          },
                          icon: state.obscureTextOne
                              ? Assets.icons.eye.svg(colorFilter: color)
                              : Assets.icons.crossEye.svg(colorFilter: color)),
                    ),
                    const Gap(10),
                    CustomTextFormField(
                      enableInteractiveSelection: false,
                      obscureText: state.obscureTextTwo,
                      validator: (value) =>
                          matchCheckPasswordWithCurrentPasswordValidator(
                        currentPasswordController.text,
                        value,
                      ),
                      controller: newPasswordController,
                      isDense: true,
                      hintText: AppConstants.newPassword,
                      borderRadius: 25,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context
                                .read<SettingsEmpBloc>()
                                .add(ObscurePasswordTwoEvent());
                          },
                          icon: state.obscureTextTwo
                              ? Assets.icons.eye.svg(colorFilter: color)
                              : Assets.icons.crossEye.svg(colorFilter: color)),
                    ),
                    const Gap(10),
                    CustomTextFormField(
                      enableInteractiveSelection: false,
                      obscureText: state.obscureTextThree,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context
                                .read<SettingsEmpBloc>()
                                .add(ObscurePasswordThreeEvent());
                          },
                          icon: state.obscureTextThree
                              ? Assets.icons.eye.svg(colorFilter: color)
                              : Assets.icons.crossEye.svg(colorFilter: color)),
                      validator: (value) =>
                          conformPasswordAndPasswordMatchCheckValidator(
                        currentPasswordController.text,
                        newPasswordController.text,
                        value,
                      ),
                      controller: confirmPasswordController,
                      isDense: true,
                      hintText: AppConstants.confirmPassword,
                      borderRadius: 25,
                    ),
                    AppButtonWidget(
                      isLoading: state.status == Status.loading,
                      onTap: () {
                        if (fromKey.currentState!.validate()) {
                          context
                              .read<SettingsEmpBloc>()
                              .add(ChangePasswordEvent(
                                phoneNumber: user!.phoneNumber,
                                currentPassword:
                                    currentPasswordController.text.trim(),
                                newPassword: newPasswordController.text.trim(),
                              ));
                        }
                      },
                      borderRadius: 30,
                      text: AppConstants.changePassword.toUpperCase(),
                      margin: const EdgeInsets.only(top: 20),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
