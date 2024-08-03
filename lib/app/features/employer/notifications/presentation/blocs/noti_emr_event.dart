part of 'noti_emr_bloc.dart';

abstract class NotiEmrEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchNotificationsEvent extends NotiEmrEvent {
  final String employerID;

  FetchNotificationsEvent({
    required this.employerID,
  });
}

class ClearPreviousNotificationEvent extends NotiEmrEvent {
  ClearPreviousNotificationEvent();
}

class FetchAttendanceDetailByIDEvent extends NotiEmrEvent {
  final int attendanceID;

  FetchAttendanceDetailByIDEvent({
    required this.attendanceID,
  });
}

class ClockOutEmployeeEvent extends NotiEmrEvent {
  final double outLatitude;
  final double outLongitude;

  ClockOutEmployeeEvent({
    required this.outLatitude,
    required this.outLongitude,
  });
}

class UpdateNotificationEvent extends NotiEmrEvent {
  final NotiModel notification;

  UpdateNotificationEvent({
    required this.notification,
  });
}
