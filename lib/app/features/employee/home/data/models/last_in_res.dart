// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LastInModel {
  final String? employeeId;
  final DateTime? transactionDate;
  final String? attendanceStatus;
  final DateTime? createdOn;
  final int? locationIdIn;
  final int? locationIdOut;
  final Duration? totalTimeInWork;
  final DateTime? recordedTimeIn;
  final DateTime? recordedTimeOut;
  final int? attendanceTransactionId;
  final bool? requestApproved;

  LastInModel({
    required this.employeeId,
    required this.transactionDate,
    required this.attendanceStatus,
    required this.createdOn,
    required this.locationIdIn,
    required this.locationIdOut,
    required this.totalTimeInWork,
    required this.recordedTimeIn,
    required this.recordedTimeOut,
    required this.attendanceTransactionId,
    required this.requestApproved,
  });

  factory LastInModel.fromRawJson(String str) =>
      LastInModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastInModel.fromJson(Map<String, dynamic> json) {
    return LastInModel(
      employeeId: json["employee_id"],
      transactionDate: json["transaction_date"] != null
          ? DateTime.parse(json["transaction_date"])
          : null,
      attendanceStatus: json["attendance_status"],
      createdOn: json["created_on"] != null
          ? DateTime.parse(json["created_on"])
          : null,
      locationIdIn: json["location_id_in"],
      locationIdOut: json["location_id_out"],
      totalTimeInWork: null,
      recordedTimeIn: json["recorded_time_in"] != null
          ? DateTime.parse(json["recorded_time_in"])
          : null,
      recordedTimeOut: json["recorded_time_out"] != null
          ? DateTime.parse(json["recorded_time_out"])
          : null,
      attendanceTransactionId: json["attendance_transaction_id"],
      requestApproved: json["request_approved"],
    );
  }

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "transaction_date": transactionDate?.toIso8601String(),
        "attendance_status": attendanceStatus,
        "created_on": createdOn?.toIso8601String(),
        "location_id_in": locationIdIn,
        "location_id_out": locationIdOut,
        "total_time_in_work": totalTimeInWork,
        "recorded_time_in": recordedTimeIn?.toIso8601String(),
        "recorded_time_out": recordedTimeOut,
        "attendance_transaction_id": attendanceTransactionId,
        "request_approved": requestApproved,
      };

  @override
  String toString() {
    return 'LastInModel(employeeId: $employeeId, transactionDate: $transactionDate, attendanceStatus: $attendanceStatus, createdOn: $createdOn, locationIdIn: $locationIdIn, locationIdOut: $locationIdOut, totalTimeInWork: $totalTimeInWork, recordedTimeIn: $recordedTimeIn, recordedTimeOut: $recordedTimeOut, attendanceTransactionId: $attendanceTransactionId, requestApproved: $requestApproved)';
  }

  LastInModel copyWith({
    String? employeeId,
    DateTime? transactionDate,
    String? attendanceStatus,
    DateTime? createdOn,
    int? locationIdIn,
    int? locationIdOut,
    Duration? totalTimeInWork,
    DateTime? recordedTimeIn,
    DateTime? recordedTimeOut,
    int? attendanceTransactionId,
    bool? requestApproved,
  }) {
    return LastInModel(
      employeeId: employeeId ?? this.employeeId,
      transactionDate: transactionDate ?? this.transactionDate,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      createdOn: createdOn ?? this.createdOn,
      locationIdIn: locationIdIn ?? this.locationIdIn,
      locationIdOut: locationIdOut ?? this.locationIdOut,
      totalTimeInWork: totalTimeInWork ?? this.totalTimeInWork,
      recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
      recordedTimeOut: recordedTimeOut ?? this.recordedTimeOut,
      attendanceTransactionId: attendanceTransactionId ?? this.attendanceTransactionId,
      requestApproved: requestApproved ?? this.requestApproved,
    );
  }
}
