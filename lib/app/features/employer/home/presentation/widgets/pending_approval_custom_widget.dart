import 'package:attendify_lite/app/features/employee/home/data/models/attendance_model.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/functions/functions.dart';

class PendingApprovalsCustomWidget extends StatelessWidget {
  final AttendanceModel attendanceModel;

  final Widget surfix;
  const PendingApprovalsCustomWidget({
    super.key,
    required this.surfix,
    required this.attendanceModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: context.color.divider, height: 0),
        const Gap(7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Work From Home",
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.hellix),
            ),
            surfix
          ],
        ),
        const Gap(2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              attendanceModel.employeeName ?? '',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.hellix),
            ),
            Text(
              '${attendanceModel.recordedTimeIn!.day} ${getMonthName(attendanceModel.recordedTimeIn!.month)} - ${DateFormat('hh:mm').format(attendanceModel.recordedTimeIn!)} ${attendanceModel.recordedTimeIn!.hour > 12 ? "PM" : "AM"}',
              style: TextStyle(
                  color: context.color.hintColor,
                  fontSize: 10.r,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.hellix),
            ),
          ],
        ),
        const Gap(7),
      ],
    );
  }
}
