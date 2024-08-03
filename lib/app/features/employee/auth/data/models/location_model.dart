// To parse this JSON data, do
//
//     final employeeLocationModel = employeeLocationModelFromJson(jsonString);

import 'dart:convert';

LocationEmpModel employeeLocationModelFromJson(String str) =>
    LocationEmpModel.fromJson(json.decode(str));

String employeeLocationModelToJson(LocationEmpModel data) =>
    json.encode(data.toJson());

class LocationEmpModel {
  final String? departmentId;
  final String locationId;
  final String employerId;
  final String locationName;
  final String longitude;
  final String latitude;
  final String allowedRadius;
  final bool isActive;
  final bool isDeleted;
  final String createdBy;

  LocationEmpModel({
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

  factory LocationEmpModel.fromJson(Map<String, dynamic> json) =>
      LocationEmpModel(
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


// class EmployeeLocationModel {
//   int? employerId;
//   int? locationId;
//   String? locationName;
//   String? longitude;
//   String? latitude;
//   bool? isActive;
//   String? createdOn;
//   int? createdBy;
//
//   EmployeeLocationModel(
//       {this.employerId,
//       this.locationId,
//       this.locationName,
//       this.longitude,
//       this.latitude,
//       this.isActive,
//       this.createdOn,
//       this.createdBy});
//
//   EmployeeLocationModel.fromJson(Map<String, dynamic> json) {
//     employerId = json['EmployerId'];
//     locationId = json['LocationId'];
//     locationName = json['LocationName'];
//     longitude = json['Longitude'];
//     latitude = json['Latitude'];
//     isActive = json['IsActive'];
//     createdOn = json['CreatedOn'];
//     createdBy = json['CreatedBy'];
//   }
//
// }