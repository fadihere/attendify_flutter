import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
// import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/data/models/work_hrs_model.dart';
// import 'package:attendify_lite/app/features/employer/settings/presentation/widgets/set_office_hours_tile_widget.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/work_time_bloc/work_time_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
// import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
// import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

// import '../../../settings/presentation/pages/set_office_hours.dart';

@RoutePage()
class SetWorkTimePage extends StatelessWidget {
  final TeamModel team;
  const SetWorkTimePage({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    context.read<WorkTimeBloc>().add(FetchEmpWorkHoursEvent(team: team));
    // final user = context.read<AuthEmrBloc>().state.user;
    // final key = GlobalKey<FormState>();
    // DateTime? startTime;
    // DateTime? endTime;
    // DateTime? graceTime;

    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.icons.comingSoon.svg(),
              const Gap(40),
              Text(
                "Get notified when its ready!",
                style: TextStyle(fontSize: 16.r, color: context.color.font),
              )
            ],
          ),
        )

        // Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 100.r),
        //     child: BlocBuilder<WorkTimeBloc, WorkTimeState>(
        //       builder: (context, state) {
        //         return Column(
        //           children: [
        //             SetHoursTileWidget(
        //               title1: "Start Time",
        //               title2: to12Hrs(state.workHrs?.startTime ?? "00:00"),
        //               buttonText: "Change",
        //               onPressed: () {
        //                 showDialog(
        //                   barrierDismissible: true,
        //                   context: context,
        //                   builder: (context) {
        //                     return TimePickerWidget(
        //                       onChange: (date) {
        //                         startTime = date;
        //                       },
        //                       initial: convertStringToDateTime(
        //                           state.workHrs?.startTime ?? ""),
        //                       onSave: () {
        //                         if (startTime == null) {
        //                           return;
        //                         }
        //                         final start =
        //                             TimeOfDay.fromDateTime(startTime!);
        //                         if (state.workHrs != null) {
        //                           final model = state.workHrs!.copyWith(
        //                               employersId: user!.employerId,
        //                               startTime:
        //                                   "${start.hour}:${start.minute}:00");

        //                           context.read<WorkTimeBloc>().add(
        //                               UpdateEmpHrsEvent(
        //                                   workHrs: model, team: team));
        //                           return;
        //                         }
        //                         final model = WorkHrsModel(
        //                           startTime: "${start.hour}:${start.minute}:00",
        //                           endTime: "00:00:00",
        //                           gracePeriod: "00:00:00",
        //                           workingDays: [],
        //                           employersId: user!.employerId,
        //                         );
        //                         context.read<WorkTimeBloc>().add(
        //                             PostEmpWorkHrsEvent(
        //                                 workHrs: model, team: team));
        //                       },
        //                     );
        //                   },
        //                 );
        //               },
        //             ),
        //             const Gap(10),
        //             SetHoursTileWidget(
        //               title1: "End Time",
        //               title2: to12Hrs(state.workHrs?.endTime ?? "00:00"),
        //               buttonText: "Change",
        //               onPressed: () {
        //                 showDialog(
        //                   barrierDismissible: true,
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return TimePickerWidget(
        //                       onChange: (date) {
        //                         endTime = date;
        //                       },
        //                       initial: convertStringToDateTime(
        //                           state.workHrs?.endTime ?? ""),
        //                       onSave: () {
        //                         if (endTime == null) {
        //                           return;
        //                         }
        //                         final end = TimeOfDay.fromDateTime(endTime!);

        //                         if (state.workHrs != null) {
        //                           final model = state.workHrs!.copyWith(
        //                               employersId: user!.employerId,
        //                               endTime: "${end.hour}:${end.minute}:00");

        //                           context.read<WorkTimeBloc>().add(
        //                               UpdateEmpHrsEvent(
        //                                   workHrs: model, team: team));
        //                           return;
        //                         }
        //                         final model = WorkHrsModel(
        //                           startTime: "${end.hour}:${end.minute}:00",
        //                           endTime: "00:00:00",
        //                           gracePeriod: "00:00:00",
        //                           workingDays: [],
        //                           employersId: user!.employerId,
        //                         );
        //                         context.read<WorkTimeBloc>().add(
        //                             PostEmpWorkHrsEvent(
        //                                 workHrs: model, team: team));
        //                       },
        //                     );
        //                   },
        //                 );
        //               },
        //             ),
        //             const Gap(10),
        //             SetHoursTileWidget(
        //               title1: "Grace Period",
        //               title2: to12Hrs(state.workHrs?.gracePeriod ?? "00:00"),
        //               buttonText: "Change",
        //               onPressed: () {
        //                 showDialog(
        //                   barrierDismissible: true,
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return TimePickerWidget(
        //                       onChange: (date) {
        //                         graceTime = date;
        //                       },
        //                       initial: convertStringToDateTime(
        //                           state.workHrs?.gracePeriod ?? ""),
        //                       onSave: () {
        //                         if (graceTime == null) {
        //                           return;
        //                         }
        //                         final grace =
        //                             TimeOfDay.fromDateTime(graceTime!);
        //                         if (state.workHrs != null) {
        //                           final model = state.workHrs!.copyWith(
        //                               employersId: user!.employerId,
        //                               gracePeriod:
        //                                   "${grace.hour}:${grace.minute}:00");

        //                           context.read<WorkTimeBloc>().add(
        //                               UpdateEmpHrsEvent(
        //                                   workHrs: model, team: team));
        //                           return;
        //                         }
        //                         final model = WorkHrsModel(
        //                           startTime: "00:00:00",
        //                           endTime: "00:00:00",
        //                           gracePeriod:
        //                               "${grace.hour}:${grace.minute}:00",
        //                           workingDays: [],
        //                           employersId: user!.employerId,
        //                         );
        //                         context.read<WorkTimeBloc>().add(
        //                             PostEmpWorkHrsEvent(
        //                                 workHrs: model, team: team));
        //                       },
        //                     );
        //                   },
        //                 );
        //               },
        //             ),
        //             const Gap(10),
        //             SetHoursTileWidget(
        //               title1: "Working Dayss ",
        //               title2:
        //                   '${state.workHrs?.workingDays.map((e) => e.substring(0, 3)).join(', ') ?? "--"} ',
        //               buttonText: "Change",
        //               onPressed: () => workingDays(context,
        //                   selectedWorkingDays: state.workHrs?.workingDays,
        //                   user: user!,
        //                   team: team),
        //             ),
        //           ],
        //         );
        //       },
        //     ))
        );
  }

  String getFormattedTime(TimeOfDay time) {
    return "${(time.hour - (time.hour > 12 ? 12 : 0)).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour > 12 ? "PM" : "AM"}";
  }

  void workingDays(
    BuildContext context, {
    required List<String>? selectedWorkingDays,
    required TeamModel team,
    required UserEmrModel user,
  }) async {
    List<String> days = [];
    days.addAll(selectedWorkingDays ?? []);
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return BlocConsumer<WorkTimeBloc, WorkTimeState>(
          listener: (context, state) {
            if (state.status == Status.loading) {
              BotToast.showLoading();
              return;
            }
            BotToast.closeAllLoading();
          },
          builder: (context, state) {
            return Dialog(
              insetPadding: AppSize.sidePadding,
              backgroundColor: context.color.container,
              child: Padding(
                padding: AppSize.overallPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(
                      title: const Text("Working Days"),
                      backgroundColor: Colors.transparent,
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: AppSize.sidePadding,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Monday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Monday"),
                                    onChanged: (value) {
                                      if (!days.contains("Monday")) {
                                        days.add("Monday");
                                      } else {
                                        days.remove("Monday");
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Tuesday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Tuesday"),
                                    onChanged: (value) {
                                      if (!days.contains("Tuesday")) {
                                        days.add("Tuesday");
                                      } else {
                                        days.remove("Tuesday");
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Wednesday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Wednesday"),
                                    onChanged: (value) {
                                      if (!days.contains("Wednesday")) {
                                        days.add("Wednesday");
                                      } else {
                                        days.remove("Wednesday");
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Thursday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Thursday"),
                                    onChanged: (value) {
                                      if (!days.contains("Thursday")) {
                                        days.add("Thursday");
                                      } else {
                                        days.remove("Thursday");
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Friday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Friday"),
                                    onChanged: (value) {
                                      if (!days.contains("Friday")) {
                                        days.add("Friday");
                                      } else {
                                        days.remove("Friday");
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Saturday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Saturday"),
                                    onChanged: (value) {
                                      if (!days.contains("Saturday")) {
                                        days.add("Saturday");
                                      } else {
                                        days.remove("Saturday");
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 50,
                                  child: CheckboxListTile(
                                    title: Text(
                                      "Sunday",
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: context.color.primary,
                                    value: days.contains("Sunday"),
                                    onChanged: (value) {
                                      if (!days.contains("Sunday")) {
                                        days.add("Sunday");
                                      } else {
                                        days.remove("Sunday");
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 16,
                              color: context.color.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        BlocBuilder<WorkTimeBloc, WorkTimeState>(
                          builder: (context, state) {
                            return TextButton(
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.color.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () {
                                if (state.workHrs != null) {
                                  final weekdays = sortWeekDays(days);
                                  final model = state.workHrs!.copyWith(
                                      employersId: user.employerId,
                                      workingDays: weekdays);

                                  context.read<WorkTimeBloc>().add(
                                      UpdateEmpHrsEvent(
                                          workHrs: model, team: team));
                                  return;
                                }
                                final weekdays = sortWeekDays(days);
                                final model = WorkHrsModel(
                                  startTime: "",
                                  endTime: "",
                                  gracePeriod: "",
                                  workingDays: weekdays,
                                  employersId: user.employerId,
                                );
                                context.read<WorkTimeBloc>().add(
                                    PostEmpWorkHrsEvent(
                                        workHrs: model, team: team));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
