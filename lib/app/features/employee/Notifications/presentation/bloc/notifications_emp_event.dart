part of 'notifications_emp_bloc.dart';

abstract class NotificationsEmpEvent extends Equatable {
  const NotificationsEmpEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsEvent extends NotificationsEmpEvent {
  final String employeeID;

  const FetchNotificationsEvent({
    required this.employeeID,
  });
}

class UpdateNotificationEvent extends NotificationsEmpEvent {
  final NotiModel notification;

  const UpdateNotificationEvent({
    required this.notification,
  });
}
