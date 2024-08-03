// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final leavePolicyModel = leavePolicyModelFromMap(jsonString);

import 'dart:convert';

LeavePolicyModel leavePolicyModelFromMap(String str) =>
    LeavePolicyModel.fromMap(json.decode(str));

String leavePolicyModelToMap(LeavePolicyModel data) =>
    json.encode(data.toMap());

class LeavePolicyModel {
  int? id;
  String? categoryName;
  String? categoryType;
  String? status;
  String? message;
  int? allowance;
  String? employersId;
  DateTime? createdOn;
  DateTime? updatedOn;
  DateTime? fromDate;
  DateTime? toDate;
  String? employerId;

  LeavePolicyModel({
    this.id,
    this.categoryName,
    this.categoryType,
    this.status,
    this.message,
    this.allowance,
    this.employersId,
    this.createdOn,
    this.updatedOn,
    this.fromDate,
    this.toDate,
    this.employerId,
  });

  factory LeavePolicyModel.fromMap(Map<String, dynamic> json) =>
      LeavePolicyModel(
        id: json["id"] ?? 0,
        categoryName: json["category_name"] ?? '',
        categoryType: json["category_type"] ?? '',
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        allowance: json["allowance"] ?? 0,
        employersId: json["employers_id"] ?? '',
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
        fromDate: json["from_date"] == null
            ? null
            : DateTime.parse(json["from_date"]),
        toDate:
            json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
        employerId: json["employer_id"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_name": categoryName,
        "category_type": categoryType,
        "status": status,
        "message": message,
        "allowance": allowance,
        "employers_id": employersId,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
        "from_date": fromDate?.toIso8601String(),
        "to_date": toDate?.toIso8601String(),
        "employer_id": employerId,
      };

  LeavePolicyModel copyWith({
    int? id,
    String? categoryName,
    String? categoryType,
    String? status,
    String? message,
    int? allowance,
    String? employersId,
    DateTime? createdOn,
    DateTime? updatedOn,
    DateTime? fromDate,
    DateTime? toDate,
    String? employerId,
  }) {
    return LeavePolicyModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      status: status ?? this.status,
      message: message ?? this.message,
      allowance: allowance ?? this.allowance,
      employersId: employersId ?? this.employersId,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      employerId: employerId ?? this.employerId,
    );
  }
}
