import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  final String? departmentId;
  final String? locationId;
  final String? employerId;
  final String? locationName;
  final String? longitude;
  final String? latitude;
  final String? allowedRadius;
  final bool? isActive;
  final bool? isDeleted;
  final String? createdBy;

  LocationModel({
    required this.departmentId,
    required this.locationId,
    required this.employerId,
    required this.locationName,
    required this.longitude,
    required this.latitude,
    required this.allowedRadius,
    required this.isActive,
    required this.isDeleted,
    required this.createdBy,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        departmentId: json["department_id"],
        locationId: json["location_id"].toString(),
        employerId: json["employer_id"].toString(),
        locationName: json["location_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        allowedRadius: json["allowed_radius"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "department_id": departmentId,
        "location_id": locationId,
        "employer_id": employerId,
        "location_name": locationName,
        "longitude": longitude,
        "latitude": latitude,
        "allowed_radius": allowedRadius,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_by": createdBy,
      };
}
