// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/home/data/models/check_in_model.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/check_out_model.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/last_in_res.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:dio/dio.dart';

import '../models/location_model.dart';
import '../models/wfh_attendance_model.dart';

abstract class HomeRemoteEmpDB {
  Future<LastInModel> empLastInAPI({
    required String employeeID,
    required String employerID,
  });

  Future<Map<String, dynamic>> verifyFaceScan({
    required String id,
    required File file,
  });

  Future<bool> clockIn({required CheckInModel checkInModel});
  Future<bool> clockOut({
    required CheckOutModel checkout,
    required LastInModel lastIn,
  });

  Future<WfhAttendanceModel> requestWFH({required CheckInModel checkInModel});

  Future<LocationModel?> getLocationData({required int locationID});
}

class HomeRemoteDBEmpImpl extends HomeRemoteEmpDB {
  final Dio dio;
  HomeRemoteDBEmpImpl({
    required this.dio,
  });

  @override
  Future<LastInModel> empLastInAPI({
    required String employeeID,
    required String employerID,
  }) async {
    final res = await dio.post('GetEmployeeLastAttendanceTransaction',
        data: {
          "employee_id": employeeID,
          "employer_id": employerID,
        },
        options: Options(sendTimeout: const Duration(seconds: 15)));
    log("LAST IN RESPONSE =======>  $res");
    if (res.statusCode == 200) {
      return LastInModel.fromJson(res.data);
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<Map<String, dynamic>> verifyFaceScan({
    required String id,
    required File file,
  }) async {
    final url = '${AppConst.baseUrlFace}compareuser/?yolo=0&user_id=$id';
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: 'Image'),
    });

    final response = await Dio()
        .post(url, data: formData)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      return response.data;
    }
    throw 'Something went wrong';
  }

  @override
  Future<bool> clockIn({
    required CheckInModel checkInModel,
  }) async {
    final res = await dio.post(
      'attendance-transaction-newest/',
      data: checkInModel.toJson(),
      options: Options(sendTimeout: const Duration(seconds: 15)),
    );

    if (res.statusCode == 200) {
      return true;
    }
    throw 'Something went wrong';
  }

  @override
  Future<LocationModel> getLocationData({required int locationID}) async {
    final response = await dio.get(
      'location/$locationID',
      options: Options(sendTimeout: const Duration(seconds: 15)),
    );
    if (response.statusCode == 200) {
      return LocationModel.fromJson(response.data);
    }
    throw 'Something went wrong';
  }
//wfh post api

  @override
  Future<WfhAttendanceModel> requestWFH({
    required CheckInModel checkInModel,
  }) async {
    log('in Lat ::::::: ${checkInModel.inLatitude}');
    log('in Long ::::::: ${checkInModel.inLongitude}');
    final res = await dio.post(
      'attendance-transaction-wfh/',
      data: {
        'employer_id': checkInModel.employerId,
        'employee_id': checkInModel.employeesId,
        'employees_id': checkInModel.employeesId,
        'transaction_date': checkInModel.recordedTimeIn.toString(),
        'recorded_time_in': checkInModel.recordedTimeIn.toString(),
        'shift_time_in': checkInModel.recordedTimeIn.toString(),
        "attendance_choices": "WFH",
        // 'in_location_id': checkInModel.inLocationId,
        'in_longitude': checkInModel.inLongitude,
        'in_latitude': checkInModel.inLatitude,
      },
      options: Options(sendTimeout: const Duration(seconds: 15)),
    );

    if (res.statusCode == 201) {
      return WfhAttendanceModel.fromMap(res.data);
    }
    throw 'Something went wrong';
  }

  @override
  Future<bool> clockOut({
    required CheckOutModel checkout,
    required LastInModel lastIn,
  }) async {
    final res = await dio.put(
        'attendance-transaction/${lastIn.attendanceTransactionId}',
        data: checkout.toJson(),
        options: Options(sendTimeout: const Duration(seconds: 15)));
    if (res.statusCode == 200) {
      return true;
    }
    throw 'Something went wrong';
  }
}
