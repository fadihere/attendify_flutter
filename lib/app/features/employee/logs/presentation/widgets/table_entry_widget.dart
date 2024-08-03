import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/functions/functions.dart';
import '../../data/models/logs_model.dart';

class TableEntryWidget extends StatelessWidget {
  final LogsModel logsModel;
  const TableEntryWidget({super.key, required this.logsModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  logsModel.recordedTimeIn.toString().substring(8, 10),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getDayName(
                    logsModel.recordedTimeIn!.weekday,
                  ),
                  style: TextStyle(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w400,
                      color: context.color.font),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              logsModel.attendanceStatus!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.sp,
                  color: getTextColorByStatus(logsModel.attendanceStatus!),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              textAlign: TextAlign.center,
              logsModel.attendanceStatus != 'ABS'
                  ? logsModel.recordedTimeIn != null
                      ? DateFormat('hh : mm').format(logsModel.recordedTimeIn!)

                      /* logsModel.recordedTimeIn!.hour > 11
                          ? "${(logsModel.recordedTimeIn!.hour - 12).toString().padLeft(2, "0")}:${(logsModel.recordedTimeIn!.minute).toString().padLeft(2, "0")} PM"
                          : "${(logsModel.recordedTimeIn!.hour).toString().padLeft(2, "0")}:${(logsModel.recordedTimeIn!.minute).toString().padLeft(2, "0")} AM" */
                      // logsModel.recordedTimeIn!.hour.toString().padLeft(2,"0")
                      : '00 : 00'
                  : "--:--",
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.hellix),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              logsModel.attendanceStatus != 'ABS'
                  ? logsModel.locationIdInName != null
                      ? logsModel.locationIdInName!.toString()
                      : "--"
                  : "--",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.hellix),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              logsModel.attendanceStatus != 'ABS'
                  ? logsModel.recordedTimeOut != null
                      ? DateFormat('hh : mm').format(logsModel.recordedTimeOut!)

                      /* logsModel.recordedTimeOut!.hour > 11
                          ? "${(logsModel.recordedTimeOut!.hour - 12).toString().padLeft(2, "0")}:${(logsModel.recordedTimeOut!.minute).toString().padLeft(2, "0")} PM"
                          : "${(logsModel.recordedTimeOut!.hour).toString().padLeft(2, "0")}:${(logsModel.recordedTimeOut!.minute).toString().padLeft(2, "0")} AM" */
                      : '00 : 00'
                  : "--:--",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              logsModel.attendanceStatus != 'ABS'
                  ? logsModel.locationIdOutName != null
                      ? logsModel.locationIdOutName.toString()
                      : '--'
                  : "--",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.hellix),
            ),
          ),
        ],
      ),
    );
  }
}
