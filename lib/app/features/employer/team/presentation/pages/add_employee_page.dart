import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/team_bloc/team_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/widgets/dialogs.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/utils/validators/auth_validators.dart';
import '../../../../../../core/utils/widgets/textfield_tag_widget.dart';
import '../../../../employee/auth/presentation/widgets/others.dart';
import '../../../location/data/models/loc_emr_model.dart';

@RoutePage()
class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final nameController = TextEditingController();
  final fileController = TextEditingController();
  final codeController = TextEditingController();
  final phoneController = TextEditingController();
  final workspaceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LocEmrModel? location;
  String code = '+92';
  File? image;
  @override
  void dispose() {
    nameController.dispose();
    fileController.dispose();
    phoneController.dispose();
    codeController.dispose();
    workspaceController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teambloc = context.read<TeamBloc>();
    final authBloc = context.read<AuthEmrBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.addEmployee,
          style: TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSize.overallPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                hintText: AppConstants.name,
                controller: nameController,
                validator: nameValidator,
              ),
              const Gap(10),
              CustomTextFormField(
                readOnly: true,
                onTap: () async {
                  await showAdaptiveDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => ProfileImageDailog(
                      firstTap: () async {
                        router.maybePop();
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (file == null) return;
                        setState(() {
                          fileController.text =
                              findSubstringAfterDot(file.path.split('/').last);
                          image = File(file.path);
                        });
                      },
                      secondTap: () async {
                        router.maybePop();
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file == null) return;
                        setState(() {
                          fileController.text =
                              findSubstringAfterDot(file.path.split('/').last);
                          image = File(file.path);
                        });
                      },
                    ),
                  );
                },
                controller: fileController,
                hintText: AppConstants.employeeProfile,
                suffixIcon: const TextFieldTagWidget(
                  tag: AppConstants.profile,
                ),
              ),
              const Gap(10),
              BlocConsumer<TeamBloc, TeamState>(
                listener: (context, state) {
                  if (state.code != null) {
                    codeController.text = '${state.code}';
                  }
                },
                builder: (context, state) {
                  return CustomTextFormField(
                    controller: codeController,
                    readOnly: true,
                    onTap: () {
                      final id = authBloc.state.user!.employerId;
                      teambloc
                          .add(GetEmployeeIdEvent(employerId: int.parse(id)));
                    },
                    hintText: AppConstants.employeeCode,
                    suffixIcon: const TextFieldTagWidget(
                      tag: AppConstants.generate,
                    ),
                  );
                },
              ),
              const Gap(10),
              CustomTextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                validator: phoneValidator,
                prefixIcon: CodePickerWidget(
                  initialValue: '+92',
                  onchange: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                ),
                hintText: AppConstants.phoneNumber,
              ),
              const Gap(10),
              CustomTextFormField(
                controller: workspaceController,
                readOnly: true,
                onTap: () async {
                  await showAdaptiveDialog(
                    useSafeArea: true,
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => LocationDialogWidget(
                      onChange: (loc) {
                        setState(() {
                          location = loc;
                          workspaceController.text = loc.locationName;
                        });
                      },
                    ),
                  );
                },
                hintText: AppConstants.employeeWorkPlace,
                suffixIcon: const TextFieldTagWidget(
                  tag: AppConstants.location,
                ),
              ),
              BlocConsumer<TeamBloc, TeamState>(
                listener: (context, state) {
                  if (state.failure != null && state.status == Status.error) {
                    final error = state
                        .failure?.response?['phone_number']?.first
                        .toString();
                    showToast(
                      msg: (error?[0].toUpperCase())! + error!.substring(1),
                    );
                  }
                  if (state is ShowFaceScanDialog) {
                    _showFaceScanDialog(context, state.team);
                    return;
                  }
                  // if (state.status == Status.loading) {
                  //   BotToast.showLoading();
                  //   return;
                  // }
                  // BotToast.closeAllLoading();
                },
                builder: (context, state) {
                  return AppButtonWidget(
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      if (codeController.text.isEmpty) {
                        showToast(msg: 'Generate employee code.');
                        return;
                      }
                      if (location == null) {
                        showToast(msg: 'Location is not attached.');
                        return;
                      }

                      // if (location == null) return;
                      final phone =
                          '${code.replaceAll(RegExp(r'[^\w\s]+'), '')}${phoneController.text.replaceAll(RegExp(r'^0+(?=.)'), '').trim()}';
                      final user = TeamModel(
                        employerToken: authBloc.state.user!.token,
                        employerId: authBloc.state.user!.employerId,
                        employeeId:
                            '${authBloc.state.user!.employerId}_${codeController.text}',
                        employeeName: nameController.text.trim().capitalize,
                        phoneNumber: phone,
                        createdBy: int.parse(authBloc.state.user!.employerId),
                        createdOn: DateTime.now(),
                        isActive: true,
                        locationId: location!.locationId.toString(),
                        organizationName: authBloc.state.user!.organizationName,
                        jobDesignation: '',
                        imageUrl: '',
                      );

                      teambloc.add(CreateEmployeeEvent(
                        user: user,
                        image: image,
                        location: location!,
                        password: phoneController.text
                            .replaceAll(RegExp(r'^0+(?=.)'), '')
                            .trim(),
                      ));
                      // fileController.clear();
                    },
                    text: 'ADD',
                    margin: const EdgeInsets.only(top: 20),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String findSubstringAfterDot(String input) {
    int dotIndex = input.indexOf('.');
    if (dotIndex != -1 && dotIndex < input.length - 1) {
      String result = input.substring(dotIndex + 1);
      return '${result[0].toUpperCase()}${result.substring(1)} File Selected';
    }
    return '';
  }

  void _showFaceScanDialog(BuildContext context, TeamModel team) async {
    await showAdaptiveDialog(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      builder: (_) => UploadFaceScanWidget(
        onChange: (image) {
          context.read<TeamBloc>().add(RegisterEmployeeFace(
                image: image,
                empId: team.employeeId,
              ));
        },
      ),
    );
  }
}
