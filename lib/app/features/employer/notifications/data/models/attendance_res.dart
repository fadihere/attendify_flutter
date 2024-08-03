// To parse this JSON data, do
//
//     final attendanceRes = attendanceResFromJson(jsonString);

import 'dart:convert';

AttendanceRes attendanceResFromJson(String str) =>
    AttendanceRes.fromJson(json.decode(str));

String attendanceResToJson(AttendanceRes data) => json.encode(data.toJson());

class AttendanceRes {
  String? employerId;
  String? employeesId;
  DateTime? transactionDate;
  dynamic departmentId;
  DateTime? recordedTimeIn;
  String? attendanceChoices;
  dynamic inLocationId;
  dynamic outLocationId;
  int? id;
  String? inLongitude;
  String? inLatitude;
  dynamic recordedTimeOut;
  dynamic outLongitude;
  dynamic outLatitude;

  AttendanceRes({
    this.employerId,
    this.employeesId,
    this.transactionDate,
    this.departmentId,
    this.recordedTimeIn,
    this.attendanceChoices,
    this.inLocationId,
    this.outLocationId,
    this.id,
    this.inLongitude,
    this.inLatitude,
    this.recordedTimeOut,
    this.outLongitude,
    this.outLatitude,
  });

  AttendanceRes copyWith({
    String? employerId,
    String? employeesId,
    DateTime? transactionDate,
    dynamic departmentId,
    DateTime? recordedTimeIn,
    String? attendanceChoices,
    dynamic inLocationId,
    dynamic outLocationId,
    int? id,
    String? inLongitude,
    String? inLatitude,
    dynamic recordedTimeOut,
    dynamic outLongitude,
    dynamic outLatitude,
  }) =>
      AttendanceRes(
        employerId: employerId ?? this.employerId,
        employeesId: employeesId ?? this.employeesId,
        transactionDate: transactionDate ?? this.transactionDate,
        departmentId: departmentId ?? this.departmentId,
        recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
        attendanceChoices: attendanceChoices ?? this.attendanceChoices,
        inLocationId: inLocationId ?? this.inLocationId,
        outLocationId: outLocationId ?? this.outLocationId,
        id: id ?? this.id,
        inLongitude: inLongitude ?? this.inLongitude,
        inLatitude: inLatitude ?? this.inLatitude,
        recordedTimeOut: recordedTimeOut ?? this.recordedTimeOut,
        outLongitude: outLongitude ?? this.outLongitude,
        outLatitude: outLatitude ?? this.outLatitude,
      );

  factory AttendanceRes.fromJson(Map<String, dynamic> json) => AttendanceRes(
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
        id: json["id"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
        recordedTimeOut: json["recorded_time_out"],
        outLongitude: json["out_longitude"],
        outLatitude: json["out_latitude"],
      );

  Map<String, dynamic> toJson() => {
        "employer_id": employerId,
        "employees_id": employeesId,
        "transaction_date": transactionDate?.toIso8601String(),
        "department_id": departmentId,
        "recorded_time_in": recordedTimeIn?.toIso8601String(),
        "attendance_choices": attendanceChoices,
        "in_location_id": inLocationId,
        "out_location_id": outLocationId,
        "id": id,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
        "recorded_time_out": recordedTimeOut,
        "out_longitude": outLongitude,
        "out_latitude": outLatitude,
      };
}
