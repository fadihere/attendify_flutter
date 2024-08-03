// ignore_for_file: library_prefixes

import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/presentation/widgets/dialogs.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../bloc/settings_bloc.dart';

@RoutePage<bool>()
class ChangeEmailPage extends StatelessWidget {
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ChangeEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthEmrBloc>().state.user;
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.changeEmail)),
      body: Padding(
        padding: AppSize.overallPadding,
        child: Form(
            key: formKey,
            child: BlocBuilder<SettingsEmrBloc, SettingsEmrState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Gap(30),
                    CustomTextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: currentEmailController,
                      isDense: true,
                      validator: (value) {
                        return oldEmailValidator(value, user!.emailAddress);
                      },
                      hintText: AppConstants.currentEmail,
                      borderRadius: 25,
                    ),
                    const Gap(10),
                    CustomTextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: newEmailController,
                      isDense: true,
                      hintText: AppConstants.newEmail,
                      borderRadius: 25,
                      validator: (value) {
                        return newEmailValidator(value, user!.emailAddress);
                      },
                    ),
                    const Gap(10),
                    BlocConsumer<AuthEmrBloc, AuthEmrState>(
                      listener: (context, state) async {
                        if (state.status == Status.success) {
                          await showAdaptiveDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const EmailChangedWidget(),
                          );
                          
                        }
                      },
                      builder: (context, state) {
                        return AppButtonWidget(
                          isLoading: state.status == Status.loading,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthEmrBloc>().add(ChangeEmailEvent(
                                  newEmail: newEmailController.text.trim(),
                                  employerID: state.user!.employerId));
                            }
                          },
                          borderRadius: 30,
                          text: AppConstants.changeEmail.toUpperCase(),
                          margin: const EdgeInsets.only(top: 20),
                        );
                      },
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
