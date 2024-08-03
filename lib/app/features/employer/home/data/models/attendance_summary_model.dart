// To parse this JSON data, do
//
//     final attendanceSummaryModel = attendanceSummaryModelFromJson(jsonString);

//333 step

import 'dart:convert';

AttendanceSummaryModel attendanceSummaryModelFromJson(String str) => AttendanceSummaryModel.fromJson(json.decode(str));

String attendanceSummaryModelToJson(AttendanceSummaryModel data) => json.encode(data.toJson());

class AttendanceSummaryModel {
    int count;
    int absent;
    int present;
    int wfh;
    int late;

    AttendanceSummaryModel({
        required this.count,
        required this.absent,
        required this.present,
        required this.wfh,
        required this.late,
    });

    factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) => AttendanceSummaryModel(
        count: json["count"],
        absent: json["absent"],
        present: json["present"],
        wfh: json["wfh"],
        late: json["late"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "absent": absent,
        "present": present,
        "wfh": wfh,
        "late": late,
    };
}
