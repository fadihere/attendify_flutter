import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/home/presentation/bloc/adm_home_bloc.dart';
import 'package:attendify_lite/app/features/employer/home/presentation/widgets/change_day_structure.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

@RoutePage()
class TotalEmployeePage extends StatefulWidget {
  final UserEmrModel user;
  const TotalEmployeePage({
    super.key,
    required this.user,
  });

  @override
  State<TotalEmployeePage> createState() => _TotalEmployeeScreen();
}

class _TotalEmployeeScreen extends State<TotalEmployeePage> {
  final List<String> options = [
    'All',
    'Prs',
    'Abs',
    'Late',
    'Wfh',
  ];

  @override
  void initState() {
    context.read<AdmHomeBloc>().add(FetchAttendanceRecordEvent(
          employerID: widget.user.employerId,
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Total Employees",
            style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: AppSize.overallPadding,
          child: Column(
            children: [
              ChangeDayStructure(
                onDateChange: (date) async {
                  DateTime today =
                      DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
                  if (date.difference(today).inHours < 23) {
                    final startDate = date;
                    final endDate = date.copyWith(hour: 23, minute: 59);
                    context.read<AdmHomeBloc>().add(FetchAttendanceRecordEvent(
                        employerID: widget.user.employerId,
                        startDate: startDate,
                        endDate: endDate));
                  } else {
                    showToast(msg: "Can't select an upcoming date");
                  }
                },
              ),
              const Gap(10),
              Divider(
                color: context.color.highlightColor,
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Employees',
                    style: TextStyle(
                        color: context.color.font,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.r),
                  ),
                  BlocBuilder<AdmHomeBloc, AdmHomeState>(
                    builder: (context, state) {
                      return DropdownButton(
                          padding: const EdgeInsets.only(right: 20.0),
                          borderRadius: BorderRadius.circular(12.0),
                          underline: const Offstage(),
                          isDense: true,
                          value: state.selectedStatus,
                          icon: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: context.color.font,
                          ),
                          items: options
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: context.color.font,
                                        fontSize: 14.r,
                                        fontFamily: FontFamily.hellix,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            context.read<AdmHomeBloc>().add(
                                FilterListByStatusEvent(
                                    attendanceStatus: value!));
                          });
                    },
                  ),
                ],
              ),
              const Gap(20),
              BlocBuilder<AdmHomeBloc, AdmHomeState>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (state.filtered.isEmpty) {
                    return const Center(
                      child: Text('No Data To Show'),
                    );
                  }
                  return Expanded(
                      child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    // padding: EdgeInsets.zero,
                    itemCount: state.filtered.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final attendence = state.filtered[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attendence.employeeName ?? '',
                                  style: TextStyle(
                                    color: context.color.font,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.r,
                                  ),
                                ),
                                Text(
                                  mapAttendanceStatus(
                                    attendence.attendanceStatus,
                                  )!,
                                  style: TextStyle(
                                    color: getTextColorByStatus(
                                      attendence.attendanceStatus!,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            // Text(
                            //     item['time'].toString().substring(11, 16),
                            //     style: TextStyle(
                            //         fontSize: 9, fontWeight: FontWeight.bold),
                            //   ),
                          ],
                        ),
                      );
                    },
                  ));
                },
              )
            ],
          ),
        ));
  }
}
