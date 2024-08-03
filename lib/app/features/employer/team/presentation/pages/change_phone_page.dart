import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/team_bloc/team_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/utils/validators/auth_validators.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../employee/auth/presentation/widgets/others.dart';

@RoutePage()
class ChangeTeamPhonePage extends StatelessWidget {
  final TeamModel team;
  const ChangeTeamPhonePage({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    final phno = removePrefixIfNecessary(team.phoneNumber);
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Change Phone Number',
        style: TextStyle(
          fontFamily: 'Hellix',
        ),
      )),
      body: Padding(
        padding: AppSize.sidePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            CustomTextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              validator: phoneValidator,
              prefixIcon: CodePickerWidget(
                initialValue: '+92',
                onchange: (code) {
                  context.read<TeamBloc>().add(
                        ChangeCountryCodeEvent(countryCode: code),
                      );
                },
              ),
              hintText: phno,
              // hintText: "New Phone Number",
            ),
            // const Gap(10),
            // Text(
            //   'Existing Phone: ${team.phoneNumber}',
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //     fontFamily: 'Hellix',
            //     color: context.color.primary,
            //     fontSize: 10,
            //   ),
            // ),
            const Gap(20),
            BlocBuilder<TeamBloc, TeamState>(
              builder: (context, state) {
                return AppButtonWidget(
                  margin: EdgeInsets.zero,
                  onTap: () async {
                    context.read<TeamBloc>().add(UpdateEmployeePhoneEvent(
                          team: team,
                          phoneNo:
                              '${state.countryCode.replaceAll(RegExp(r'[^\w\s]+'), '')}${controller.text.replaceAll(RegExp(r'^0+(?=.)'), '').trim()}',
                        ));
                  },
                  text: "CHANGE NUMBER",
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String removePrefixIfNecessary(String phoneNumber) {
    if (phoneNumber.startsWith('92')) {
      return phoneNumber.substring(2);
    }
    return phoneNumber;
  }
}
