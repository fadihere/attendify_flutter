import 'dart:developer';

import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/attendance_model.dart';
import 'package:dio/dio.dart';

import '../models/attendance_summary_model.dart';

abstract class HomeRemoteEmrDB {
  Future<AttendanceSummaryModel> fetchAttendanceSummaryAPI({
    required String employerID,
    String? startDate,
    String? endDate,
  });
  Future<List> fetchRequests(
      {required String employerID,
      required String startDate,
      required String endDate});

  Future<List> fetchAttendanceRecored({
    required String employerID,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<UserEmpModel> fetchUserDetail({required String employeeID});

  Future<bool> requestApprovalAPI(
      {required String transId, required bool request});
}

class HomeRemoteEmrDBImpl extends HomeRemoteEmrDB {
  final Dio dio;
  HomeRemoteEmrDBImpl({
    required this.dio,
  });

  @override
  Future<AttendanceSummaryModel> fetchAttendanceSummaryAPI({
    required String employerID,
    String? startDate,
    String? endDate,
  }) async {
    final res = await dio.post(
      'EmployerAttendanceSummary/',
      data: {
        "employer_id": employerID,
        "start_date": startDate ?? DateTime.now().toIso8601String(),
        "end_date": endDate ?? DateTime.now().toIso8601String(),
      },
    );
    if (res.statusCode == 200) {
      return AttendanceSummaryModel.fromJson(res.data);
    }
    throw Exception();
  }

  @override
  Future<List> fetchRequests({
    required String employerID,
    required String startDate,
    required String endDate,
  }) async {
    final res = await dio
        .get(
          'EmployeeAttendanceDetailWithStartAndEndDateERPV3WFH/$employerID/$startDate/$endDate',
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      List attendance =
          res.data.map((data) => AttendanceModel.fromJson(data)).toList();
      return attendance;
    }
    throw Exception();
  }

  @override
  Future<bool> requestApprovalAPI(
      {required String transId, required bool request}) async {
    final url = 'attendance-transaction-wfh/$transId';
    log(":::request::${request}trans---$transId");
    var response = await dio.patch(
      url,
      data: {
        'request_approved': '$request',
        'attendance_choices': request ? 'WFH' : 'ABS'
      },
    );
    log("RESPOnse efh aspproval::$response");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List> fetchAttendanceRecored({
    required String employerID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final start = startDate.toIso8601String().split('.').first;
    final end = endDate.toIso8601String().split('.').first;
    log("->-----start------>$start");
    log(end);
    final Response res = await dio
        .get(
          'EmployeeAttendanceDetailWithStartAndEndDateERPV3Latest/$employerID/$start/$end',
        )
        .timeout(const Duration(seconds: 30));
    log(res.data.toString());
    if (res.statusCode == 200) {
      return (res.data as List)
          .map((e) => AttendanceModel.fromJson(e))
          .toList();
    }
    throw Exception();
  }

  @override
  Future<UserEmpModel> fetchUserDetail({required String employeeID}) async {
    final Response res = await dio.get(
      'employee/update/$employeeID/',
    );

    if (res.statusCode == 200) {
      return UserEmpModel.fromMap(res.data);
    }
    throw Exception();
  }
}
