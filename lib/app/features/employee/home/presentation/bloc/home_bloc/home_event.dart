// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchLastTransactionEvent extends HomeEvent {
  final UserEmpModel user;
  const FetchLastTransactionEvent({
    required this.user,
  });
}

class CheckInternetEvent extends HomeEvent {}

class OpenFaceDialogEvent extends HomeEvent {
  final bool isAtOffice;
  const OpenFaceDialogEvent({
    this.isAtOffice = true,
  });
}

class ShowNotificationEvent extends HomeEvent {
  final bool status;
  const ShowNotificationEvent({required this.status});
}

class _OpenWFHDialogEvent extends HomeEvent {}

class InitLivelynessDetectionEvent extends HomeEvent {}

class GetLocationData extends HomeEvent {
  final loc.LocationData location;
  final geocode.Placemark placemark;
  const GetLocationData({required this.location, required this.placemark});
}

class FetchLocationByIDEvent extends HomeEvent {
  final int id;
  const FetchLocationByIDEvent({
    required this.id,
  });
}

class ClockedEvent extends HomeEvent {
  final bool isAtOffice;
  final bool isClockedIn;
  final bool? isApproved;

  final LastInModel lastIn;
  final UserEmpModel user;
  final File file;
  final double lat;
  final double lon;
  const ClockedEvent({
    required this.isClockedIn,
    required this.lastIn,
    required this.user,
    required this.file,
    required this.lat,
    required this.lon,
    this.isAtOffice = true,
    this.isApproved,
  });
}

class CheckUserOfficeorHomeEvent extends HomeEvent {
  final bool isAtOffice;
  final bool? isApproved;
  final bool? isClockedIn;

  const CheckUserOfficeorHomeEvent({
    required this.isAtOffice,
    this.isClockedIn,
    this.isApproved,
  });
}

class ClockedOutEvent extends HomeEvent {
  final UserEmpModel user;
  final File file;
  final double lat;
  final double lon;
  const ClockedOutEvent({
    required this.file,
    required this.lat,
    required this.lon,
    required this.user,
  });
}

class LocationPermissionEvent extends HomeEvent {
  final int locationId;
  const LocationPermissionEvent({
    required this.locationId,
  });
}

class ReqWFHEvent extends HomeEvent {
  const ReqWFHEvent();
}
