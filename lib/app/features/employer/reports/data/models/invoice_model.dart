// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<InvoiceModel> csTotalModelFromJson(str) {
  List<InvoiceModel> data = [];
  if (str.isNotEmpty) {
    str.forEach((element) {
      data.add(InvoiceModel.fromJson(element));
    });
  }
  return data;
}

String csTotalModelToJson(List<InvoiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class InvoiceModel {
//   const InvoiceModel({
//     required this.id,
//     required this.name,
//     required this.status,
//     required this.date,
//     required this.dateOut,
//     required this.weekDay,
//     required this.workingtime,
//   });

//   final String id;
//   final String name;
//   final String status;
//   final DateTime date;
//   final DateTime dateOut;
//   final String weekDay;
//   final String workingtime;

//   factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
//       id: json["employee_id"],
//       name: json["employee_name"],
//       status: json["attendance_status"],
//       date: DateTime.parse(json["recorded_time_in"]),
//       dateOut: DateTime.parse(json["recorded_time_out"] ??
//           DateTime.now().copyWith(hour: 00, minute: 00, second: 00).toString()),
//       weekDay: json["weekday"],
//       workingtime: json["working_time"] ?? "");

//   Map<String, dynamic> toJson() => {
//         "employee_id": id,
//         "employee_name": name,
//         "attendance_status": status,
//         "recorded_time_in": date,
//         "recorded_time_out": dateOut,
//         "weekday": weekDay,
//         "working_time": workingtime,
//       };

//   @override
//   String toString() {
//     return 'InvoiceModel(id: $id, name: $name, status: $status, date: $date, dateOut: $dateOut, weekDay: $weekDay, working_time: $workingtime)';
//   }
// }



// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromMap(jsonString);


List<InvoiceModel> invoiceModelFromMap(String str) => List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));

String invoiceModelToMap(List<InvoiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceModel {
    final String name;
    final String id;
    final DateTime transactionDate;
    final String? workingTime;
    final String status;
    final String weekday;
    final DateTime date;
    final String? totalTimeInWork;
    final DateTime dateOut;

    InvoiceModel({
        required this.name,
        required this.id,
        required this.transactionDate,
        required this.workingTime,
        required this.status,
        required this.weekday,
        required this.date,
        required this.totalTimeInWork,
        required this.dateOut,
    });

    factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        name: json["employee_name"],
        id: json["employee_id"],
        transactionDate: DateTime.parse(json["transaction_date"]),
        workingTime: json["working_time"],
        status: json["attendance_status"],
        weekday: json["weekday"],
        date: DateTime.parse(json["recorded_time_in"]??DateTime.now().copyWith(hour: 00, minute: 00, second: 00).toString()),
        totalTimeInWork: json["total_time_in_work"]??DateTime.now().copyWith(hour: 00, minute: 00, second: 00).toString(),
        dateOut: DateTime.parse(json["recorded_time_out"]?? DateTime.now().copyWith(hour: 00, minute: 00, second: 00).toString()),
    );

    Map<String, dynamic> toJson() => {
        "employee_name": name,
        "employee_id": id,
        "transaction_date": transactionDate.toIso8601String(),
        "working_time": workingTime,
        "attendance_status": status,
        "weekday": weekday,
        "recorded_time_in": date.toIso8601String(),
        "total_time_in_work": totalTimeInWork,
        "recorded_time_out": dateOut.toIso8601String(),
    };
}
