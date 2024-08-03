// To parse this JSON data, do
//
//     final wfhReqModel = wfhReqModelFromJson(jsonString);

import 'dart:convert';

RequestsModel wfhReqModelFromJson(String str) =>
    RequestsModel.fromJson(json.decode(str));

String wfhReqModelToJson(RequestsModel data) => json.encode(data.toJson());

class RequestsModel {
  int? count;
  String? next;
  String? previous;
  List<Result>? results;

  RequestsModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory RequestsModel.fromJson(Map<String, dynamic> json) => RequestsModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] != null
            ? List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  String? employeeId;
  String? employerId;
  DateTime? startDate;
  DateTime? endDate;

  Result({
    required this.employeeId,
    required this.employerId,
    required this.startDate,
    required this.endDate,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        employeeId: json["employee_id"],
        employerId: json["employer_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "employer_id": employerId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
      };
}
