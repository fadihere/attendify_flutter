import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/res/constants.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../employee/auth/presentation/widgets/others.dart';
import '../bloc/auth_bloc.dart';

@RoutePage<bool>()
class SigninEmrPage extends StatefulWidget {
  const SigninEmrPage({super.key});

  @override
  State<SigninEmrPage> createState() => _SigninEmrPageState();
}

class _SigninEmrPageState extends State<SigninEmrPage> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final email = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                const AppLogoWidget(),
                const Gap(60),
                const Text(
                  AppConstants.emrSignIn,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(25),
                CustomTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  validator: emailValidator,
                  hintText: AppConstants.emailAddress,
                ),
                BlocConsumer<AuthEmrBloc, AuthEmrState>(
                  listener: (context, state) {
                    // if (state.status == Status.error) {
                    //   showToast(msg: state.errorMessage);
                    // }
                  },
                  builder: (context, state) {
                    return AppButtonWidget(
                      isLoading: state.status == Status.loading,
                      onTap: () {
                        if (!key.currentState!.validate()) return;
                        final authBloc = context.read<AuthEmrBloc>();
                        authBloc.add(SigninEvent(email: email.text.trim()));
                      },
                      text: AppConstants.signIn,
                      margin: const EdgeInsets.only(top: 18),
                    );
                  },
                ),
                const Gap(15),
                Text.rich(
                  TextSpan(
                    text: 'Note: ',
                    style: TextStyle(
                      color: context.color.font,
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      TextSpan(
                        text: AppConstants.emrSignInNote,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
