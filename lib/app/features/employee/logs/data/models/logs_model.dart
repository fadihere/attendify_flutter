// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LogsModel {
  final String? employeeName;
  final String? employeeId;
  final DateTime? transactionDate;
  final String? workingTime;
  final String? attendanceStatus;
  final String? weekday;
  final DateTime? recordedTimeIn;
  final DateTime? createdOn;
  final int? locationIdIn;
  final String? locationIdInName;
  final String? locationIdOutName;
  final int? locationIdOut;
  final String? totalTimeInWork;
  final DateTime? recordedTimeOut;
  final int? attendanceTransactionId;
  final String? inLongitude;
  final String? inLatitude;
  final String? outLongitude;
  final String? outLatitude;

  LogsModel({
    required this.employeeName,
    required this.employeeId,
    required this.transactionDate,
    required this.workingTime,
    required this.attendanceStatus,
    required this.weekday,
    required this.recordedTimeIn,
    required this.createdOn,
    required this.locationIdIn,
    required this.locationIdInName,
    required this.locationIdOutName,
    required this.locationIdOut,
    required this.totalTimeInWork,
    required this.recordedTimeOut,
    required this.attendanceTransactionId,
    required this.inLongitude,
    required this.inLatitude,
    required this.outLongitude,
    required this.outLatitude,
  });

  LogsModel copyWith({
    String? employeeName,
    String? employeeId,
    DateTime? transactionDate,
    String? workingTime,
    String? attendanceStatus,
    String? weekday,
    DateTime? recordedTimeIn,
    DateTime? createdOn,
    int? locationIdIn,
    String? locationIdInName,
    String? locationIdOutName,
    int? locationIdOut,
    String? totalTimeInWork,
    DateTime? recordedTimeOut,
    int? attendanceTransactionId,
    String? inLongitude,
    String? inLatitude,
    String? outLongitude,
    String? outLatitude,
  }) =>
      LogsModel(
        employeeName: employeeName ?? this.employeeName,
        employeeId: employeeId ?? this.employeeId,
        transactionDate: transactionDate ?? this.transactionDate,
        workingTime: workingTime ?? this.workingTime,
        attendanceStatus: attendanceStatus ?? this.attendanceStatus,
        weekday: weekday ?? this.weekday,
        recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
        createdOn: createdOn ?? this.createdOn,
        locationIdIn: locationIdIn ?? this.locationIdIn,
        locationIdInName: locationIdInName ?? this.locationIdInName,
        locationIdOutName: locationIdOutName ?? this.locationIdOutName,
        locationIdOut: locationIdOut ?? this.locationIdOut,
        totalTimeInWork: totalTimeInWork ?? this.totalTimeInWork,
        recordedTimeOut: recordedTimeOut ?? this.recordedTimeOut,
        attendanceTransactionId:
            attendanceTransactionId ?? this.attendanceTransactionId,
        inLongitude: inLongitude ?? this.inLongitude,
        inLatitude: inLatitude ?? this.inLatitude,
        outLongitude: outLongitude ?? this.outLongitude,
        outLatitude: outLatitude ?? this.outLatitude,
      );

  factory LogsModel.fromRawJson(String str) =>
      LogsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LogsModel.fromJson(Map<String, dynamic> json) => LogsModel(
        employeeName: json["employee_name"],
        employeeId: json["employee_id"],
        transactionDate: DateTime.parse(json["transaction_date"]),
        workingTime: json["working_time"] ?? '',
        attendanceStatus: json["attendance_status"],
        weekday: json["weekday"],
        recordedTimeIn: DateTime.parse(json["recorded_time_in"]),
        createdOn: DateTime.parse(json["created_on"]),
        locationIdIn: json["location_id_in"],
        locationIdInName: json["location_id_in_name"],
        locationIdOutName: json["location_id_out_name"],
        locationIdOut: json["location_id_out"],
        totalTimeInWork: json["total_time_in_work"],
        recordedTimeOut: json["recorded_time_out"] != null
            ? DateTime.parse(json["recorded_time_out"])
            : null,
        attendanceTransactionId: json["attendance_transaction_id"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
        outLongitude: json["out_longitude"],
        outLatitude: json["out_latitude"],
      );

  Map<String, dynamic> toJson() => {
        "employee_name": employeeName,
        "employee_id": employeeId,
        "transaction_date": transactionDate!.toIso8601String(),
        "working_time": workingTime,
        "attendance_status": attendanceStatus,
        "weekday": weekday,
        "recorded_time_in": recordedTimeIn!.toIso8601String(),
        "created_on": createdOn!.toIso8601String(),
        "location_id_in": locationIdIn,
        "location_id_in_name": locationIdInName,
        "location_id_out_name": locationIdOutName,
        "location_id_out": locationIdOut,
        "total_time_in_work": totalTimeInWork,
        "recorded_time_out": recordedTimeOut!.toIso8601String(),
        "attendance_transaction_id": attendanceTransactionId,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
        "out_longitude": outLongitude,
        "out_latitude": outLatitude,
      };

  @override
  String toString() {
    return 'LogsModel(employeeName: $employeeName, employeeId: $employeeId, transactionDate: $transactionDate, workingTime: $workingTime, attendanceStatus: $attendanceStatus, weekday: $weekday, recordedTimeIn: $recordedTimeIn, createdOn: $createdOn, locationIdIn: $locationIdIn, locationIdInName: $locationIdInName, locationIdOutName: $locationIdOutName, locationIdOut: $locationIdOut, totalTimeInWork: $totalTimeInWork, recordedTimeOut: $recordedTimeOut, attendanceTransactionId: $attendanceTransactionId, inLongitude: $inLongitude, inLatitude: $inLatitude, outLongitude: $outLongitude, outLatitude: $outLatitude)';
  }
}
