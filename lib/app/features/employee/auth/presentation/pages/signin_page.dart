import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/enums/status.dart';
import '../widgets/others.dart';

@RoutePage<bool>()
class SigninEmpPage extends StatefulWidget {
  const SigninEmpPage({super.key});

  @override
  State<SigninEmpPage> createState() => _SigninEmpPageState();
}

class _SigninEmpPageState extends State<SigninEmpPage> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final numberController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Form(
            key: key,
            child: BlocConsumer<AuthEmpBloc, AuthEmpState>(
              listener: (context, state) {
                if (state.status == Status.error) {
                  showToast(msg: state.response?.response);
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(30),
                    const AppLogoWidget(),
                    const Gap(60),
                    const Text(
                      AppConstants.empSignIn,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(25),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberController,
                      validator: (value) => phoneValidator(value),
                      prefixIcon: CodePickerWidget(
                        initialValue: state.countryCode,
                        onchange: (code) {
                          context.read<AuthEmpBloc>().add(
                                ChangeCountryCodeEvent(countryCode: code),
                              );
                        },
                      ),
                      hintText: AppConstants.phoneNumber,
                    ),
                    const Gap(10),
                    CustomTextFormField(
                      enableInteractiveSelection: false,
                      controller: passwordController,
                      obscureText: state.obscureText,
                      validator: passwordValidator,
                      hintText: AppConstants.enterPasswordHint,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            context
                                .read<AuthEmpBloc>()
                                .add(ObscurePasswordEvent());
                          },
                          icon: state.obscureText
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
                    const Gap(12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          router.push(const ForgotPasswordEmpRoute());
                        },
                        child: Text(
                          AppConstants.forgot,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.color.primary,
                          ),
                        ),
                      ),
                    ),
                    AppButtonWidget(
                      isLoading: state.status == Status.loading,
                      onTap: () {
                        if (!key.currentState!.validate()) return;
                        context.read<AuthEmpBloc>().add(
                              UserSignInEvent(
                                phoneNumber:
                                    '${state.countryCode.replaceAll(RegExp(r'[^\w\s]+'), '')}${numberController.text.replaceAll(RegExp(r'^0+(?=.)'), '').trim()}',
                                password: passwordController.text.trim(),
                              ),
                            );
                      },
                      text: AppConstants.signIn.toUpperCase(),
                      margin: const EdgeInsets.only(top: 30),
                    ),
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
