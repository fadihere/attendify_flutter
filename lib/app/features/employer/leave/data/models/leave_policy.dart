// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LeavePolicy {
  final String categoryName;
  final String? categoryType;
  final String status;
  final String? message;
  final int allowance;
  final String employersId;
  final String? toDate;
  final String? fromDate;
  final String employerId;
  LeavePolicy({
    required this.categoryName,
    this.categoryType,
    required this.status,
    this.message,
    required this.allowance,
    required this.employersId,
    this.toDate,
    this.fromDate,
    required this.employerId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category_name': categoryName,
      'category_type': categoryType,
      'status': status,
      'message': message,
      'allowance': allowance,
      'employers_id': employersId,
      'to_date': toDate,
      'from_date': fromDate,
      'employer_id': employerId,
    };
  }

  factory LeavePolicy.fromMap(Map<String, dynamic> map) {
    return LeavePolicy(
      categoryName: map['categoryName'] as String,
      categoryType:
          map['categoryType'] != null ? map['categoryType'] as String : null,
      status: map['status'] as String,
      message: map['message'] != null ? map['message'] as String : null,
      allowance: map['allowance'] as int,
      employersId: map['employers_id'] as String,
      toDate: map['to_date'] != null ? map['to_date'] as String : null,
      fromDate: map['from_date'] != null ? map['from_date'] as String : null,
      employerId: map['employer_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeavePolicy.fromJson(String source) =>
      LeavePolicy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LeavePolicy(categoryName: $categoryName, categoryType: $categoryType, status: $status, message: $message, allowance: $allowance, employers_id: $employersId, to_date: $toDate, from_date: $fromDate, employer_id: $employerId)';
  }

  @override
  bool operator ==(covariant LeavePolicy other) {
    if (identical(this, other)) return true;

    return other.categoryName == categoryName &&
        other.categoryType == categoryType &&
        other.status == status &&
        other.message == message &&
        other.allowance == allowance &&
        other.employersId == employersId &&
        other.toDate == toDate &&
        other.fromDate == fromDate &&
        other.employerId == employerId;
  }

  @override
  int get hashCode {
    return categoryName.hashCode ^
        categoryType.hashCode ^
        status.hashCode ^
        message.hashCode ^
        allowance.hashCode ^
        employersId.hashCode ^
        toDate.hashCode ^
        fromDate.hashCode ^
        employerId.hashCode;
  }

  LeavePolicy copyWith({
    String? categoryName,
    String? categoryType,
    String? status,
    String? message,
    int? allowance,
    String? employersId,
    String? toDate,
    String? fromDate,
    String? employerId,
  }) {
    return LeavePolicy(
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      status: status ?? this.status,
      message: message ?? this.message,
      allowance: allowance ?? this.allowance,
      employersId: employersId ?? this.employersId,
      toDate: toDate ?? this.toDate,
      fromDate: fromDate ?? this.fromDate,
      employerId: employerId ?? this.employerId,
    );
  }
}
