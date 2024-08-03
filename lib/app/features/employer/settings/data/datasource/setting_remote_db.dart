import 'dart:developer';

import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/settings/data/models/work_hrs_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//01 step

abstract class SettingRemoteEmrDB {
  Future<WorkHrsModel> fetchOfficeTime({
    required String employerID,
  });

  Future<WorkHrsModel> updateOfficeHrs({
    required String employerID,
    required WorkHrsModel workHrsModel,
  });

  Future<WorkHrsModel> postOfficeHrs({
    required String employerID,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required TimeOfDay gracePeriod,
    required List<dynamic> workingDays,
  });

  Future<bool> deleteEmployerAPI({required String employerID});
  Future<bool> setIntervalForAttendanceCheck(
      {required UserEmrModel user, required int interval});
}

class SettingRemoteEmrDBImpl extends SettingRemoteEmrDB {
  final Dio dio;
  SettingRemoteEmrDBImpl({
    required this.dio,
  });

  @override
  Future<WorkHrsModel> updateOfficeHrs(
      {required String employerID, required WorkHrsModel workHrsModel}) async {
    final res = await dio.patch(
      'employershifttiming/$employerID',
      data: {
        "employers_id": employerID,
        "start_time": workHrsModel.startTime,
        "end_time": workHrsModel.endTime,
        "grace_period": workHrsModel.gracePeriod,
        "working_days": workHrsModel.workingDays,
      },
    );
    log("Testing the WorkHour =====>>>>> ${res.toString()}");

    if (res.statusCode == 200) {
      return WorkHrsModel.fromJson(res.data);
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<WorkHrsModel> fetchOfficeTime({
    required String employerID,
  }) async {
    final res = await dio.get(
      'employershifttiming/$employerID',
    );

    if (res.statusCode == 200) {
      return WorkHrsModel.fromJson(res.data);
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<bool> deleteEmployerAPI({required String employerID}) async {
    final res = await dio.delete(
      'employer/delete/$employerID',
    );
    if (res.statusCode == 200) {
      // log(res.data.toString());
      return true;
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<WorkHrsModel> postOfficeHrs(
      {required String employerID,
      required TimeOfDay startTime,
      required TimeOfDay endTime,
      required TimeOfDay gracePeriod,
      required List workingDays}) async {
    final res = await dio.post(
      'employershifttiming/',
      data: {
        "employers_id": employerID,
        "start_time": "${startTime.hour}:${startTime.minute}:00",
        "end_time": "${endTime.hour}:${endTime.minute}:00",
        "grace_period": "${gracePeriod.hour}:${gracePeriod.minute}:00",
        "working_days": workingDays,
      },
    );
    log("Testing the WorkHour =====>>>>> ${res.toString()}");

    if (res.statusCode == 201) {
      return WorkHrsModel.fromJson(res.data);
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<bool> setIntervalForAttendanceCheck(
      {required UserEmrModel user, required int interval}) async {
    final res = await dio.patch('employer/${user.employerId}',
        data: FormData.fromMap({
          'interval_value': interval,
          'employer_id': user.employerId,
          'organization_name': user.organizationName,
          'email_address': user.emailAddress,
        }));
    // log("RESPONSE =====> ${res.toString()}");
    if (res.statusCode == 200) {
      return true;
    }

    throw 'Something went wrong';
  }
}
