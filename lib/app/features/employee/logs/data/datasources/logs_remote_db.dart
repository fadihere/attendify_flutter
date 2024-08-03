import 'dart:developer';

import 'package:attendify_lite/app/features/employee/logs/data/models/logs_model.dart';
import 'package:dio/dio.dart';

abstract class LogsRemoteDB {
  Future<List<LogsModel>?> fetchUserLogsAPI({
    required String employeeID,
    required String employerID,
    required startDate,
    required endDate,
  });
}

class LogsRemoteDBImpl extends LogsRemoteDB {
  final Dio dio;
  LogsRemoteDBImpl({required this.dio});

  @override
  Future<List<LogsModel>?> fetchUserLogsAPI({
    required String employeeID,
    required String employerID,
    required startDate,
    required endDate,
  }) async {
    final first = startDate.toIso8601String().split('.').first;
    final end = endDate.toIso8601String().split('.').first;
    final response = await dio.post(
      'EmployeeAttendanceDetailWithStartAndEndDate',
      data: {
        'employee_id': employeeID,
        'employer_id': employerID,
        'start_date': first,
        'end_date': end,
      },
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final res = response.data as List<dynamic>;
      return res.map((e) => LogsModel.fromJson(e)).toList();
    }

    return null;
  }
}
