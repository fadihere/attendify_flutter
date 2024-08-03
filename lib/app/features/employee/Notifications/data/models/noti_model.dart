// To parse this JSON data, do
//
//     final notiModel = notiModelFromMap(jsonString);

import 'dart:convert';

List<NotiModel> notiModelFromMap(String str) =>
    List<NotiModel>.from(json.decode(str).map((x) => NotiModel.fromMap(x)));

String notiModelToMap(List<NotiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class NotiModel {
  String? employeeId;
  String? employerId;
  String? title;
  String? subTitle;
  DateTime? dateAndTime;
  int? notificationId;
  int? attendanceId;
  String? currentLong;
  String? currentLat;
  bool? isSeen;
  String? notificationType;

  NotiModel({
    this.employeeId,
    this.employerId,
    this.title,
    this.subTitle,
    this.dateAndTime,
    this.notificationId,
    this.attendanceId,
    this.currentLong,
    this.currentLat,
    this.isSeen,
    this.notificationType,
  });

  NotiModel copyWith({
    String? employeeId,
    String? employerId,
    String? title,
    String? subTitle,
    DateTime? dateAndTime,
    int? notificationId,
    int? attendanceId,
    String? currentLong,
    String? currentLat,
    bool? isSeen,
    String? notificationType,
  }) =>
      NotiModel(
        employeeId: employeeId ?? this.employeeId,
        employerId: employerId ?? this.employerId,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        dateAndTime: dateAndTime ?? this.dateAndTime,
        notificationId: notificationId ?? this.notificationId,
        attendanceId: attendanceId ?? this.attendanceId,
        currentLong: currentLong ?? this.currentLong,
        currentLat: currentLat ?? this.currentLat,
        isSeen: isSeen ?? this.isSeen,
        notificationType: notificationType ?? this.notificationType,
      );

  factory NotiModel.fromMap(Map<String, dynamic> json) => NotiModel(
        employeeId: json["employee_id"],
        employerId: json["employer_id"],
        title: json["title"],
        subTitle: json["sub_title"],
        dateAndTime: json["date_and_time"] == null
            ? null
            : DateTime.parse(json["date_and_time"]),
        notificationId: json["notification_id"],
        attendanceId: json["attendance_id"],
        currentLong: json["current_long"],
        currentLat: json["current_lat"],
        isSeen: json["is_seen"],
        notificationType: json["notification_type"],
      );

  Map<String, dynamic> toMap() => {
        "employee_id": employeeId,
        "employer_id": employerId,
        "title": title,
        "sub_title": subTitle,
        "date_and_time": dateAndTime?.toIso8601String(),
        "notification_id": notificationId,
        "attendance_id": attendanceId,
        "current_long": currentLong,
        "current_lat": currentLat,
        "is_seen": isSeen,
        "notification_type": notificationType,
      };

  factory NotiModel.fromJson(Map<String, dynamic> json) => NotiModel(
        employeeId: json["employee_id"],
        employerId: json["employer_id"],
        title: json["title"],
        subTitle: json["sub_title"],
        dateAndTime: json["date_and_time"] == null
            ? null
            : DateTime.parse(json["date_and_time"]),
        notificationId: json["notification_id"],
        attendanceId: json["attendance_id"],
        currentLong: json["current_long"],
        currentLat: json["current_lat"],
        isSeen: json["is_seen"],
        notificationType: json["notification_type"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "employer_id": employerId,
        "title": title,
        "sub_title": subTitle,
        "date_and_time": dateAndTime?.toIso8601String(),
        "notification_id": notificationId,
        "attendance_id": attendanceId,
        "current_long": currentLong,
        "current_lat": currentLat,
        "is_seen": isSeen,
        "notification_type": notificationType,
      };
}
