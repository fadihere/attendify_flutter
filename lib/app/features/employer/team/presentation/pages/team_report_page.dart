// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/report_bloc/report_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/widgets/attendence_record_type_widget.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:attendify_lite/injection_container.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/utils/widgets/buttons.dart';

@RoutePage()
class TeamReportPage extends StatelessWidget {
  final TeamModel team;

  const TeamReportPage({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthEmrBloc>().state.user;
/*     context.read<ReportBloc>().add(FetchReportLogsEvent(
          team: team,
          employerID: user!.employerId,
        )); */

    return BlocProvider(
      create: (context) => ReportBloc(repo: sl(), reportsRepo: sl())
        ..add(FetchReportLogsEvent(
          team: team,
          employerID: user!.employerId,
        )),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              "Reports",
              style: TextStyle(
                fontFamily: 'Hellix',
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if (state.invoice.isEmpty) return const SizedBox();
              return AppButtonWidget(
                onTap: () {
                  if (state.invoice.isEmpty) return;
                  router.push(AdmPdfPreviewRoute(
                    invoice: state.invoice,
                    logo: context.read<AuthEmrBloc>().state.user!.imageUrl,
                    startDt: team.createdOn!.toIso8601String().substring(0, 10),
                    endDt: DateTime.now().toIso8601String().substring(0, 10),
                    custom1Monthly2: 1,
                  ));
                },
                text: "DOWNLOAD REPORTS",
                margin: EdgeInsets.only(
                  left: 20.r,
                  right: 20.r,
                  bottom: 20.r,
                ),
              );
            },
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: AppSize.overallPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: CircleAvatar(
                      backgroundColor: context.color.outline,
                      maxRadius: 45,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: CachedNetworkImage(
                          imageUrl: team.imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Icon(
                            Icons.person,
                            size: 70,
                            color: context.color.white,
                          ),
                          errorWidget: (_, __, ___) => Icon(
                            Icons.person,
                            size: 70,
                            color: context.color.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    team.employeeName.capitalize,
                    style: TextStyle(
                        fontFamily: 'Hellix',
                        color: context.color.font,
                        fontSize: 20.r,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 200.r,
                    child: Text(
                      team.organizationName?.capitalize ?? '',
                      style: TextStyle(
                        fontFamily: 'Hellix',
                        color: context.color.hint,
                        fontSize: 16.r,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const Gap(15),
                  BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      if (state.status == Status.loading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (state.status == Status.error) {
                        return const Center(
                          child: Text('Error Occured. Try Again Later'),
                        );
                      }
                      if (state.logsList.isEmpty) {
                        return const Center(
                          child: Text('No Record To Show'),
                        );
                      }
                      return Column(
                        children: [
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
                                selectedDayPredicate: (day) {
                                  return true;
                                },
                                rowHeight: 32,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2050, 3, 14),
                                focusedDay: DateTime.now(),
                                currentDay: DateTime.now(),
                                calendarFormat: CalendarFormat.month,
                                onDaySelected: (selectedDay, focusedDay) {
                                  context.read<ReportBloc>().add(SelectDayEvent(
                                        selectedDay: selectedDay,
                                        team: team,
                                      ));
                                },
                                calendarStyle: CalendarStyle(
                                  weekendTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                  outsideTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                  todayDecoration: BoxDecoration(
                                    color: context.color.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.color.primary,
                                    ),
                                  ),
                                  todayTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: context.color.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
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
                                  prioritizedBuilder:
                                      (context, day, focusedDay) {
                                    for (var element in state.logsList) {
                                      final isSame = day
                                          .isSameDay(element.recordedTimeIn!);
                                      if (isSame &&
                                          !(element
                                                  .recordedTimeIn!.isSaturday ||
                                              element
                                                  .recordedTimeIn!.isSunday)) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: element.recordedTimeIn!
                                                    .isSameDay(DateTime.now())
                                                ? Border.all(
                                                    color:
                                                        context.color.primary)
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                  color: getTextColorByStatus(
                                                element.attendanceStatus!,
                                              )),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    if (day.isSaturday || day.isSunday) {
                                      return Center(
                                          child: Text('${day.day}',
                                              style: TextStyle(
                                                color: context.color.hint,
                                              )));
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: day.isSameDay(DateTime.now())
                                            ? Border.all(
                                                color: context.color.primary)
                                            : null,
                                      ),
                                      child: Center(
                                          child: Text('${day.day}',
                                              style: TextStyle(
                                                  color: context.color.icon))),
                                    );
                                  },
                                ),
                                headerStyle: HeaderStyle(
                                  headerPadding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 15,
                                          fontFamily: FontFamily.hellix,
                                          fontWeight: FontWeight.w500),
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
                                            fontSize: 14,
                                            fontFamily: FontFamily.hellix,
                                            fontWeight: FontWeight.w500),
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
                                            fontSize: 14,
                                            fontFamily: FontFamily.hellix,
                                            fontWeight: FontWeight.w500),
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
                              totalRecord: state.presents),
                          const Gap(10),
                          AttendanceRecordTypeLocalWidget(
                              height: 800.r,
                              width: 1.sw,
                              color: context.color.late,
                              attendaceType: "Late",
                              totalRecord: state.lates),
                          const Gap(10),
                          AttendanceRecordTypeLocalWidget(
                              height: 800.r,
                              width: 1.sw,
                              color: context.color.warning,
                              attendaceType: "Absent",
                              totalRecord: state.absents),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
