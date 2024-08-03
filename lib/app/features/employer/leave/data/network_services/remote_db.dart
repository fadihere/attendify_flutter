import 'dart:convert';
import 'dart:developer';

import 'package:attendify_lite/app/features/employer/leave/data/models/leave_policy_model.dart';
import 'package:dio/dio.dart';

import '../models/leave_policy.dart';

abstract class LeaveRemoteDB {
  Future<List<LeavePolicyModel>> fetchLeavePoliciesAPI(
      {required String employerID});

  Future<LeavePolicyModel> createLeavePolicy(
      {required LeavePolicy leavePolicy});
  Future<bool> updateLeavePolicy({
    required LeavePolicy leavePolicy,
    required String policyID,
  });
  Future<bool> deleteLeavePolicy({required int policyID});

  Future<bool> updateLeavePolicyPeriod(
      {required String fromDate,
      required String toDate,
      required String employerID});
}

class LeaveRemoteDBImpl extends LeaveRemoteDB {
  final Dio dio;
  LeaveRemoteDBImpl({
    required this.dio,
  });

  @override
  Future<List<LeavePolicyModel>> fetchLeavePoliciesAPI(
      {required String employerID}) async {
    final res = await dio.get(
      'leave-policies/$employerID/',
    );
    if (res.statusCode == 200) {
      return (res.data as List)
          .map((e) => LeavePolicyModel.fromMap(e))
          .toList();
    }
    throw Exception();
  }

  @override
  Future<LeavePolicyModel> createLeavePolicy(
      {required LeavePolicy leavePolicy}) async {
    final res = await dio.post('leavepolicy/', data: leavePolicy.toJson());
    log(res.data.toString());
    if (res.statusCode == 201) {
      return leavePolicyModelFromMap(jsonEncode(res.data));
    }
    throw Exception();
  }

  @override
  Future<bool> updateLeavePolicy({
    required LeavePolicy leavePolicy,
    required String policyID,
  }) async {
    final res =
        await dio.put('leavepolicy/$policyID', data: leavePolicy.toJson());
    log(res.data.toString());
    if (res.statusCode == 200) {
      return true;
    }
    throw Exception();
  }

  @override
  Future<bool> deleteLeavePolicy({required int policyID}) async {
    final res = await dio.delete('leavepolicy/$policyID');
    log(res.data.toString());
    if (res.statusCode == 204) {
      return true;
    }
    throw Exception();
  }

  @override
  Future<bool> updateLeavePolicyPeriod(
      {required String fromDate,
      required String toDate,
      required String employerID}) async {
    log(fromDate);
    log(toDate);
    log(employerID);

    final res = await dio.put('leave_policies/bulk_update/$employerID', data: {
      'from_date': fromDate,
      'to_date': fromDate,
      'employer_id': employerID
    });
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      return true;
    }
    throw Exception();
  }
}
