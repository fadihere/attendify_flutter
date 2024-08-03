import 'dart:developer';

import 'package:attendify_lite/app/features/employee/home/presentation/widgets/timer_widget.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_map;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../employee/home/data/models/attendance_model.dart';

@RoutePage()
class AttendenceDetailLocationPage extends StatelessWidget {
  final AttendanceModel attendanceModel;
  const AttendenceDetailLocationPage({
    super.key,
    required this.attendanceModel,
  });
  @override
  Widget build(BuildContext context) {
    log(attendanceModel.inLatitude!);
    log(attendanceModel.inLongitude!);
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
      body: Column(
        children: [
          Expanded(
            child: google_map.GoogleMap(
              layoutDirection: TextDirection.ltr,
              zoomControlsEnabled: false,
              mapType: google_map.MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: google_map.CameraPosition(
                  target: LatLng(double.parse(attendanceModel.inLatitude!),
                      double.parse(attendanceModel.inLongitude!)),
                  zoom: 16),
              onCameraMove: null,
              // circles: circles,
              markers: {
                google_map.Marker(
                  markerId: const google_map.MarkerId("1"),
                  position: LatLng(double.parse(attendanceModel.inLatitude!),
                      double.parse(attendanceModel.inLongitude!)),
                ),
              },
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 40.h,
        ),
        child: Container(
          width: 327.r,
          height: 247.r,
          decoration: dropShadowDecoration(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Attendance Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.color.font,
                  fontSize: 20,
                  fontFamily: 'Hellix',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
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
              ),
              AppButtonWidget(
                onTap: () {
                  router.popForced();
                },
                text: 'CLOSE',
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
