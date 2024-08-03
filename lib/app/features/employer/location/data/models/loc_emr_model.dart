// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LocEmrModel {
  final String employerId;
  final int locationId;
  final String? employersId;
  final String? departmentId;
  final String locationName;
  final String longitude;
  final String latitude;
  final String allowedRadius;
  final bool isActive;
  final bool isDeleted;
  final int createdBy;
  final DateTime? createdOn;

  LocEmrModel({
    required this.employerId,
    required this.locationId,
    this.employersId,
    this.departmentId,
    required this.locationName,
    required this.longitude,
    required this.latitude,
    required this.allowedRadius,
    required this.isActive,
    required this.isDeleted,
    required this.createdBy,
    this.createdOn,
  });

  LocEmrModel copyWith({
    String? employerId,
    int? locationId,
    String? employersId,
    dynamic departmentId,
    String? locationName,
    String? longitude,
    String? latitude,
    String? allowedRadius,
    bool? isActive,
    bool? isDeleted,
    int? createdBy,
    DateTime? createdOn,
  }) =>
      LocEmrModel(
        employerId: employerId ?? this.employerId,
        locationId: locationId ?? this.locationId,
        employersId: employersId ?? this.employersId,
        departmentId: departmentId ?? this.departmentId,
        locationName: locationName ?? this.locationName,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        allowedRadius: allowedRadius ?? this.allowedRadius,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        createdBy: createdBy ?? this.createdBy,
        createdOn: createdOn ?? this.createdOn,
      );

  factory LocEmrModel.fromJson(String str) =>
      LocEmrModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocEmrModel.fromMap(Map<String, dynamic> json) => LocEmrModel(
        employerId: json["employer_id"],
        locationId: json["location_id"],
        employersId: json["employers_id"],
        departmentId: json["department_id"],
        locationName: json["location_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        allowedRadius: json["allowed_radius"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdOn: json["created_on"] != null
            ? DateTime.parse(json["created_on"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "employer_id": employerId,
        "location_id": locationId,
        "employers_id": employersId,
        "department_id": departmentId,
        "location_name": locationName,
        "longitude": longitude,
        "latitude": latitude,
        "allowed_radius": allowedRadius,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_on": createdOn?.toIso8601String(),
      };

  @override
  String toString() {
    return 'LocEmrModel(employerId: $employerId, locationId: $locationId, employersId: $employersId, departmentId: $departmentId, locationName: $locationName, longitude: $longitude, latitude: $latitude, allowedRadius: $allowedRadius, isActive: $isActive, isDeleted: $isDeleted, createdBy: $createdBy, createdOn: $createdOn)';
  }
}
