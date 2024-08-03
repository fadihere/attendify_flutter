import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/validators/auth_validators.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:attendify_lite/core/utils/widgets/textfield_tag_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../employee/settings/presentation/widgets/dialogs.dart';

@RoutePage()
class AddOrganizationPage extends StatelessWidget {
  final nameController = TextEditingController();
  final String email;
  final _formKey = GlobalKey<FormState>();
  AddOrganizationPage({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.yourOrganization,
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: BlocConsumer<AuthEmrBloc, AuthEmrState>(
        listener: (context, state) {
          if (state is ShowImageDialogState) {
            _imageDialog(context, state);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: AppSize.overallPadding,
              child: Column(
                children: [
                  SizedBox(
                    width: 250.r,
                    child: const Text(
                      AppConstants.organizationPageDesc,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(20),
                  CustomTextFormField(
                    controller: TextEditingController(
                      text: state.image?.path.split('/').last,
                    ),
                    readOnly: true,
                    onTap: () {
                      context.read<AuthEmrBloc>().add(PickImageEvent());
                    },
                    hintText: AppConstants.addLogo,
                    suffixIcon: const TextFieldTagWidget(tag: 'Select'),
                  ),
                  const Gap(10),
                  CustomTextFormField(
                    controller: nameController,
                    hintText: AppConstants.organizationName,
                    validator: nameValidator,
                  ),
                  AppButtonWidget(
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<AuthEmrBloc>().add(
                            CreateOrgEvent(
                              name: nameController.text,
                              email: email,
                            ),
                          );
                    },
                    isLoading: state.status == Status.loading,
                    text: AppConstants.save.toUpperCase(),
                    margin: const EdgeInsets.only(top: 30),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _imageDialog(
    BuildContext context,
    ShowImageDialogState state,
  ) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => ImageDialogWidget(
        onPressed: () {
          final authBloc = context.read<AuthEmrBloc>();
          authBloc.add(SetLogoEvent(state.newimage));
        },
        image: state.newimage,
      ),
    );
  }
}
