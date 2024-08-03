import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/enums/status.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class AdmAddNewLocationPage extends StatefulWidget {
  const AdmAddNewLocationPage({super.key});

  @override
  State<AdmAddNewLocationPage> createState() => _AdmAddNewLocationPageState();
}

class _AdmAddNewLocationPageState extends State<AdmAddNewLocationPage> {
  @override
  void initState() {
    final auth = context.read<AuthEmrBloc>();
    context
        .read<PickLocationBloc>()
        .add(FetchAllLocationsEvent(employerID: auth.state.user!.employerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add New Location"),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          onPressed: () {
            router.push(PlacePicker(apiKey: AppConst.googleAPIKey));
          },
          backgroundColor: context.color.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: AppSize.overallPadding,
          child: BlocBuilder<PickLocationBloc, PickLocationState>(
            builder: (context, state) {
              if (state.status == Status.loading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (state.locationsList.isEmpty) {
                return const Center(child: Text('No Locations To Show'));
              }
              return ListView.builder(
                  itemCount: state.locationsList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            state.locationsList[index].locationName,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerRight,
                            highlightColor: Colors.transparent,
                            splashRadius: 2,
                            onPressed: () {
                              context.read<PickLocationBloc>().add(
                                    DeleteLocationEvent(
                                      locationID:
                                          state.locationsList[index].locationId,
                                    ),
                                  );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            )),
                      ],
                    );
                  });
            },
          ),
        ));
  }
}
