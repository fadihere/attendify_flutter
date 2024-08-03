import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/presentation/widgets/set_office_hours_tile_widget.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

@RoutePage()
class SetOfficeHourPage extends StatelessWidget {
  const SetOfficeHourPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employerID = context.read<AuthEmrBloc>().state.user?.employerId;
    DateTime? startTime;
    DateTime? endTime;
    DateTime? graceTime;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Set Office Hours",
            style: TextStyle(fontFamily: FontFamily.hellix),
          ),
        ),
        body: Padding(
            padding: AppSize.overallPadding,
            child: BlocBuilder<SettingsEmrBloc, SettingsEmrState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SetHoursTileWidget(
                      title1: "Start Time",
                      title2: to12Hrs(state.officeHrsModel?.startTime),
                      buttonText: "Change",
                      onPressed: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return TimePickerWidget(
                              onChange: (date) {
                                startTime = date;
                              },
                              initial: convertStringToDateTime(
                                  state.officeHrsModel?.startTime ?? ""),
                              onSave: () {
                                if (startTime != null) {
                                  final start =
                                      TimeOfDay.fromDateTime(startTime!);

                                  final model = state.officeHrsModel!.copyWith(
                                      employersId: employerID!,
                                      startTime:
                                          "${start.hour}:${start.minute}:00");

                                  context.read<SettingsEmrBloc>().add(
                                      UpdateOfficeHrsEvent(
                                          workHrsModel: model,
                                          employerID: employerID));
                                  return;
                                }
                                context.read<SettingsEmrBloc>().add(
                                    UpdateOfficeHrsEvent(
                                        workHrsModel: state.officeHrsModel!,
                                        employerID: employerID!));
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Gap(10),
                    SetHoursTileWidget(
                      title1: "End Time",
                      title2: to12Hrs(state.officeHrsModel?.endTime),
                      buttonText: "Change",
                      onPressed: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return TimePickerWidget(
                                onChange: (date) {
                                  endTime = date;
                                },
                                initial: convertStringToDateTime(
                                  state.officeHrsModel?.endTime ?? "",
                                ),
                                onSave: () {
                                  if (endTime != null) {
                                    final end =
                                        TimeOfDay.fromDateTime(endTime!);

                                    final model = state.officeHrsModel!
                                        .copyWith(
                                            employersId: employerID!,
                                            endTime:
                                                "${end.hour}:${end.minute}:00");

                                    context
                                        .read<SettingsEmrBloc>()
                                        .add(UpdateOfficeHrsEvent(
                                          workHrsModel: model,
                                          employerID: employerID,
                                        ));
                                    return;
                                  }

                                  context
                                      .read<SettingsEmrBloc>()
                                      .add(UpdateOfficeHrsEvent(
                                        workHrsModel: state.officeHrsModel!,
                                        employerID: employerID!,
                                      ));
                                });
                          },
                        );
                      },
                    ),
                    const Gap(10),
                    SetHoursTileWidget(
                      title1: "Grace Period",
                      title2: to12Hrs(state.officeHrsModel?.gracePeriod),
                      buttonText: "Change",
                      onPressed: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return TimePickerWidget(
                              onChange: (date) {
                                graceTime = date;
                              },
                              initial: convertStringToDateTime(
                                  state.officeHrsModel?.gracePeriod ?? ""),
                              onSave: () {
                                if (graceTime != null) {
                                  final grace =
                                      TimeOfDay.fromDateTime(graceTime!);

                                  final model = state.officeHrsModel!.copyWith(
                                      employersId: employerID!,
                                      gracePeriod:
                                          "${grace.hour}:${grace.minute}:00");

                                  context.read<SettingsEmrBloc>().add(
                                      UpdateOfficeHrsEvent(
                                          workHrsModel: model,
                                          employerID: employerID));
                                  return;
                                }

                                context.read<SettingsEmrBloc>().add(
                                    UpdateOfficeHrsEvent(
                                        workHrsModel: state.officeHrsModel!,
                                        employerID: employerID!));
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Gap(10),
                    SetHoursTileWidget(
                      title1: "Working Days ",
                      title2: state.officeHrsModel?.workingDays
                              .map((e) => e.substring(0, 3))
                              .join(', ') ??
                          "--",
                      buttonText: "Change",
                      onPressed: () => workingDays(
                        context,
                        employerID: employerID!,
                        selectedWorkingDays:
                            state.officeHrsModel?.workingDays ?? [],
                      ),
                    ),
                  ],
                );
              },
            )));
  }

  String getFormattedTime(TimeOfDay time) {
    return "${(time.hour - (time.hour > 12 ? 12 : 0)).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour > 12 ? "PM" : "AM"}";
  }

  void workingDays(BuildContext context,
      {required List<String> selectedWorkingDays,
      required String employerID}) async {
    List<String> days = [];
    days.addAll(selectedWorkingDays);
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return BlocConsumer<SettingsEmrBloc, SettingsEmrState>(
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
                        TextButton(
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                              fontSize: 16,
                              color: context.color.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            if (days.isNotEmpty) {
                              final weekdays = sortWeekDays(days);
                              final model = state.officeHrsModel!.copyWith(
                                  employersId: employerID,
                                  workingDays: weekdays);

                              context.read<SettingsEmrBloc>().add(
                                  UpdateOfficeHrsEvent(
                                      workHrsModel: model,
                                      employerID: employerID));
                              return;
                            }
                            context.read<SettingsEmrBloc>().add(
                                UpdateOfficeHrsEvent(
                                    workHrsModel: state.officeHrsModel!,
                                    employerID: employerID));
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

class TimePickerWidget extends StatelessWidget {
  final DateTime? initial;
  final Function(DateTime) onChange;
  final VoidCallback onSave;

  const TimePickerWidget({
    super.key,
    this.initial,
    required this.onChange,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsEmrBloc, SettingsEmrState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.r),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: context.color.whiteBlack,
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            insetPadding: EdgeInsets.zero,
            alignment: const Alignment(0, 0.1),
            title: Text(
              "Change Time",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: context.color.font),
            ),
            actionsPadding: EdgeInsets.only(
              bottom: 15,
              right: 1.w / 5,
              left: 1.w / 5,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowAlignment: OverflowBarAlignment.center,
            titleTextStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            titlePadding: EdgeInsets.only(
              top: 30.r,
              bottom: 10.r,
            ),
            content: SizedBox(
              width: 1.w,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.r,
                  right: 10.r,
                  top: 10.r,
                  bottom: 25.r,
                ),
                child: SizedBox(
                  height: 270.r,
                  child: CupertinoDatePicker(
                    initialDateTime: initial,
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: onChange,
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontSize: 16,
                            color: context.color.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  state.status == Status.loading
                      ? const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        )
                      : TextButton(
                          onPressed: onSave,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: context.color.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
