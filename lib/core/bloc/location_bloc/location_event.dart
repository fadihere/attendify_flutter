part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReqLocationServiceEvent extends LocationEvent {}

class ReqLocationPermissionEvent extends LocationEvent {
  final int locationId;

  ReqLocationPermissionEvent({
    required this.locationId,
  });
}

class IsMockLocationEvent extends LocationEvent {
  final bool isMocked;

  IsMockLocationEvent({
    required this.isMocked,
  });
}

class ReqEmrLocPermissionEvent extends LocationEvent {
  ReqEmrLocPermissionEvent();
}

class FetchLocationEvent extends LocationEvent {
  final int locationId;
  FetchLocationEvent({
    required this.locationId,
  });
}
