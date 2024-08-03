// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/settings/data/models/work_hrs_model.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:dio/dio.dart';

import '../../../../employee/auth/data/models/user_emp_model.dart';
import '../../../../employee/logs/data/models/logs_model.dart';

abstract class TeamRemoteDB {
  Future<List<TeamModel>> getTeams(UserEmrModel user);
  Future<TeamModel> createEmployee(
    TeamModel user,
    File? image,
    String password,
  );
  Future<List<UserEmpModel>> getUserAttendanceData(TeamModel user);
  Future<bool> archiveTeam(
    UserEmrModel user,
    TeamModel team,
    bool action,
  );
  Future<int> getEmployeeId(int id);
  Future<WorkHrsModel> updateEmpWorkHrs(
      {required WorkHrsModel workHrs, required TeamModel team});
  Future<WorkHrsModel> postEmpWorkHrs(
      {required WorkHrsModel workHrs, required TeamModel team});
  Future<WorkHrsModel> fetchEmployeeWorkHours({required TeamModel team});
  Future<bool> isValidEmployeeId(int empId, int emrId);
  Future<bool> deleteEmployee(TeamModel team);
  Future<int> addEmployeeLocation(TeamModel team);
  Future<bool> updateEmployeePhone(
    TeamModel team,
    String phoneNo,
    UserEmrModel user,
  );
  Future<bool> registerEmployeeFace(File image, String empId);
  Future<List<LogsModel>> fetchEmployeeAttendanceLogs({
    required String employerID,
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class TeamRemoteDBImpl implements TeamRemoteDB {
  final Dio dio;
  TeamRemoteDBImpl({required this.dio});

  @override
  Future<List<TeamModel>> getTeams(UserEmrModel user) async {
    final res = await dio.get(
      'employee/employeeDetailByEmployerId/${user.employerId}',
    );
    if (res.statusCode == 200) {
      final teams = res.data as List;
      return teams.map((e) => TeamModel.fromJson(e)).toList();
    }
    throw 'something went wrong';
  }

  @override
  Future<List<UserEmpModel>> getUserAttendanceData(TeamModel user) async {
    final res =
        await dio.get('EmployerAttendanceSummary/${user.employerId}', data: {
      'employer_id': user.employerId,
      'end_date': DateTime.now().toString().replaceAll(" ", "T"),
    });
    log(res.data);
    // if (res.statusCode == 200) {
    //   final teams = res.data as List;
    //   return teams.map((e) => TeamModel.fromJson(e)).toList();
    // }
    throw 'something went wrong';
  }
  //ok now

  @override
  Future<bool> archiveTeam(
    UserEmrModel user,
    TeamModel team,
    bool action,
  ) async {
    final data = FormData.fromMap({
      'employee_id': team.employeeId,
      'employer_id': user.employerId,
      'is_active': action,
      'created_by': user.employerId,
    });
    final res = await dio.patch(
      'employee/update/${team.employeeId}/',
      data: data,
    );
    if (res.statusCode == 200) {
      return true;
    }
    throw 'something went wrong';
  }

  @override
  Future<TeamModel> createEmployee(
    TeamModel user,
    File? image,
    String password,
  ) async {
    final img = image != null
        ? await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          )
        : null;

    log("USER ID: ${user.employeeId}");
    final data = FormData.fromMap({
      'password': password,
      'image_url': img,
      'employer_id': user.employerId.toString(),
      'employee_id': user.employeeId,
      'employee_name': user.employeeName,
      'phone_number': user.phoneNumber,
      'location_id': user.locationId.toString(),
      'is_active': user.isActive.toString(),
      'created_by': user.createdBy.toString(),
    });
    final res = await dio.post('employee/', data: data);
    if (res.statusCode == 201) {
      return TeamModel.fromJson(res.data);
    }
    throw 'Something went wrong';
  }

  @override
  Future<int> getEmployeeId(int id) async {
    final url = 'GetMaxEmployeeId/max-count/$id';

    final response = await dio.get(url).timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      return (int.parse(response.data));
    }
    throw 'Something went wrong';
  }

  @override
  Future<bool> deleteEmployee(TeamModel team) async {
    final url = 'employee/delEmp/${team.employeeId}/${team.phoneNumber}/';
    final faceUrl = '${AppConst.baseUrlFace}RemoveEmployee/${team.employeeId}/';
    final res = await dio.delete(url);
    await dio.delete(faceUrl);
    log("=======>${res.statusCode}");
    if (res.statusCode == 200) return true;
    throw Exception();
  }

//update phone error
  @override
  Future<bool> updateEmployeePhone(
      TeamModel team, String phoneNo, UserEmrModel user) async {
    final url = 'employee/update/${team.employeeId.toString()}/';

    final data = {
      "employee_id": team.employeeId.toString(),
      'phone_number': phoneNo.toString(),
      'created_by': user.employerId,
    };
    log("message:::${data.toString()}");
    final res = await dio.put(
      url,
      data: FormData.fromMap(data),
    );

    if (res.statusCode == 200) return true;
    throw 'Something went wrong';
  }

  @override
  Future<bool> isValidEmployeeId(int empId, int emrId) async {
    const url = 'employee/IsVAlidEmployeeId/';
    final res = await dio.get(
      url,
      queryParameters: {'EmployeeId': empId, 'EmployerId': emrId},
    );
    final extractedId = res.data;
    if (extractedId is bool) {
      return extractedId;
    }
    throw 'Something went wrong';
  }

  @override
  Future<int> addEmployeeLocation(TeamModel team) async {
    const url = 'employee/CreateNewEmployeeLocations/';
    final data = {
      "EmployerId": team.employerId,
      "EmployeeId": team.employeeId.toString(),
      "LocationId": team.locationId.toString()
    };
    log(data.toString());
    await dio.post(url, data: data);
    return 1;
  }

  @override
  Future<bool> registerEmployeeFace(File image, String empId) async {
    const url = '${AppConst.baseUrlFace}register/?yolo=0';
    final data = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: empId),
    });
    final res = await dio.post(
      url,
      data: data,
    );
    if (res.statusCode == 200) {
      return true;
    }
    throw 'Something went wrong';
  }

  @override
  Future<List<LogsModel>> fetchEmployeeAttendanceLogs(
      {required String employerID,
      required String employeeID,
      required DateTime startDate,
      required DateTime endDate}) async {
    final first = startDate.toIso8601String().split('.').first;
    final end = endDate.toIso8601String().split('.').first;

    const url = 'EmployeeAttendanceDetailWithStartAndEndDate';
    final res = await dio.post(
      url,
      data: {
        'employee_id': employeeID,
        'employer_id': employerID,
        'start_date': first,
        'end_date': end,
      },
    );
    // log(res.data.toString());
    final list = res.data as List<dynamic>;
    if (res.statusCode == 200) {
      return list.map((e) => LogsModel.fromJson(e)).toList();
      // for (int i = 0; i < extractedData.length; i++) {
      //   LogsModel attendanceReportTransaction =
      //       LogsModel.fromJson(extractedData[i]);

      //   employeeLogsList.add(attendanceReportTransaction);
      // }
      // return employeeLogsList;
    }

    throw UnimplementedError();
  }

  @override
  Future<WorkHrsModel> fetchEmployeeWorkHours({required TeamModel team}) async {
    final res = await dio.get('employeeshifttiming/${team.employeeId}');

    if (res.statusCode == 200) {
      // log(res.data.toString());
      return WorkHrsModel.fromJson(res.data);
    }

    throw UnimplementedError();
  }

  @override
  Future<WorkHrsModel> updateEmpWorkHrs({
    required WorkHrsModel workHrs,
    required TeamModel team,
  }) async {
    final res = await dio.put('employeeshifttiming/${team.employeeId}', data: {
      "start_time": workHrs.startTime,
      "end_time": workHrs.endTime,
      "grace_period": workHrs.gracePeriod,
      "working_days": workHrs.workingDays,
      "employers_id": workHrs.employersId,
      "employees_id": team.employeeId,
    });
    log(res.toString());

    if (res.statusCode == 200) {
      return WorkHrsModel.fromJson(res.data);
    }
    throw UnimplementedError();
  }

  @override
  Future<WorkHrsModel> postEmpWorkHrs({
    required WorkHrsModel workHrs,
    required TeamModel team,
  }) async {
    final res = await dio.post('employeeshifttiming/', data: {
      "start_time": workHrs.startTime,
      "end_time": workHrs.endTime,
      "grace_period": workHrs.gracePeriod,
      "working_days": workHrs.workingDays,
      "employers_id": workHrs.employersId,
      "employees_id": team.employeeId,
    });

    if (res.statusCode == 201) {
      return WorkHrsModel.fromJson(res.data);
    }
    throw UnimplementedError();
  }
}
