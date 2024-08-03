// To parse this JSON data, do
//
//     final wfhAttendanceModel = wfhAttendanceModelFromMap(jsonString);

import 'dart:convert';

WfhAttendanceModel wfhAttendanceModelFromMap(String str) =>
    WfhAttendanceModel.fromMap(json.decode(str));

String wfhAttendanceModelToMap(WfhAttendanceModel data) =>
    json.encode(data.toMap());

class WfhAttendanceModel {
  String? employerId;
  String? employeesId;
  DateTime? transactionDate;
  int? departmentId;
  DateTime? recordedTimeIn;
  String? attendanceChoices;
  int? inLocationId;
  int? outLocationId;
  bool? requestApproved;
  String? message;
  int? id;
  String? inLongitude;
  String? inLatitude;
  DateTime? recordedTimeOut;
  String? outLongitude;
  String? outLatitude;

  WfhAttendanceModel({
    this.employerId,
    this.employeesId,
    this.transactionDate,
    this.departmentId,
    this.recordedTimeIn,
    this.attendanceChoices,
    this.inLocationId,
    this.outLocationId,
    this.requestApproved,
    this.message,
    this.id,
    this.inLongitude,
    this.inLatitude,
    this.recordedTimeOut,
    this.outLongitude,
    this.outLatitude,
  });

  WfhAttendanceModel copyWith({
    String? employerId,
    String? employeesId,
    DateTime? transactionDate,
    int? departmentId,
    DateTime? recordedTimeIn,
    String? attendanceChoices,
    int? inLocationId,
    int? outLocationId,
    bool? requestApproved,
    String? message,
    int? id,
    String? inLongitude,
    String? inLatitude,
    DateTime? recordedTimeOut,
    String? outLongitude,
    String? outLatitude,
  }) =>
      WfhAttendanceModel(
        employerId: employerId ?? this.employerId,
        employeesId: employeesId ?? this.employeesId,
        transactionDate: transactionDate ?? this.transactionDate,
        departmentId: departmentId ?? this.departmentId,
        recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
        attendanceChoices: attendanceChoices ?? this.attendanceChoices,
        inLocationId: inLocationId ?? this.inLocationId,
        outLocationId: outLocationId ?? this.outLocationId,
        requestApproved: requestApproved ?? this.requestApproved,
        message: message ?? this.message,
        id: id ?? this.id,
        inLongitude: inLongitude ?? this.inLongitude,
        inLatitude: inLatitude ?? this.inLatitude,
        recordedTimeOut: recordedTimeOut ?? this.recordedTimeOut,
        outLongitude: outLongitude ?? this.outLongitude,
        outLatitude: outLatitude ?? this.outLatitude,
      );

  factory WfhAttendanceModel.fromMap(Map<String, dynamic> json) =>
      WfhAttendanceModel(
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
        message: json["message"],
        id: json["id"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
        recordedTimeOut: json["recorded_time_out"] == null
            ? null
            : DateTime.parse(json["recorded_time_out"]),
        outLongitude: json["out_longitude"],
        outLatitude: json["out_latitude"],
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
        "message": message,
        "id": id,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
        "recorded_time_out": recordedTimeOut?.toIso8601String(),
        "out_longitude": outLongitude,
        "out_latitude": outLatitude,
      };
}
