import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/gen/assets.gen.dart';
import '../../../../../../core/utils/res/export.dart';
import '../../../../../../core/utils/validators/auth_validators.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/others.dart';

@RoutePage<bool>()
class ForgotPasswordEmpPage extends StatelessWidget {
  const ForgotPasswordEmpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final numberController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Form(
            key: formKey,
            child: BlocBuilder<AuthEmpBloc, AuthEmpState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const Gap(20),
                    Assets.icons.forgot.svg(
                      width: 75.sp,
                      colorFilter: ColorFilter.mode(
                        context.color.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(40),
                    const Center(
                      child: Text(
                        AppConstants.forgotPassword,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(5),
                    Text(
                      AppConstants.enterRegisterMobile,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.color.hint,
                      ),
                    ),
                    const Gap(15),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      controller: numberController,
                      validator: phoneValidator,
                      prefixIcon: CodePickerWidget(
                        initialValue: state.countryCode,
                        onchange: (code) {
                          context.read<AuthEmpBloc>().add(
                                ChangeCountryCodeEvent(countryCode: code),
                              );
                        },
                      ),
                      hintText: "Phone Number",
                    ),
                    BlocBuilder<AuthEmpBloc, AuthEmpState>(
                      builder: (context, state) {
                        return AppButtonWidget(
                          isLoading: state.status == Status.loading,
                          onTap: () async {
                            if (!formKey.currentState!.validate()) return;
                            context.read<AuthEmpBloc>().add(ForgotPasswordEvent(
                                  phoneNumber: numberController.text
                                      .replaceAll(RegExp(r'^0+(?=.)'), ''),
                                ));
                          },
                          borderRadius: 30,
                          text: AppConstants.continueText,
                          margin: EdgeInsets.only(top: 20.sp),
                        );
                      },
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
