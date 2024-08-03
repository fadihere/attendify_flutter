import 'package:attendify_lite/app/features/employer/location/data/models/loc_emr_model.dart';
import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../leave/presentation/widgets/custom_dropdown.dart';

@RoutePage()
class AssignLocationPage extends StatelessWidget {
  final TeamModel team;
  const AssignLocationPage({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign Location',
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: Padding(
        padding: AppSize.overallPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(20),
            BlocBuilder<PickLocationBloc, PickLocationState>(
              builder: (context, state) {
                return Center(
                  child: CustDropDown<LocEmrModel>(
                    margin: 6.0,
                    items: state.locationsList
                        .map(
                          (e) => CustDropdownMenuItem(
                            value: e,
                            child: Text(e.locationName,
                                style: const TextStyle(
                                  fontFamily: 'Hellix',
                                )),
                          ),
                        )
                        .toList(),
                    hintText: "Select Leaves Category",
                    borderRadius: 20,
                    overlayWidth: 0.92.sw,
                    displayStringForItem: (item) => item.locationName,
                    onChanged: (val) {
                      context
                          .read<PickLocationBloc>()
                          .add(SelectLocToAssignEvent(locModel: val!));
                    },
                  ),
                );

                /* DropdownButtonFormField(
                  // value:state.selectedAssignLoc,
                  isExpanded: false,
                  decoration: InputDecoration(
                    fillColor: context.color.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.only(
                      left: 30,
                      right: 20,
                      top: 12,
                      bottom: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(
                        color: context.color.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(
                        color: context.color.outline,
                      ),
                    ),
                  ),
                  hint: const Text('Select Location'),

                  items: state.locationsList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.locationName),
                        ),
                      )
                      .toList(),
                  onChanged: (locModel) {
                    context
                        .read<PickLocationBloc>()
                        .add(SelectLocToAssignEvent(locModel: locModel!));
                  },
                ); */
              },
            ),
            const Gap(20),
            BlocBuilder<PickLocationBloc, PickLocationState>(
              builder: (context, state) {
                return AppButtonWidget(
                  margin: const EdgeInsets.only(top: 15),
                  isLoading: state.status == Status.loading,
                  onTap: () {
                    context.read<PickLocationBloc>().add(
                          UpdateLocEvent(
                            user: team.copyWith(
                              locationId: state.selectedAssignLoc!.locationId
                                  .toString(),
                            ),
                          ),
                        );
                  },
                  text: 'SAVE',
                );
              },
            ),
            const Spacer(),
            AppButtonWidget(
              margin: const EdgeInsets.only(top: 15),
              onTap: () {
                router.push(PlacePicker(apiKey: AppConst.googleAPIKey));
              },
              text: 'ADD NEW LOCATION',
              // color: context.color.primary.withOpacity(0.2),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
