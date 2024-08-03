// To parse this JSON data, do
//
//     final leaveAttendanceModel = leaveAttendanceModelFromMap(jsonString);

import 'dart:convert';

LeaveAttendanceModel leaveAttendanceModelFromMap(String str) =>
    LeaveAttendanceModel.fromMap(json.decode(str));

String leaveAttendanceModelToMap(LeaveAttendanceModel data) =>
    json.encode(data.toMap());

class LeaveAttendanceModel {
  String? employerId;
  String? employeesId;
  DateTime? transactionDate;
  int? departmentId;
  DateTime? recordedTimeIn;
  String? attendanceChoices;
  int? inLocationId;
  int? outLocationId;
  bool? requestApproved;
  int? id;
  String? inLongitude;
  String? inLatitude;
  DateTime? recordedTimeOut;
  String? outLongitude;
  String? outLatitude;
  String? message;
  int? leavePolicyEmp;

  LeaveAttendanceModel({
    this.employerId,
    this.employeesId,
    this.transactionDate,
    this.departmentId,
    this.recordedTimeIn,
    this.attendanceChoices,
    this.inLocationId,
    this.outLocationId,
    this.requestApproved,
    this.id,
    this.inLongitude,
    this.inLatitude,
    this.recordedTimeOut,
    this.outLongitude,
    this.outLatitude,
    this.message,
    this.leavePolicyEmp,
  });

  LeaveAttendanceModel copyWith({
    String? employerId,
    String? employeesId,
    DateTime? transactionDate,
    int? departmentId,
    DateTime? recordedTimeIn,
    String? attendanceChoices,
    int? inLocationId,
    int? outLocationId,
    bool? requestApproved,
    int? id,
    String? inLongitude,
    String? inLatitude,
    DateTime? recordedTimeOut,
    String? outLongitude,
    String? outLatitude,
    String? message,
    int? leavePolicyEmp,
  }) =>
      LeaveAttendanceModel(
        employerId: employerId ?? this.employerId,
        employeesId: employeesId ?? this.employeesId,
        transactionDate: transactionDate ?? this.transactionDate,
        departmentId: departmentId ?? this.departmentId,
        recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
        attendanceChoices: attendanceChoices ?? this.attendanceChoices,
        inLocationId: inLocationId ?? this.inLocationId,
        outLocationId: outLocationId ?? this.outLocationId,
        requestApproved: requestApproved ?? this.requestApproved,
        id: id ?? this.id,
        inLongitude: inLongitude ?? this.inLongitude,
        inLatitude: inLatitude ?? this.inLatitude,
        recordedTimeOut: recordedTimeOut ?? this.recordedTimeOut,
        outLongitude: outLongitude ?? this.outLongitude,
        outLatitude: outLatitude ?? this.outLatitude,
        message: message ?? this.message,
        leavePolicyEmp: leavePolicyEmp ?? this.leavePolicyEmp,
      );

  factory LeaveAttendanceModel.fromMap(Map<String, dynamic> json) =>
      LeaveAttendanceModel(
        employerId: json["employer_id"],
        employeesId: json["employees_id"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        departmentId: json["department_id"],
        recordedTimeIn: json["recorded_time_in"] == null
            ? null
            : DateTime.parse(json["recorded_time_in"]),
        attendanceChoices: json["attendance_choices"],
        inLocationId: json["in_location_id"],
        outLocationId: json["out_location_id"],
        requestApproved: json["request_approved"],
        id: json["id"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
        recordedTimeOut: json["recorded_time_out"] == null
            ? null
            : DateTime.parse(json["recorded_time_out"]),
        outLongitude: json["out_longitude"],
        outLatitude: json["out_latitude"],
        message: json["message"],
        leavePolicyEmp: json["leave_policy_emp"],
      );

  Map<String, dynamic> toMap() => {
        "employer_id": employerId,
        "employees_id": employeesId,
        "transaction_date": transactionDate?.toIso8601String(),
        "department_id": departmentId,
        "recorded_time_in": recordedTimeIn?.toIso8601String(),
        "attendance_choices": attendanceChoices,
        "in_location_id": inLocationId,
        "out_location_id": outLocationId,
        "request_approved": requestApproved,
        "id": id,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
        "recorded_time_out": recordedTimeOut?.toIso8601String(),
        "out_longitude": outLongitude,
        "out_latitude": outLatitude,
        "message": message,
        "leave_policy_emp": leavePolicyEmp,
      };
}
