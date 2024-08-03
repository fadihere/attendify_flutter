// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Status status;
  final String errorMessage;
  final String checkIn;
  final String checkOut;
  final String totalHours;
  final LastInModel? lastInModel;
  final LocationModel? locationModel;
  final AuthEmpState? authEmpState;
  final bool isClockedOut;
  final bool? isApproved;
  final bool clockedIn;
  final bool isLocPermissionEnabled;
  final bool isAtOffice;
  final bool isMock;
  final String locMessage;
  final String currentLocName;
  final double currentLat;
  final double currentLong;
  final Status isFetchingLocation;
  final bool isConnected;
  final bool showNotification;

  const HomeState({
    this.authEmpState,
    this.status = Status.initial,
    this.errorMessage = "",
    this.lastInModel,
    this.checkIn = "00:00",
    this.checkOut = "00:00",
    this.totalHours = "00:00",
    this.locMessage = "",
    this.currentLocName = "",
    this.currentLat = 0.0,
    this.currentLong = 0.0,
    this.locationModel,
    this.isClockedOut = false,
    this.isMock = false,
    this.clockedIn = false,
    this.isAtOffice = false,
    this.isFetchingLocation = Status.initial,
    this.isApproved,
    this.isConnected = false,
    this.isLocPermissionEnabled = false,
    this.showNotification = false,
  });

  // bool get isChecked =>
  //     lastInModel != null && lastInModel?.recordedTimeOut != null;

  @override
  List<Object?> get props {
    return [
      status,
      errorMessage,
      lastInModel,
      checkIn,
      checkOut,
      totalHours,
      locationModel,
      authEmpState,
      isClockedOut,
      isApproved,
      clockedIn,
      isLocPermissionEnabled,
      locMessage,
      currentLocName,
      currentLat,
      currentLong,
      isAtOffice,
      isFetchingLocation,
      isMock,
      isConnected,
      showNotification
    ];
  }

  HomeState copyWith({
    Status? status,
    String? errorMessage,
    String? checkIn,
    String? checkOut,
    String? totalHours,
    String? currentLocName,
    double? currentLat,
    double? currentLong,
    String? locMessage,
    LastInModel? lastInModel,
    LocationModel? locationModel,
    AuthEmpState? authEmpState,
    bool? isClockedOut,
    bool? isApproved,
    bool? clockedIn,
    bool? isLocPermissionEnabled,
    bool? isAtOffice,
    bool? isMock,
    bool? isConnected,
    Status? isFetchingLocation,
    bool? showNotification,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      totalHours: totalHours ?? this.totalHours,
      lastInModel: lastInModel ?? this.lastInModel,
      locationModel: locationModel ?? this.locationModel,
      authEmpState: authEmpState ?? this.authEmpState,
      isClockedOut: isClockedOut ?? this.isClockedOut,
      isApproved: isApproved ?? this.isApproved,
      clockedIn: clockedIn ?? this.clockedIn,
      isLocPermissionEnabled:
          isLocPermissionEnabled ?? this.isLocPermissionEnabled,
      locMessage: locMessage ?? this.locMessage,
      currentLocName: currentLocName ?? this.currentLocName,
      currentLat: currentLat ?? this.currentLat,
      currentLong: currentLong ?? this.currentLong,
      isAtOffice: isAtOffice ?? this.isAtOffice,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      isMock: isMock ?? this.isMock,
      isConnected: isConnected ?? this.isConnected,
      showNotification: showNotification ?? this.showNotification,
    );
  }
}

class FaceDialogState extends HomeState {}

class WFHDialogState extends HomeState {}

class ClockedInDialogState extends HomeState {}

class ClockedOutDialogState extends HomeState {}
