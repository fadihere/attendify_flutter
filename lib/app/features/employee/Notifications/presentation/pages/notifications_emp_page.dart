import 'package:attendify_lite/app/features/employee/Notifications/presentation/bloc/notifications_emp_bloc.dart';
import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/notification_tile_widget.dart';

@RoutePage()
class NotificationsEmpPage extends StatelessWidget {
  const NotificationsEmpPage({super.key});

  @override
  Widget build(BuildContext context) {
    fetchNotifications(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => fetchNotifications(context),
        child: BlocBuilder<NotificationsEmpBloc, NotificationsEmpState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state.notiList.isEmpty) {
              return const Center(
                child: Text('No Notifications To Show'),
              );
            }
            return ListView.builder(
              padding: AppSize.overallPadding,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  final notification = state.notiList[index];
                  context
                      .read<NotificationsEmpBloc>()
                      .add(UpdateNotificationEvent(notification: notification));
                },
                child: NotificationTileWidget(
                  index: index,
                ),
              ),
              itemCount: state.notiList.length,
            );
          },
        ),
      ),
    );
  }

  fetchNotifications(BuildContext context) {
    final user = context.read<AuthEmpBloc>().state.user;
    context
        .read<NotificationsEmpBloc>()
        .add(FetchNotificationsEvent(employeeID: user!.employeeId));
  }
}
