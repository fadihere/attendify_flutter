// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:attendify_lite/app/features/employee/home/data/models/attendance_model.dart';
import 'package:attendify_lite/app/features/employee/logs/data/models/logs_model.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/widgets/attendence_detail_tile_widget.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';

@RoutePage()
class AdmAttendenceDetailPage extends StatelessWidget {
  final List<LogsModel> logsList;
  const AdmAttendenceDetailPage({super.key, required this.logsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Attendance Details",
              style: TextStyle(
                fontFamily: FontFamily.hellix,
              )),
        ),
        body: ListView.builder(
          padding:
              AppSize.overallPadding + EdgeInsets.symmetric(horizontal: 6.r),
          itemCount: logsList.length,
          itemBuilder: (context, index) {
            final logsModel = logsList[index];
            DateTime timeIn = logsModel.recordedTimeIn!;
            DateTime? timeOut = logsModel.recordedTimeOut;
            // DateTime difference;
            Duration duration = timeOut != null
                ? timeOut.difference(timeIn)
                : const Duration(hours: 0, minutes: 0);
            return AttendanceDetailTileWidget(
              date: timeIn.format('yMMMd'),
              time:
                  '${timeIn.hour.toString().padLeft(2, "0")}:${timeIn.minute.toString().padLeft(2, "0")} to ${timeOut != null ? timeOut.hour.toString().padLeft(2, "0") : "00"}:${timeOut != null ? timeOut.minute.toString().padLeft(2, "0") : "00"}',
              workinghrs:
                  '${duration.inHours}hrs ${(duration.inMinutes % 60).toString()}min',
              onPressed: () {
                final model = AttendanceModel(
                  attendanceStatus: logsModel.attendanceStatus,
                  employeeId: logsModel.employeeId,
                  locationIdIn: logsModel.locationIdIn,
                  locationIdOut: logsModel.locationIdOut,
                  locationIdInName: logsModel.locationIdInName,
                  locationIdOutName: logsModel.locationIdOutName,
                  inLatitude: logsModel.inLatitude,
                  inLongitude: logsModel.inLongitude,
                  recordedTimeIn: logsModel.recordedTimeIn,
                  recordedTimeOut: logsModel.recordedTimeOut,
                );
                router.push(
                    AttendenceDetailLocationRoute(attendanceModel: model));
              },
            );
          },
        )

        /* SizedBox(
        height: 1.sh - 65.r,
        width: 1.sw,
        child: Padding(
          padding: AppSize.overallPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              const Gap(10),
              AttendanceDetailTileWidget(
                date: "21 July, 2023",
                time: '10AM to 12:15PM',
                workinghrs: '2hrs 45min',
                onPressed: () {
                  //router.push(const AttendenceDetailLocationRoute());
                },
              ),
              const Gap(10),
              AttendanceDetailTileWidget(
                date: "21 July, 2023",
                time: '10AM to 12:15PM',
                workinghrs: '2hrs 45min',
                onPressed: () {
                  // router.push(const AttendenceDetailLocationRoute());
                },
              ),
              const Gap(10),
              AttendanceDetailTileWidget(
                date: "21 July, 2023",
                time: '10AM to 12:15PM',
                workinghrs: '2hrs 45min',
                onPressed: () {
                  // router.push(const AttendenceDetailLocationRoute());
                },
              )
            ],
          ),
        ),
      ), */
        );
  }
}
