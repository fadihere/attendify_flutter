import 'package:attendify_lite/app/features/employee/Notifications/data/repositories/noti_emp_repo.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/noti_model.dart';

part 'notifications_emp_event.dart';
part 'notifications_emp_state.dart';

class NotificationsEmpBloc
    extends Bloc<NotificationsEmpEvent, NotificationsEmpState> {
  NotficationEmpRepoImpl repo;
  NotificationsEmpBloc({required this.repo})
      : super(const NotificationsEmpState()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<UpdateNotificationEvent>(_onUpdateNotification);
  }

  _onUpdateNotification(
    UpdateNotificationEvent event,
    Emitter<NotificationsEmpState> emit,
  ) async {
    int indexOf = state.notiList.indexWhere((element) =>
        element.notificationId == event.notification.notificationId);
    List<NotiModel> updatedList =
        List.from(state.notiList); // Make a copy of the list
    updatedList[indexOf] =
        updatedList[indexOf].copyWith(isSeen: true); // Update the specific item

    emit(state.copyWith(notiList: updatedList));

    await repo.updateNotificationStatus(
        notificationID: event.notification.notificationId!,
        notiModel: updatedList[indexOf]);
  }

  _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsEmpState> emit,
  ) async {
    final startDate = DateTime.now().copyWith(
      hour: 09,
      minute: 00,
      second: 00,
    );
    final endDate = DateTime.now().copyWith(
      hour: 23,
      minute: 59,
      second: 59,
    );

    emit(state.copyWith(status: Status.loading));

    final response = await repo.fetchEmpNotifications(
      employeeID: event.employeeID,
      startDate: startDate,
      endDate: endDate,
    );
    final notiState = response.fold<NotificationsEmpState>((l) {
      return state.copyWith(status: Status.error);
    }, (r) => state.copyWith(status: Status.success, notiList: r));
    emit(notiState);
  }
}
