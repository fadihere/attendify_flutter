// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:attendify_lite/app/features/employer/team/presentation/widgets/attendence_record_type_widget.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';

@RoutePage()
class AdminTeamAttendenceRecordPage extends StatelessWidget {
  final List<String> tabbarItems = [
    "Active",
    "Deactivated",
  ];
  List testHHH = [];

  AdminTeamAttendenceRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Reports",
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: AppSize.overallPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: context.color.outline,
                minRadius: 45,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: context.color.whiteBlack,
                ),
              ),
              const Gap(10),
              Text(
                "John Doe",
                style: TextStyle(
                    fontFamily: 'Hellix',
                    color: context.color.font,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 200.r,
                child: Text(
                  "Swati Technologies lahore p 109",
                  style: TextStyle(
                    fontFamily: 'Hellix',
                    color: context.color.hint,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
              ),
              const Gap(15),
              SizedBox(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.color.whiteBlack,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 22,
                        spreadRadius: 0,
                        color: Color.fromRGBO(0, 0, 0, 0.09),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    rowHeight: 32,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    currentDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    onDaySelected: (selectedDay, focusedDay) {},
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                      outsideTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                      defaultTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                        color: context.color.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.color.primary,
                        ),
                      ),
                      todayTextStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: context.color.whiteBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      selectedTextStyle: TextStyle(
                        color: context.color.primary,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: context.color.font),
                      weekendStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: context.color.font),
                    ),
                    calendarBuilders: CalendarBuilders(
                      prioritizedBuilder: (context, day, focusedDay) {
                        for (var element in testHHH) {
                          if (day.day == element.dateTime.day &&
                              day.month == element.dateTime.month &&
                              day.year == element.dateTime.year &&
                              (element.status == 'PRS' ||
                                  element.status == 'LTL' ||
                                  element.status == 'WFH')) {
                            return InkWell(
                              onTap: () {
                                // List<AttendanceTransaction>
                                //     attendanceTransactionList =
                                //     snapshot1.data!
                                //         .where(
                                //           (ele) => (ele.recordedTimeIn!
                                //                       .day ==
                                //                   element.dateTime.day &&
                                //               ele.recordedTimeIn!.month ==
                                //                   element.dateTime.month &&
                                //               ele.recordedTimeIn!.year ==
                                //                   element.dateTime.year),
                                //         )
                                //         .toList();

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         AdminTeamAttendanceListView(
                                //             attendanceTransactionList:
                                //                 attendanceTransactionList),
                                //   ),
                                // );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: context.color.primary),
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: element.status == 'LTL'
                                          ? const Color.fromRGBO(255, 185, 4, 1)
                                          : const Color.fromRGBO(
                                              99,
                                              158,
                                              255,
                                              1,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (day.day == element.dateTime.day &&
                              day.month == element.dateTime.month &&
                              day.year == element.dateTime.year &&
                              element.status == 'ABS') {
                            return Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: context.color.primary)),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (day.day == element.dateTime.day &&
                              day.month == element.dateTime.month &&
                              day.year == element.dateTime.year &&
                              element.status == 'LTL') {
                            return Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 185, 4, 1)),
                              ),
                            );
                          }
                        }
                        return null;
                      },
                    ),
                    headerStyle: HeaderStyle(
                      headerPadding: const EdgeInsets.only(top: 10, bottom: 10),
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontSize: 14,
                              ),
                      // leftChevronPadding: EdgeInsets.all(15),

                      leftChevronIcon: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 14,
                            color: Color.fromRGBO(99, 158, 255, 1),
                          ),
                          Text(
                            "Prev",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      leftChevronMargin: EdgeInsets.zero,
                      rightChevronMargin: EdgeInsets.zero,
                      rightChevronIcon: const Row(
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Color.fromRGBO(99, 158, 255, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(15),
              AttendanceRecordTypeLocalWidget(
                  height: 800.r,
                  width: 1.sw,
                  color: context.color.primary,
                  attendaceType: "Present",
                  totalRecord: 12),
              const Gap(10),
              AttendanceRecordTypeLocalWidget(
                  height: 800.r,
                  width: 1.sw,
                  color: context.color.late,
                  attendaceType: "Late",
                  totalRecord: 4),
              const Gap(10),
              AttendanceRecordTypeLocalWidget(
                  height: 800.r,
                  width: 1.sw,
                  color: context.color.warning,
                  attendaceType: "Absent",
                  totalRecord: 2),
              // Gap(15),
              AppButtonWidget(
                onTap: () {
                  router.push(AdmAttendenceDetailRoute(logsList: const []));
                },
                text: "DOWNLOAD REPORTS",
                margin: EdgeInsets.only(top: 16.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
