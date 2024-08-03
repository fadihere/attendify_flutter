// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final adminTeamModel = adminTeamModelFromJson(jsonString);

import 'dart:convert';

import '../../../../../../core/constants/app_constants.dart';

TeamModel adminTeamModelFromJson(String str) =>
    TeamModel.fromJson(json.decode(str));

String adminTeamModelToJson(TeamModel data) => json.encode(data.toJson());

class TeamModel {
  final String? employerId;
  final String employeeId;
  final String employeeName;
  final dynamic departmentId;
  final String? jobDesignation;
  final String phoneNumber;
  final String? locationId;
  final String? imageUrl;
  final bool? isActive;
  final bool? multipleLocation;
  final int? createdBy;
  final DateTime? createdOn;
  final String? organizationName;
  final String? employerToken;

  TeamModel(
      {required this.employerId,
      required this.employeeId,
      this.organizationName,
      this.createdOn,
      required this.employeeName,
      this.departmentId,
      this.jobDesignation,
      required this.phoneNumber,
      this.locationId,
      this.imageUrl,
      this.isActive,
      this.multipleLocation,
      this.createdBy,
      this.employerToken});

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
        employerId: json["employer_id"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        departmentId: json["department_id"],
        jobDesignation: json["job_designation"],
        phoneNumber: json["phone_number"],
        locationId: json["location_id"].toString(),
        imageUrl: json["image_url"] != null && json["image_url"].isNotEmpty
            ? '${AppConst.baseurl}media/${json["image_url"]}'
            : null,
        isActive: json["is_active"],
        multipleLocation: json["multiple_locations"],
        createdBy: json["created_by"],
        createdOn: json["created_on"] != null
            ? DateTime.parse(json["created_on"])
            : null,
        organizationName: json["organization_name"],
        employerToken: json["employer_token"],
      );

  Map<String, dynamic> toJson() => {
        "employer_id": employerId,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "department_id": departmentId,
        "job_designation": jobDesignation,
        "phone_number": phoneNumber,
        "location_id": locationId,
        "image_url": imageUrl,
        "is_active": isActive,
        "multiple_locations": multipleLocation,
        "created_by": createdBy,
        "organization_name": organizationName,
        "created_on": createdOn,
        "employer_token": employerToken
      };

  TeamModel copyWith({
    String? employerId,
    String? employeeId,
    String? employeeName,
    dynamic departmentId,
    String? jobDesignation,
    String? phoneNumber,
    String? locationId,
    dynamic imageUrl,
    bool? isActive,
    bool? multipleLocation,
    int? createdBy,
    DateTime? createdOn,
    String? organizationName,
    String? employerToken,
  }) {
    return TeamModel(
      employerId: employerId ?? this.employerId,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      departmentId: departmentId ?? this.departmentId,
      jobDesignation: jobDesignation ?? this.jobDesignation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      locationId: locationId ?? this.locationId,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      multipleLocation: multipleLocation ?? this.multipleLocation,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      organizationName: organizationName ?? this.organizationName,
      employerToken: employerToken ?? this.employerToken,
    );
  }

  @override
  String toString() {
    return 'TeamModel(employerId: $employerId, employeeId: $employeeId, employeeName: $employeeName, departmentId: $departmentId, jobDesignation: $jobDesignation, phoneNumber: $phoneNumber, locationId: $locationId, imageUrl: $imageUrl, isActive: $isActive, multipleLocation: $multipleLocation, createdBy: $createdBy, createdOn: $createdOn, organizationName: $organizationName, employerToken: $employerToken)';
  }
}
