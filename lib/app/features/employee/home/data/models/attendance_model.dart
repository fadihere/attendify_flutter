// To parse this JSON data, do
//
//     final attendanceTransaction = attendanceTransactionFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceTransactionFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));

String attendanceTransactionToJson(AttendanceModel data) =>
    json.encode(data.toJson());

class AttendanceModel {
  final String? employeeId;
  final DateTime? transactionDate;
  final String? attendanceStatus;
  final DateTime? createdOn;
  final int? locationIdIn;
  final String? locationIdInName;
  final String? locationIdOutName;
  final int? locationIdOut;
  final String? totalTimeInWork;
  final DateTime? recordedTimeIn;
  final DateTime? recordedTimeOut;
  final int? attendanceTransactionId;
  final String? inLongitude;
  final String? inLatitude;
  final String? outLongitude;
  final String? outLatitude;
  final String? employeeName;
  final bool? requestApproved;

  AttendanceModel({
    this.employeeId,
    this.requestApproved,
    this.transactionDate,
    this.attendanceStatus,
    this.createdOn,
    this.locationIdIn,
    this.locationIdInName,
    this.locationIdOutName,
    this.locationIdOut,
    this.totalTimeInWork,
    this.recordedTimeIn,
    this.recordedTimeOut,
    this.attendanceTransactionId,
    this.inLatitude,
    this.inLongitude,
    this.outLatitude,
    this.outLongitude,
    this.employeeName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        requestApproved: json["request_approved"],
        employeeName: json["employee_name"],
        employeeId: json["employee_id"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        attendanceStatus: json["attendance_status"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        locationIdIn: json["location_id_in"],
        locationIdInName: json["location_id_in_name"],
        outLatitude: json["out_latitude"],
        outLongitude: json["out_longitude"],
        locationIdOutName: json["location_id_out_name"],
        locationIdOut: json["location_id_out"],
        totalTimeInWork: json["total_time_in_work"],
        recordedTimeIn: json["recorded_time_in"] == null
            ? null
            : DateTime.parse(
                json["recorded_time_in"].toString().substring(0, 19)),
        recordedTimeOut: json["recorded_time_out"] == null
            ? null
            : DateTime.parse(
                json["recorded_time_out"].toString().substring(0, 19)),
        attendanceTransactionId: json["attendance_transaction_id"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
      );

  Map<String, dynamic> toJson() => {
        "employee_name": employeeName,
        "request_approved": requestApproved,
        "employee_id": employeeId,
        "transaction_date": transactionDate?.toIso8601String(),
        "attendance_status": attendanceStatus,
        "created_on": createdOn?.toIso8601String(),
        "location_id_in": locationIdIn,
        "location_id_in_name": locationIdInName,
        "location_id_out_name": locationIdOutName,
        "location_id_out": locationIdOut,
        "total_time_in_work": totalTimeInWork,
        "recorded_time_in": recordedTimeIn?.toIso8601String(),
        "recorded_time_out": recordedTimeOut?.toIso8601String(),
        "attendance_transaction_id": attendanceTransactionId,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
      };
}
