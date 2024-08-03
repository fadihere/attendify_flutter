import 'package:attendify_lite/app/features/employee/Notifications/data/models/noti_model.dart';
import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:dio/dio.dart';

import '../../../../employee/home/data/models/check_out_model.dart';
import '../models/attendance_res.dart';

abstract class NotiRemoteEmrDB {
  Future<List<NotiModel>> fetchEmrNotificationsAPI({
    required String employerID,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<AttendanceRes> fetchAttendanceDetailByID({required int attendanceID});
  Future<UserEmpModel> fetchEmployeeDataByID({required String employeeID});

  Future<bool> updateNotificationStatusAPI(
      {required int notificationID, required NotiModel notiModel});

  Future<bool> clockOutEmployee(
      {required CheckOutModel res, required int attendanceID});
}

class NotiRemoteEmrDBImpl extends NotiRemoteEmrDB {
  final Dio dio;
  NotiRemoteEmrDBImpl({required this.dio});

  @override
  Future<List<NotiModel>> fetchEmrNotificationsAPI(
      {required String employerID,
      required DateTime startDate,
      required DateTime endDate}) async {
    final start = startDate.toString().replaceAll(" ", "T").substring(0, 19);
    final end = endDate.toString().replaceAll(" ", "T").substring(0, 19);

    final response = await dio.get(
      'notification/employer/$employerID/$start/$end',
    );

    List<dynamic> jsonData = response.data as List;

    return jsonData.map((json) => NotiModel.fromJson(json)).toList();
  }

  @override
  Future<AttendanceRes> fetchAttendanceDetailByID(
      {required int attendanceID}) async {
    final response = await dio.get(
      'attendance-transaction/$attendanceID',
    );
    if (response.statusCode == 200) {
      return AttendanceRes.fromJson(response.data);
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<bool> updateNotificationStatusAPI(
      {required int notificationID, required NotiModel notiModel}) async {
    final response =
        await dio.put('notification/$notificationID', data: notiModel.toJson());

    if (response.statusCode == 200) {
      return true;
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<bool> clockOutEmployee(
      {required CheckOutModel res, required int attendanceID}) async {
    final response = await dio.put('attendance-transaction/$attendanceID',
        data: res.toJson());

    if (response.statusCode == 200) {
      return true;
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<UserEmpModel> fetchEmployeeDataByID(
      {required String employeeID}) async {
    final response = await dio.get(
      '/employee/update/$employeeID/',
    );
    if (response.statusCode == 200) {
      return UserEmpModel.fromMap(response.data);
    }
    throw 'Unknown Error Occured';
  }
}
