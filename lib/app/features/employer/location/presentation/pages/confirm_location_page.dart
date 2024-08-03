// ignore_for_file: must_be_immutable

import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/app/features/employer/place_picker/entities/location_result.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/confirmation_dailog.dart';

@RoutePage()
class ConfirmLocationPage extends StatefulWidget {
  LocationResult? locationResult;
  ConfirmLocationPage({super.key, this.locationResult});

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: widget.locationResult?.name);
    final user = context.read<AuthEmrBloc>().state.user;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.transparent,
        leadingWidth: 35.0.w,
        title: CustomTextFormField(
          readOnly: true,
          /*  suffixIcon: IconButton(
              highlightColor: Colors.transparent,
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.close_rounded)), */
          controller: controller,
          //prefixIcon: const Icon(Icons.search),
          hintText: AppConst.searchlocationhere,
        ),
      ),
      body: BlocBuilder<PickLocationBloc, PickLocationState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                layoutDirection: TextDirection.ltr,
                mapType: MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: widget.locationResult != null
                      ? widget.locationResult!.latLng!
                      : const LatLng(31.4612693, 74.4213638),
                  zoom: 16,
                ),
                onCameraMove: null,
                circles: {
                  Circle(
                    circleId: const CircleId("circle_1"),
                    center: widget.locationResult != null
                        ? widget.locationResult!.latLng!
                        : const LatLng(31.4612693, 74.4213638),
                    radius: state.radius,
                    fillColor: Colors.blue.withOpacity(0.4),
                    strokeWidth: 2,
                    strokeColor: Colors.transparent,
                  ),
                },
              ),
              Positioned(
                bottom: height * 0.2,
                right: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<PickLocationBloc>()
                            .add(IncOrDecRadiusEvent(type: 'increase'));
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                      padding: EdgeInsets.zero,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          context.color.whiteBlack,
                        ),
                        shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<PickLocationBloc>().add(
                              IncOrDecRadiusEvent(type: 'decrease'),
                            );
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                      padding: EdgeInsets.zero,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          context.color.whiteBlack,
                        ),
                        shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 40.h,
        ),
        child: BlocBuilder<PickLocationBloc, PickLocationState>(
          builder: (context, state) {
            return AppButtonWidget(
              onTap: () {
                showAdaptiveDialog(
                    context: context,
                    builder: (_) => ConfirmationDaialog(
                          result: widget.locationResult!,
                          radius: state.radius.toString(),
                          user: user!,
                        ));
              },
              subText: "+ ",
              text: 'CONFIRM LOCATION',
              isLoading: state.status == Status.loading,
            );
          },
        ),
      ),
    );
  }
}
