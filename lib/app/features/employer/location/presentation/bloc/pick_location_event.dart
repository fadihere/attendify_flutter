// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pick_location_bloc.dart';

abstract class PickLocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllLocationsEvent extends PickLocationEvent {
  final String employerID;
  FetchAllLocationsEvent({
    required this.employerID,
  });
}

class DeleteLocationEvent extends PickLocationEvent {
  final int locationID;

  DeleteLocationEvent({required this.locationID});
}

class SaveLocationEvent extends PickLocationEvent {
  final LocationResult locationResult;
  final String employerID;
  final String locationName;
  SaveLocationEvent({
    required this.locationResult,
    required this.employerID,
    required this.locationName,
  });
}

class SelectLocToAssignEvent extends PickLocationEvent {
  final LocEmrModel locModel;
  SelectLocToAssignEvent({
    required this.locModel,
  });
}

class UpdateLocEvent extends PickLocationEvent {
  final TeamModel user;

  UpdateLocEvent({
    required this.user,
  });
}

class IncOrDecRadiusEvent extends PickLocationEvent {
  final String type;
  IncOrDecRadiusEvent({
    required this.type,
  });
}
