// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:attendify_lite/app/features/employee/leave/data/models/leave_transaction_model.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';

import '../models/leave_count_model.dart';

abstract class LeaveRemoteEmpDB {
  Future<LeaveCountModel> fetchTotalLeavesCount({
    required String employerID,
    required String employeeID,
  });
  Future<List<LeaveTransactionModel>> fetchEmpLeaveRequest({
    required String employeeID,
    required DateTime startDate,
  });
}

class LeaveRemoteDBEmpImpl extends LeaveRemoteEmpDB {
  final Dio dio;
  LeaveRemoteDBEmpImpl({
    required this.dio,
  });
  @override
  Future<LeaveCountModel> fetchTotalLeavesCount(
      {required String employerID, required String employeeID}) async {
    final res = await dio.get(
      'EmployeeAttendanceDetailWithStartAndEndDateERPV3LEAVEEMPCount/$employerID/$employeeID',
    );
    if (res.statusCode == 200) {
      return LeaveCountModel.fromMap(res.data);
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<List<LeaveTransactionModel>> fetchEmpLeaveRequest(
      {required String employeeID, required DateTime startDate}) async {
    final start = startDate.toIso8601String().split('.').first;
    final end = startDate.nextMonth.toIso8601String().split('.').first;
    log(employeeID.toString());
    log(start.toString());
    log(end.toString());
    final res = await dio.get(
      'EmployeeAttendanceDetailWithStartAndEndDateERPV3LEAVEEMP/$employeeID/$start/$end',
    );
    if (res.statusCode == 200) {
      return (res.data as List)
          .map((e) => LeaveTransactionModel.fromMap(e))
          .toList();
    }
    throw 'Unknown Error Occured';
  }
}
