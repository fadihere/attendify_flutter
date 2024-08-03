// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:attendify_lite/core/enums/status.dart';

class LocationState extends Equatable {
  final bool isServiceEnabled;
  final bool isPermissionEnabled;
  final String? current;
  final double? lat;
  final double? long;
  final bool isAtOffice;
  final Status status;
  final bool isMock;

  const LocationState({
    this.isServiceEnabled = false,
    this.isPermissionEnabled = false,
    this.current,
    this.lat,
    this.long,
    this.status = Status.initial,
    this.isAtOffice = true,
    this.isMock = false,
  });

  @override
  List<Object?> get props => [
        isServiceEnabled,
        isPermissionEnabled,
        current,
        isAtOffice,
        long,
        lat,
        status,
        isMock,
      ];

  @override
  bool? get stringify => true;



  LocationState copyWith({
    bool? isServiceEnabled,
    bool? isPermissionEnabled,
    String? current,
    double? lat,
    double? long,
    bool? isAtOffice,
    Status? status,
    bool? isMock,
  }) {
    return LocationState(
      isServiceEnabled: isServiceEnabled ?? this.isServiceEnabled,
      isPermissionEnabled: isPermissionEnabled ?? this.isPermissionEnabled,
      current: current ?? this.current,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      isAtOffice: isAtOffice ?? this.isAtOffice,
      status: status ?? this.status,
      isMock: isMock ?? this.isMock,
    );
  }
}
