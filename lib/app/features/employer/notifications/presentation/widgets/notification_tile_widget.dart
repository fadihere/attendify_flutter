import 'package:attendify_lite/app/features/employer/notifications/presentation/blocs/noti_emr_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/functions/functions.dart';

class NotificationTileWidget extends StatelessWidget {
  final int index;
  const NotificationTileWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotiEmrBloc, NotiEmrState>(
      builder: (context, state) {
        final notification = state.notiList[index];
        return Container(
          margin: EdgeInsets.all(5.r),
          padding: EdgeInsets.only(bottom: 7.r, top: 7.r),
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
                        height: 0.4.r,
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
                          height: 1.3.r,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${notification.dateAndTime!.day} ${getMonthName(notification.dateAndTime!.month)} - ${DateFormat('hh:mm').format(notification.dateAndTime!)} ${TimeOfDay.fromDateTime(notification.dateAndTime!).period.name.toUpperCase()}",
                      style: TextStyle(
                        fontSize: 12.r,
                        color: context.color.hintColor,
                        height: 1.3.r,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                StringExtension.displayTimeAgoFromTimestamp(
                    notification.dateAndTime!),
                style: TextStyle(
                  fontSize: 10.r,
                  color: context.color.hintColor,
                  height: 0.8.r,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
