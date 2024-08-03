// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class UserEmrModel {
  @Id(assignable: true)
  int id = 0;
  final String employerId;
  final String organizationName;
  final String emailAddress;
  final String? imageUrl;
  final bool isActive;
  final bool isDeleted;
  @Property(type: PropertyType.date)
  final DateTime? createdOn;
  @Property(type: PropertyType.date)
  final DateTime? updatedOn;
  final String token;
  final int intervalValue;

  UserEmrModel({
    required this.employerId,
    required this.organizationName,
    required this.emailAddress,
    this.imageUrl,
    required this.isActive,
    required this.isDeleted,
    required this.createdOn,
    required this.updatedOn,
    required this.token,
    this.intervalValue = 0,
  });

  factory UserEmrModel.fromJson(String str) =>
      UserEmrModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserEmrModel.fromMap(Map<String, dynamic> json) => UserEmrModel(
        employerId: json["employer_id"],
        organizationName: json["organization_name"],
        emailAddress: json["email_address"],
        imageUrl: json["image_url"],
        isActive: json["is_active"],
        intervalValue: json["interval_value"],
        isDeleted: json["is_deleted"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
        token: json["token"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "employer_id": employerId,
        "organization_name": organizationName,
        "email_address": emailAddress,
        "image_url": imageUrl,
        "is_active": isActive,
        "interval_value": intervalValue,
        "is_deleted": isDeleted,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
        "token": token,
      };

  UserEmrModel copyWith({
    String? employerId,
    String? organizationName,
    String? emailAddress,
    String? imageUrl,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdOn,
    DateTime? updatedOn,
    String? token,
    int? intervalValue,
  }) {
    return UserEmrModel(
      employerId: employerId ?? this.employerId,
      organizationName: organizationName ?? this.organizationName,
      emailAddress: emailAddress ?? this.emailAddress,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      token: token ?? this.token,
      intervalValue: intervalValue ?? this.intervalValue,
    );
  }

  @override
  String toString() {
    return 'UserEmrModel(id: $id, employerId: $employerId, organizationName: $organizationName, emailAddress: $emailAddress, imageUrl: $imageUrl, isActive: $isActive, isDeleted: $isDeleted, createdOn: $createdOn, updatedOn: $updatedOn, token: $token, intervalValue: $intervalValue)';
  }
}
