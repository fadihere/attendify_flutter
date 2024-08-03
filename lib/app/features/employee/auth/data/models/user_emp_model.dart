// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserEmpModel {
  @Id(assignable: true)
  int id = 0;
  final String employersId;
  final String employeeId;
  final String employeesId;
  final String password;
  final String primKey;
  final String employeeName;
  final String jobDesignation;
  String phoneNumber;
  final bool multipleLocations;
  final int passwordCount;
  final String imageUrl;
  final bool isActive;
  final int createdBy;
  @Property(type: PropertyType.date)
  final DateTime createdOn;
  @Property(type: PropertyType.date)
  final DateTime updatedOn;
  final String token;
  final String organizationName;
  final String employerId;
  final int? departmentId;
  final int locationId;
  final String employerToken;

  UserEmpModel({
    required this.employersId,
    required this.employeeId,
    required this.employeesId,
    required this.password,
    required this.primKey,
    required this.employeeName,
    required this.jobDesignation,
    required this.phoneNumber,
    required this.multipleLocations,
    required this.passwordCount,
    required this.imageUrl,
    required this.isActive,
    required this.createdBy,
    required this.createdOn,
    required this.updatedOn,
    required this.token,
    required this.organizationName,
    required this.employerId,
    this.departmentId,
    required this.locationId,
    required this.employerToken,
  });

  UserEmpModel copyWith({
    String? employersId,
    String? employeeId,
    String? employeesId,
    String? password,
    String? primKey,
    String? employeeName,
    String? jobDesignation,
    String? phoneNumber,
    bool? multipleLocations,
    int? passwordCount,
    String? imageUrl,
    bool? isActive,
    int? createdBy,
    DateTime? createdOn,
    DateTime? updatedOn,
    String? token,
    String? organizationName,
    String? employerId,
    int? departmentId,
    int? locationId,
    String? employerToken,
  }) =>
      UserEmpModel(
        employersId: employersId ?? this.employersId,
        employeeId: employeeId ?? this.employeeId,
        employeesId: employeesId ?? this.employeesId,
        password: password ?? this.password,
        primKey: primKey ?? this.primKey,
        employeeName: employeeName ?? this.employeeName,
        jobDesignation: jobDesignation ?? this.jobDesignation,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        multipleLocations: multipleLocations ?? this.multipleLocations,
        passwordCount: passwordCount ?? this.passwordCount,
        imageUrl: imageUrl ?? this.imageUrl,
        isActive: isActive ?? this.isActive,
        createdBy: createdBy ?? this.createdBy,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn,
        token: token ?? this.token,
        organizationName: organizationName ?? this.organizationName,
        employerId: employerId ?? this.employerId,
        departmentId: departmentId ?? this.departmentId,
        locationId: locationId ?? this.locationId,
        employerToken: employerToken ?? this.employerToken,
      );

  factory UserEmpModel.fromJson(String str) =>
      UserEmpModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserEmpModel.fromMap(Map<String, dynamic> json) => UserEmpModel(
        employersId: json["employers_id"],
        employeeId: json["employee_id"],
        employeesId: json["employees_id"],
        password: json["password"],
        primKey: json["prim_key"],
        employeeName: json["employee_name"],
        jobDesignation: json["job_designation"],
        phoneNumber: json["phone_number"],
        multipleLocations: json["multiple_locations"],
        passwordCount: json["password_count"],
        imageUrl: '${AppConst.baseurl}/media/${json["image_url"]}',
        isActive: json["is_active"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        token: json["token"] ?? "",
        organizationName: json["organization_name"] ?? "",
        employerId: json["employer_id"],
        departmentId: json["department_id"] ?? 0,
        locationId: json["location_id"],
        employerToken: json["employer_token"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "employers_id": employersId,
        "employee_id": employeeId,
        "employees_id": employeesId,
        "password": password,
        "prim_key": primKey,
        "employee_name": employeeName,
        "job_designation": jobDesignation,
        "phone_number": phoneNumber,
        "multiple_locations": multipleLocations,
        "password_count": passwordCount,
        "image_url": imageUrl,
        "is_active": isActive,
        "created_by": createdBy,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "token": token,
        "organization_name": organizationName,
        "employer_id": employerId,
        "department_id": departmentId,
        "location_id": locationId,
        "employer_token": employerToken,
      };

  @override
  String toString() {
    return 'UserEmpModel(id: $id, employersId: $employersId, employeeId: $employeeId, employeesId: $employeesId, password: $password, primKey: $primKey, employeeName: $employeeName, jobDesignation: $jobDesignation, phoneNumber: $phoneNumber, multipleLocations: $multipleLocations, passwordCount: $passwordCount, imageUrl: $imageUrl, isActive: $isActive, createdBy: $createdBy, createdOn: $createdOn, updatedOn: $updatedOn, token: $token, organizationName: $organizationName, employerId: $employerId, departmentId: $departmentId, locationId: $locationId, employerToken: $employerToken)';
  }
}
