import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/res/constants.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../place_picker/entities/location_result.dart';
import '../bloc/pick_location_bloc.dart';

class ConfirmationDaialog extends StatelessWidget {
  final LocationResult result;
  final String radius;
  final UserEmrModel user;
  const ConfirmationDaialog(
      {super.key,
      required this.result,
      required this.radius,
      required this.user});

  @override
  Widget build(BuildContext context) {
    TextEditingController locationNameController =
        TextEditingController(text: result.name ?? "");
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocConsumer<PickLocationBloc, PickLocationState>(
        listener: (context, state) {
          if (state.status == Status.error) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        builder: (context, state) => Container(
          padding: EdgeInsets.all(20.r),
          height: 1.sh * 0.28,
          width: 1.sw,
          child: Column(
            children: [
              const Text(
                "Add Location Name",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(20),
              CustomTextFormField(
                hintText: "Add Address",
                controller: locationNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location name';
                  }
                  return null;
                },
              ),
              const Gap(10),
              AppButtonWidget(
                onTap: () {
                  if (locationNameController.text.isEmpty) {
                    showToast(msg: 'Location name is required');
                    return;
                  }
                  context.read<PickLocationBloc>().add(
                        SaveLocationEvent(
                            locationName: locationNameController.text,
                            employerID: user.employerId,
                            locationResult: result),
                      );
                },
                margin: const EdgeInsets.symmetric(vertical: 10),
                text: AppConstants.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
