import 'package:attendify_lite/app/features/employee/Notifications/data/models/noti_model.dart';
import 'package:attendify_lite/app/features/employer/notifications/presentation/blocs/noti_emr_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_map;

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../shared/widgets/decoration.dart';
import '../../../place_picker/place_picker_imports.dart';

@RoutePage()
class NotOnLocationDetailPage extends StatefulWidget {
  final NotiModel notiModel;
  const NotOnLocationDetailPage({super.key, required this.notiModel});

  @override
  State<NotOnLocationDetailPage> createState() =>
      _NotOnLocationDetailPageState();
}

class _NotOnLocationDetailPageState extends State<NotOnLocationDetailPage> {
  @override
  void initState() {
    context.read<NotiEmrBloc>().add(FetchAttendanceDetailByIDEvent(
        attendanceID: widget.notiModel.attendanceId!));
    super.initState();
  }

  @override
  void dispose() {
    // context.read<NotiEmrBloc>().add(ClearPreviousNotificationEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.color.icon,
          ),
          onPressed: () => router.maybePop(),
        ),
      ),
      body: BlocConsumer<NotiEmrBloc, NotiEmrState>(
        listener: (context, state) {
          if (state.status == Status.loading) {
            BotToast.showLoading();
          }
          BotToast.closeAllLoading();
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: google_map.GoogleMap(
                  layoutDirection: TextDirection.ltr,
                  zoomControlsEnabled: false,
                  mapType: google_map.MapType.normal,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: google_map.CameraPosition(
                      target: LatLng(
                          double.parse(state.attendanceModel?.inLatitude ??
                              "31.4612693"),
                          double.parse(state.attendanceModel?.inLongitude ??
                              "74.4213638")),
                      zoom: 16),
                  onCameraMove: null,
                  // circles: circles,
                  markers: {
                    google_map.Marker(
                      markerId: const google_map.MarkerId("1"),
                      position: LatLng(
                          double.parse(state.attendanceModel?.inLatitude ??
                              "31.4612693"),
                          double.parse(state.attendanceModel?.inLongitude ??
                              "74.4213638")),
                    ),
                    if (widget.notiModel.currentLat != null &&
                        widget.notiModel.currentLong != null)
                      google_map.Marker(
                        markerId: const google_map.MarkerId("2"),
                        position: LatLng(
                            double.parse(
                                widget.notiModel.currentLat ?? "31.4612693"),
                            double.parse(
                                widget.notiModel.currentLong ?? "74.4213638")),
                      ),
                  },
                ),
              ),
            ],
          );
        },
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 40.h,
        ),
        width: 327.r,
        height: 261.r,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: dropShadowDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.notiModel.title ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.color.font,
                fontSize: 20.sp,
                fontFamily: 'Hellix',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.notiModel.subTitle ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.color.font,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(20.h),
            /*       Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TimerWidget(
                      icon: Assets.icons.clockIn,
                      title: 'Clock In',
                      dateTime: attendanceModel.recordedTimeIn != null
                          ? attendanceModel.recordedTimeIn!.format('hh : mm')
                          : "00 : 00",
                    ),
                    TimerWidget(
                      icon: Assets.icons.clockOut,
                      title: 'Clock out',
                      dateTime: attendanceModel.recordedTimeOut != null
                          ? attendanceModel.recordedTimeOut!.format('hh : mm')
                          : "00 : 00",
                    ),
                    TimerWidget(
                      icon: Assets.icons.clockIn,
                      title: 'Total Hrs',
                      dateTime: attendanceModel.recordedTimeOut != null
                          ? '${attendanceModel.recordedTimeOut!.difference(attendanceModel.recordedTimeIn!).inHours.toString().padLeft(2, '0')} : ${(attendanceModel.recordedTimeOut!.difference(attendanceModel.recordedTimeIn!).inMinutes % 60).toString().padLeft(2, '0')}'
                          : "00 : 00",
                    ),
                  ],
                ), */
            AppButtonWidget(
              onTap: () {
                router.popForced();
              },
              text: 'CANCEL',
              color: context.color.primary.withOpacity(0.2),
              textColor: context.color.primary,
              margin: const EdgeInsets.symmetric(vertical: 0),
            ),
            Gap(10.h),
            BlocBuilder<NotiEmrBloc, NotiEmrState>(
              builder: (context, state) {
                return AppButtonWidget(
                  onTap: () {
                    context.read<NotiEmrBloc>().add(ClockOutEmployeeEvent(
                        outLatitude: double.parse(widget.notiModel.currentLat!),
                        outLongitude:
                            double.parse(widget.notiModel.currentLong!)));
                  },
                  text: 'CLOCK OUT',
                  margin: const EdgeInsets.symmetric(vertical: 0),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
