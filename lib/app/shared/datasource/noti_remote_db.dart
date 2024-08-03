import 'dart:developer';

import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:dio/dio.dart';

abstract class NotiRemoteDB {
  static void sendNotificationAPI({
    required String title,
    required String subTitle,
    String? employerID,
    String? employeeID,
    int? attendanceID,
    double? currentLat,
    double? currentLong,
    String? notificationType,
  }) async {
    final dio = Dio();
    const url = '${AppConst.baseurl}notification/';

    final res = await dio.post(
      url,
      data: {
        "employers_id": employerID,
        "employees_id": employeeID,
        "title": title,
        "sub_title": subTitle,
        "attendance_id": attendanceID,
        "current_lat": currentLat.toString(),
        "current_long": currentLong.toString(),
        "notification_type": notificationType,
        "is_seen": false,
        "date_and_time": DateTime.now().toIso8601String()
      },
    );
    log("NOTIFICATION RESPONSE =======> ${res.toString()}");
  }
}
