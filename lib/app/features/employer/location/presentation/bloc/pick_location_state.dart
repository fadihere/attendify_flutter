// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pick_location_bloc.dart';

class PickLocationState extends Equatable {
  final Status status;
  final List<LocEmrModel> locationsList;
  final double radius;

  final LocEmrModel? selectedAssignLoc;
  const PickLocationState({
    this.status = Status.initial,
    this.locationsList = const [],
    this.radius = 100.0,
    this.selectedAssignLoc,
  });

  @override
  List<Object?> get props => [
        status,
        locationsList,
        radius,
        selectedAssignLoc,
      ];

  PickLocationState copyWith(
      {Status? status,
      List<LocEmrModel>? locationsList,
      double? radius,
      LocEmrModel? selectedAssignLoc}) {
    return PickLocationState(
      status: status ?? this.status,
      locationsList: locationsList ?? this.locationsList,
      radius: radius ?? this.radius,
      selectedAssignLoc: selectedAssignLoc ?? this.selectedAssignLoc,
    );
  }
}
