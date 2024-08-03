// ignore_for_file: library_prefixes

import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart'
    as auth_Bloc;
import 'package:attendify_lite/app/features/employee/auth/presentation/widgets/dialogs.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/functions/functions.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../injection_container.dart';
import '../../../auth/presentation/widgets/others.dart';
import '../bloc/settings_bloc.dart';

@RoutePage<bool>()
class ChangePhoneNumPage extends StatelessWidget {
  final TextEditingController currentNumberController = TextEditingController();
  final TextEditingController newNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ChangePhoneNumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<auth_Bloc.AuthEmpBloc>().state.user;
    return BlocProvider(
      create: (context) => sl<SettingsEmpBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppConstants.changePhoneNumber)),
        body: Padding(
          padding: AppSize.overallPadding,
          child: Form(
              key: formKey,
              child: BlocBuilder<SettingsEmpBloc, SettingsEmpState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomTextFormField(
                        keyboardType: TextInputType.number,
                        controller: currentNumberController,
                        isDense: true,
                        hintText: AppConstants.currentNumber,
                        borderRadius: 25,
                        validator: (value) {
                          return oldPhoneValidator(
                            value:
                                '${state.firstCode.replaceAll(RegExp(r'[^\w\s]+'), '')}${value!.replaceAll(RegExp(r'^0+(?=.)'), '')}',
                            currentPhone: user!.phoneNumber,
                          );
                        },
                        prefixIcon: CodePickerWidget(
                          initialValue: state.firstCode,
                          onchange: (code) {
                            context
                                .read<SettingsEmpBloc>()
                                .add(ChangeCountryCodeEvent(firstCode: code));
                          },
                        ),
                      ),
                      const Gap(10),
                      CustomTextFormField(
                        keyboardType: TextInputType.number,
                        controller: newNumberController,
                        isDense: true,
                        validator: (value) {
                          return newPhoneValidator(
                            value: value,
                            oldPhone: user!.phoneNumber,
                          );
                        },
                        hintText: AppConstants.newNumber,
                        borderRadius: 25,
                        prefixIcon: CodePickerWidget(
                          initialValue: state.secondCode,
                          onchange: (code) {
                            context
                                .read<SettingsEmpBloc>()
                                .add(ChangeCountryCodeEvent(secondCode: code));
                          },
                        ),
                      ),
                      const Gap(10),
                      BlocConsumer<auth_Bloc.AuthEmpBloc,
                          auth_Bloc.AuthEmpState>(
                        listener: (context, state) async {
                          if (state.isPhoneChanged) {
                            await showAdaptiveDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const PhoneChangedWidget(),
                            );
                          }
                        },
                        builder: (context, state) {
                          return BlocBuilder<SettingsEmpBloc, SettingsEmpState>(
                            builder: (context, state) {
                              return AppButtonWidget(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    final code = getRandomInt();
                                    context.read<auth_Bloc.AuthEmpBloc>().add(
                                        auth_Bloc.SetCodeEvent(
                                            code: code.toString()));
                                    context.read<SettingsEmpBloc>().add(
                                          UploadNewNumberEvent(
                                            newPhone:
                                                '${state.secondCode}${newNumberController.text.replaceAll(RegExp(r'^0+(?=.)'), '').trim()}',
                                            code: code,
                                          ),
                                        );
                                  }
                                },
                                borderRadius: 30,
                                isLoading: state.status == Status.loading,
                                text: AppConstants.changeNumber,
                                margin: const EdgeInsets.only(top: 20),
                              );
                            },
                          );
                        },
                      )
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
