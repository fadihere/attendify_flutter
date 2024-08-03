import 'dart:convert';

class CheckInModel {
  final String employerId;
  final String employeesId;
  final DateTime? recordedTimeIn;
  final String attendanceChoices;
  final int? inLocationId;
  final bool? requestApproved;
  final String? inLongitude;
  final String? inLatitude;
  final String? message;
  final int? leavePolicyEmp;

  CheckInModel({
    required this.employerId,
    required this.employeesId,
    required this.attendanceChoices,
    this.requestApproved,
    this.recordedTimeIn,
    this.inLocationId,
    this.inLongitude,
    this.inLatitude,
    this.message,
    this.leavePolicyEmp,
  });

  CheckInModel copyWith({
    String? employerId,
    String? employeesId,
    int? departmentId,
    DateTime? recordedTimeIn,
    String? attendanceChoices,
    int? inLocationId,
    int? outLocationId,
    bool? requestApproved,
    String? inLongitude,
    String? inLatitude,
    DateTime? recordedTimeOut,
    String? outLongitude,
    String? outLatitude,
    String? message,
    final int? leavePolicyEmp,
  }) =>
      CheckInModel(
        employerId: employerId ?? this.employerId,
        employeesId: employeesId ?? this.employeesId,
        recordedTimeIn: recordedTimeIn ?? this.recordedTimeIn,
        attendanceChoices: attendanceChoices ?? this.attendanceChoices,
        inLocationId: inLocationId ?? this.inLocationId,
        requestApproved: requestApproved ?? this.requestApproved,
        inLongitude: inLongitude ?? this.inLongitude,
        inLatitude: inLatitude ?? this.inLatitude,
        leavePolicyEmp: leavePolicyEmp ?? this.leavePolicyEmp,
        message: message ?? this.message,
      );

  factory CheckInModel.fromRawJson(String str) =>
      CheckInModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
        employerId: json["employer_id"],
        employeesId: json["employees_id"],
        recordedTimeIn: DateTime.parse(json["recorded_time_in"]),
        attendanceChoices: json["attendance_choices"],
        inLocationId: json["in_location_id"],
        requestApproved: json["request_approved"],
        inLongitude: json["in_longitude"],
        inLatitude: json["in_latitude"],
        leavePolicyEmp: json["leave_policy_emp"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "employer_id": employerId,
        "employees_id": employeesId,
        "recorded_time_in": recordedTimeIn?.toString().replaceAll(" ", "T"),
        "attendance_choices": attendanceChoices,
        "in_location_id": inLocationId,
        "request_approved": requestApproved,
        "in_longitude": inLongitude,
        "in_latitude": inLatitude,
        "leave_policy_emp": leavePolicyEmp,
        "message": message,
      };
}
