// To parse this JSON data, do
//
//     final leaveTransactionModel = leaveTransactionModelFromMap(jsonString);

import 'dart:convert';

List<LeaveTransactionModel> leaveTransactionModelFromMap(String str) =>
    List<LeaveTransactionModel>.from(
        json.decode(str).map((x) => LeaveTransactionModel.fromMap(x)));

String leaveTransactionModelToMap(List<LeaveTransactionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class LeaveTransactionModel {
  String? employeeId;
  String? employerId;
  DateTime? transactionDate;
  String? attendanceStatus;
  dynamic requestApproved;
  DateTime? createdOn;
  dynamic locationIdIn;
  dynamic locationIdOut;
  String? totalTimeInWork;
  DateTime? recordedTimeIn;
  DateTime? recordedTimeOut;
  int? attendanceTransactionId;
  dynamic inLongitude;
  dynamic inLatitude;
  dynamic outLongitude;
  dynamic outLatitude;
  int? leavePolicyEmp;
  String? title;
  String? subTitle;

  LeaveTransactionModel({
    this.employeeId,
    this.employerId,
    this.transactionDate,
    this.attendanceStatus,
    this.requestApproved,
    this.createdOn,
    this.locationIdIn,
    this.locationIdOut,
    this.totalTimeInWork,
    this.recordedTimeIn,
    this.recordedTimeOut,
    this.attendanceTransactionId,
    this.inLongitude,
    this.inLatitude,
    this.outLongitude,
    this.outLatitude,
    this.leavePolicyEmp,
    this.title,
    this.subTitle,
  });

  LeaveTransactionModel copyWith({
    String? employeeId,
    String? employerId,
    DateTime? transactionDate,
    String? attendanceStatus,
    dynamic requestApproved,
    DateTime? createdOn,
    dynamic locationIdIn,
    dynamic locationIdOut,
    String? totalTimeInWork,
    DateTime? recordedTimeIn,
    DateTime? recordedTimeOut,
    int? attendanceTransactionId,
    dynamic inLongitude,
    dynamic inLatitude,
    dynamic outLongitude,
    dynamic outLatitude,
    int? leavePolicyEmp,
    String? title,
    String? subTitle,
  }) =>
      LeaveTransactionModel(
        employeeId: employeeId ?? this.employeeId,
        employerId: employerId ?? this.employerId,
        transactionDate: transactionDate ?? this.transactionDate,
        attendanceStatus: attendanceStatus ?? this.attendanceStatus,
        requestApproved: requestApproved ?? this.requestApproved,
        createdOn: createdOn ?? this.createdOn,
        locationIdIn: locationIdIn ?? this.locationIdIn,
        locationIdOut: locationIdOut ?? this.locationIdOut,
        totalTimeInWork: totalTimeInWork ?? this.totalTimeInWork,
        recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
        recordedTimeOut: recordedTimeOut ?? this.recordedTimeOut,
        attendanceTransactionId:
            attendanceTransactionId ?? this.attendanceTransactionId,
        inLongitude: inLongitude ?? this.inLongitude,
        inLatitude: inLatitude ?? this.inLatitude,
        outLongitude: outLongitude ?? this.outLongitude,
        outLatitude: outLatitude ?? this.outLatitude,
        leavePolicyEmp: leavePolicyEmp ?? this.leavePolicyEmp,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
      );

  factory LeaveTransactionModel.fromMap(Map<String, dynamic> json) =>
      LeaveTransactionModel(
        employeeId: json["employee_id"],
        employerId: json["employer_id"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        attendanceStatus: json["attendance_status"],
        requestApproved: json["request_approved"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        locationIdIn: json["location_id_in"],
        locationIdOut: json["location_id_out"],
        totalTimeInWork: json["total_time_in_work"],
        recordedTimeIn: json["recorded_time_in"] == null
            ? null
            : DateTime.parse(json["recorded_time_in"]),
        recordedTimeOut: json["recorded_time_out"] == null
            ? null
            : DateTime.parse(json["recorded_time_out"]),
        attendanceTransactionId: json["attendance_transaction_id"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
        outLongitude: json["out_longitude"],
        outLatitude: json["out_latitude"],
        leavePolicyEmp: json["leave_policy_emp"],
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toMap() => {
        "employee_id": employeeId,
        "employer_id": employerId,
        "transaction_date": transactionDate?.toIso8601String(),
        "attendance_status": attendanceStatus,
        "request_approved": requestApproved,
        "created_on": createdOn?.toIso8601String(),
        "location_id_in": locationIdIn,
        "location_id_out": locationIdOut,
        "total_time_in_work": totalTimeInWork,
        "recorded_time_in": recordedTimeIn?.toIso8601String(),
        "recorded_time_out": recordedTimeOut?.toIso8601String(),
        "attendance_transaction_id": attendanceTransactionId,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
        "out_longitude": outLongitude,
        "out_latitude": outLatitude,
        "leave_policy_emp": leavePolicyEmp,
        "title": title,
        "sub_title": subTitle,
      };
}
