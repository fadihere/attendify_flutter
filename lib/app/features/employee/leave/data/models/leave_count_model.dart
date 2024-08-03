// To parse this JSON data, do
//
//     final leaveCountModel = leaveCountModelFromMap(jsonString);

import 'dart:convert';

LeaveCountModel leaveCountModelFromMap(String str) =>
    LeaveCountModel.fromMap(json.decode(str));

String leaveCountModelToMap(LeaveCountModel data) => json.encode(data.toMap());

class LeaveCountModel {
  int? leaveTaken;
  int? totalAllowanceCount;

  LeaveCountModel({
    this.leaveTaken,
    this.totalAllowanceCount,
  });

  LeaveCountModel copyWith({
    int? leaveTaken,
    int? totalAllowanceCount,
  }) =>
      LeaveCountModel(
        leaveTaken: leaveTaken ?? this.leaveTaken,
        totalAllowanceCount: totalAllowanceCount ?? this.totalAllowanceCount,
      );

  factory LeaveCountModel.fromMap(Map<String, dynamic> json) => LeaveCountModel(
        leaveTaken: json["leave_taken"],
        totalAllowanceCount: json["total_allowance_count"],
      );

  Map<String, dynamic> toMap() => {
        "leave_taken": leaveTaken,
        "total_allowance_count": totalAllowanceCount,
      };
}
