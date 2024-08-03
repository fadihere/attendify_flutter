import 'dart:developer';

import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/notifications/presentation/widgets/notification_tile_widget.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/enums/status.dart';
import '../blocs/noti_emr_bloc.dart';

@RoutePage()
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    fetchNotifications(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.notifications,
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => fetchNotifications(context),
        child: BlocBuilder<NotiEmrBloc, NotiEmrState>(
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
              itemBuilder: (context, index) {
                final notification = state.notiList[index];
                return InkWell(
                    onTap: () {
                      context.read<NotiEmrBloc>().add(
                          UpdateNotificationEvent(notification: notification));
                      switch (notification.notificationType) {
                        case "WFH":
                          break;
                        case "Late Arrival":
                          break;
                        case "Not At Location":
                          router.push(NotOnLocationDetailRoute(
                              notiModel: notification));
                          break;
                        case "Leave":
                          break;
                        default:
                          log("Undefined Notification ===> ${notification.notificationType}");
                      }
                    },
                    child: NotificationTileWidget(
                      index: index,
                    ));
              },
              itemCount: state.notiList.length,
            );
          },
        ),
      ),
    );
  }

  fetchNotifications(BuildContext context) {
    final user = context.read<AuthEmrBloc>().state.user;
    context
        .read<NotiEmrBloc>()
        .add(FetchNotificationsEvent(employerID: user!.employerId));
  }
}
