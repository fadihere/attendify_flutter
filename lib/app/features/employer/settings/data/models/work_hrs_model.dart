// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final updateOfficeHrsModel = updateOfficeHrsModelFromJson(jsonString);

import 'dart:convert';

WorkHrsModel workHrsModelFromJson(String str) =>
    WorkHrsModel.fromJson(json.decode(str));

String workHrsModelToJson(WorkHrsModel data) => json.encode(data.toJson());

class WorkHrsModel {
  String startTime;
  String endTime;
  String gracePeriod;
  List<String> workingDays;
  String employersId;

  WorkHrsModel({
    required this.startTime,
    required this.endTime,
    required this.gracePeriod,
    required this.workingDays,
    required this.employersId,
  });
  factory WorkHrsModel.fromJson(Map<String, dynamic> json) => WorkHrsModel(
        startTime: json["start_time"],
        endTime: json["end_time"],
        gracePeriod: json["grace_period"],
        workingDays: List<String>.from(json["working_days"].map((x) => x)),
        employersId: json["employers_id"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
        "grace_period": gracePeriod,
        "working_days": List<String>.from(workingDays.map((x) => x)),
        "employers_id": employersId,
      };

  WorkHrsModel copyWith({
    String? startTime,
    String? endTime,
    String? gracePeriod,
    List<String>? workingDays,
    String? employersId,
  }) {
    return WorkHrsModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      gracePeriod: gracePeriod ?? this.gracePeriod,
      workingDays: workingDays ?? this.workingDays,
      employersId: employersId ?? this.employersId,
    );
  }
}
