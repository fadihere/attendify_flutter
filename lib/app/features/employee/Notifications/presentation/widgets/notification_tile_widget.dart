import 'package:attendify_lite/app/features/employee/Notifications/presentation/bloc/notifications_emp_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NotificationTileWidget extends StatelessWidget {
  final int index;
  const NotificationTileWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsEmpBloc, NotificationsEmpState>(
      builder: (context, state) {
        final notification = state.notiList[index];
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.color.outline,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              notification.isSeen ?? false
                  ? const SizedBox()
                  : Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        color: context.color.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
              const Gap(5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? "",
                      style: TextStyle(
                        color: context.color.font,
                        height: 0.5.r,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.hellix,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      notification.subTitle ?? "",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: context.color.hintColor,
                          fontFamily: FontFamily.hellix,
                          height: 1.3,
                          fontWeight: FontWeight.w400),
                    ),
                    /* Text(
                      "${date!.day} ${getMonthName(date!.month)} - ${date!.hour.toString().padLeft(2, "0")}:${date!.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(
                        fontSize: 12,
                        color: context.color.hintColor,
                        height: 1.3,
                      ),
                    ), */
                  ],
                ),
              ),
              Text(
                StringExtension.displayTimeAgoFromTimestamp(
                    notification.dateAndTime ?? DateTime.now()),
                style: TextStyle(
                  fontSize: 12,
                  color: context.color.hintColor,
                  height: 0.8,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
