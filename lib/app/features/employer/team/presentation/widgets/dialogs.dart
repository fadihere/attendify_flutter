import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../employee/home/presentation/bloc/camera_bloc/camera_bloc.dart';
import '../../../location/data/models/loc_emr_model.dart';

class ProfileImageDailog extends StatelessWidget {
  final VoidCallback firstTap;
  final VoidCallback secondTap;

  const ProfileImageDailog({
    super.key,
    required this.firstTap,
    required this.secondTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20.r),
        height: 261.sp,
        width: 327.sp,
        child: Column(
          children: [
            Text(
              AppConstants.profilePicture,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(10),
            const Text(
              AppConstants.profileDialogDesc,
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            AppButtonWidget(
              onTap: firstTap,
              margin: const EdgeInsets.symmetric(vertical: 10),
              text: AppConstants.takePhoto,
              textColor: context.color.primary,
              color: context.color.primary.withOpacity(
                0.2,
              ),
            ),
            AppButtonWidget(
              onTap: secondTap,
              margin: EdgeInsets.zero,
              text: AppConstants.choosePhoto,
              color: context.color.primary,
            )
          ],
        ),
      ),
    );
  }
}

class LocationDialogWidget extends StatefulWidget {
  final Function(LocEmrModel) onChange;
  const LocationDialogWidget({super.key, required this.onChange});

  @override
  State<LocationDialogWidget> createState() => _LocationDialogWidgetState();
}

class _LocationDialogWidgetState extends State<LocationDialogWidget> {
  int? seletedIndex;

  @override
  void initState() {
    final authBloc = context.read<AuthEmrBloc>();
    context.read<PickLocationBloc>().add(
        FetchAllLocationsEvent(employerID: authBloc.state.user!.employerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: AppSize.sidePadding,
        child: SizedBox(
          height: 441.sp,
          // margin: AppSize.overallPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2.r,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppConstants.selectLocation,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                      splashRadius: 1,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        router.maybePop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 20.r,
                        color: context.color.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 16,
                endIndent: 16,
                height: 0,
                color: context.color.divider,
              ),
              SizedBox(
                height: 10.r,
              ),
              Expanded(
                child: BlocBuilder<PickLocationBloc, PickLocationState>(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return Center(
                          child: Loader(
                        color: context.color.primary,
                      ));
                    }
                    if (state.locationsList.isEmpty) {
                      return const Center(child: Text('No Locations To Show'));
                    }
                    return ListView.builder(
                      itemCount: state.locationsList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final location = state.locationsList[index];
                        return LocationTile(
                          title: location.locationName,
                          isSelected: seletedIndex == index,
                          onChange: (value) {
                            setState(() {
                              seletedIndex = index;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const Gap(20),
              AppButtonWidget(
                onTap: () {
                  router.push(const AdmAddNewLocationRoute());
                },
                margin: AppSize.sidePadding,
                text: AppConstants.addLocation,
                textColor: context.color.primary,
                color: context.color.primary.withOpacity(
                  0.2,
                ),
              ),
              const Gap(10),
              BlocBuilder<PickLocationBloc, PickLocationState>(
                builder: (context, state) {
                  return AppButtonWidget(
                    margin: AppSize.sidePadding,
                    onTap: () {
                      if (seletedIndex != null) {
                        widget.onChange(state.locationsList[seletedIndex!]);
                      }
                      router.maybePop();
                    },
                    text: AppConstants.save,
                    color: context.color.primary,
                  );
                },
              ),
              const Gap(16),
            ],
          ),
        ));
  }
}

class LocationTile extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function(bool) onChange;
  const LocationTile({
    super.key,
    required this.isSelected,
    required this.onChange,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!isSelected);
      },
      child: SizedBox(
        height: 35.r,
        child: Row(
          children: [
            const Gap(25),
            IgnorePointer(
              child: SizedBox(
                width: 0,
                child: Checkbox(
                  activeColor: context.color.primary,
                  value: isSelected,
                  onChanged: (_) {},
                ),
              ),
            ),
            const Gap(25),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
              ),
            ),
            const Gap(25),
          ],
        ),
      ),
    );
  }
}

class ActionDialogWidget extends StatelessWidget {
  final String title;
  final String text;
  final String actionText;
  final VoidCallback onTap;
  final Color? actionColor;
  final bool isLoading;

  const ActionDialogWidget({
    super.key,
    required this.title,
    required this.text,
    required this.actionText,
    required this.onTap,
    this.actionColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: AppSize.overallPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(10),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            AppButtonWidget(
              onTap: () => router.maybePop(),
              margin: const EdgeInsets.symmetric(vertical: 10),
              text: 'CANCEL',
              textColor: context.color.primary,
              color: context.color.primary.withOpacity(0.2),
            ),
            AppButtonWidget(
              isLoading: isLoading,
              onTap: onTap,
              margin: EdgeInsets.zero,
              text: actionText.toUpperCase(),
              color: actionColor ?? context.color.warning,
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}

class UploadFaceScanWidget extends StatelessWidget {
  final void Function(File) onChange;
  const UploadFaceScanWidget({
    super.key,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSize.sidePadding,
      child: Padding(
        padding: AppSize.sidePadding,
        child: BlocProvider(
          create: (_) => CameraBloc()..add(const InitCameraEvent()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please Take A Photo',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(18),
                  IconButton(
                    icon: Assets.icons.flipCamera.svg(),
                    onPressed: () {
                      context.read<CameraBloc>().add(ToggleCameraEvent());
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight,
                    splashRadius: 1,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      router.maybePop();
                    },
                    icon: Icon(
                      Icons.cancel,
                      size: 20.r,
                      color: context.color.hintColor,
                    ),
                  ),
                ],
              ),
              // const Gap(15),
              BlocBuilder<CameraBloc, CameraState>(
                builder: (context, state) {
                  if (state.status == Status.success &&
                      state.controller != null) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CameraPreview(
                            state.controller!,
                            child: Transform.scale(
                                scale: 0.7,
                                child: Assets.images.faceMask.image()),
                          ),
                        ),
                        const Gap(20),
                        AppButtonWidget(
                          margin: EdgeInsets.zero,
                          onTap: () async {
                            final file = await state.controller?.takePicture();
                            if (file == null) return;
                            final image = File(file.path);
                            onChange(image);
                            router.maybePop();
                          },
                          text: 'CAPTURE',
                        ),
                      ],
                    );
                  }
                  return SizedBox(
                    height: 0.5.sh,
                    child: const Center(
                        child: CircularProgressIndicator.adaptive()),
                  );
                },
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
