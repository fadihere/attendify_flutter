// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notifications_emp_bloc.dart';

class NotificationsEmpState extends Equatable {
  final Status status;
  final List<NotiModel> notiList;

  const NotificationsEmpState({
    this.status = Status.initial,
    this.notiList = const [],
  });

  @override
  List<Object?> get props => [status, notiList];

  NotificationsEmpState copyWith({
    Status? status,
    List<NotiModel>? notiList,
  }) {
    return NotificationsEmpState(
      status: status ?? this.status,
      notiList: notiList ?? this.notiList,
    );
  }
}
