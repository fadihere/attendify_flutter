import 'dart:developer';

import 'package:attendify_lite/app/features/employer/home/data/models/chart_data_model.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../../../core/enums/status.dart';
import '../../../../../../core/gen/assets.gen.dart';
import '../../../../../../core/utils/functions/functions.dart';
import '../../../../../shared/widgets/decoration.dart';
import '../../../../../shared/widgets/pop_up_menu.dart';
import '../../../../employee/home/presentation/widgets/clock_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/adm_home_bloc.dart';
import '../widgets/pending_approval_custom_widget.dart';

@RoutePage()
class AdmHomePage extends StatefulWidget {
  const AdmHomePage({super.key});

  @override
  State<AdmHomePage> createState() => _AdmHomePageState();
}

class _AdmHomePageState extends State<AdmHomePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthEmrBloc>().state.user;
    final admHomeBloc = context.read<AdmHomeBloc>();
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthEmrBloc, AuthEmrState>(
          builder: (context, state) {
            return Text(
              state.user!.organizationName.capitalize,
              style: const TextStyle(fontFamily: FontFamily.hellix),
            );
          },
        ),
        actions: [
          BlocBuilder<AdmHomeBloc, AdmHomeState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    admHomeBloc
                        .add(const AdmShowNotificationEvent(status: false));
                    router.push(const NotificationsRoute());
                  },
                  icon: Stack(
                    children: [
                      Assets.icons.notification.svg(
                          colorFilter: ColorFilter.mode(
                        context.color.icon,
                        BlendMode.srcIn,
                      )),
                      state.showNotification
                          ? Positioned(
                              right: 2.r,
                              child: Container(
                                width: 5.r,
                                height: 5.r,
                                decoration: BoxDecoration(
                                  color: context.color.red,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ));
            },
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                child: BlocConsumer<AuthEmrBloc, AuthEmrState>(
                  listener: (context, state) {
                    if (state.status == Status.error) {
                      showToast(msg: state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(15),
                        const ClockWidget(),
                        const Gap(40),
                        BlocBuilder<AdmHomeBloc, AdmHomeState>(
                          builder: (context, state) {
                            List<ChartDataModel> chartData = [];
                            if (state.summaryModel != null) {
                              chartData.add(
                                ChartDataModel(
                                    name: 'Present',
                                    amount: state.summaryModel?.present ?? 0,
                                    color: context.color.present),
                              );
                              chartData.add(
                                ChartDataModel(
                                    name: 'Absent',
                                    amount: state.summaryModel?.absent ?? 0,
                                    color: context.color.warning),
                              );
                              chartData.add(
                                ChartDataModel(
                                    name: 'Late',
                                    amount: state.summaryModel?.late ?? 0,
                                    color: context.color.late),
                              );
                              chartData.add(
                                ChartDataModel(
                                    name: 'WFH',
                                    amount: state.summaryModel?.wfh ?? 0,
                                    color: context.color.wfh),
                              );
                              if (chartData
                                  .any((element) => element.amount! > 0)) {
                              } else {
                                chartData.add(
                                  ChartDataModel(
                                      name: 'NO',
                                      amount: 100,
                                      color:
                                          context.color.wfh.withOpacity(0.2)),
                                );
                              }
                            }
                            return GestureDetector(
                              onTap: () {
                                router.push(TotalEmployeeRoute(user: user!));
                              },
                              child: Container(
                                height: 168.r,
                                padding: const EdgeInsets.only(right: 10),
                                decoration: dropShadowDecoration(context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                            height: 156.r,
                                            width: 156.r,
                                            child: SfCircularChart(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 10.r,
                                                ),
                                                series: <CircularSeries>[
                                                  // Render pie chart
                                                  DoughnutSeries<ChartDataModel,
                                                          String>(
                                                      innerRadius: '65%',
                                                      radius: '100%',
                                                      dataSource: chartData,
                                                      pointColorMapper:
                                                          (ChartDataModel data,
                                                                  _) =>
                                                              data.color,
                                                      xValueMapper:
                                                          (ChartDataModel data,
                                                                  _) =>
                                                              data.name,
                                                      yValueMapper:
                                                          (ChartDataModel data,
                                                                  _) =>
                                                              data.amount)
                                                ])),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${state.totalPresent}% ",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                height: 1.r,
                                              ),
                                            ),
                                            Text(
                                              'Present',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                height: 1.r,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: FontFamily.hellix,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            'Total ${state.summaryModel?.count ?? "0"} Employees',
                                            style: TextStyle(
                                              fontSize: 15.r,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        const Gap(7),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  context.color.present,
                                            ),
                                            const Gap(5),
                                            Text(
                                              'Present ${state.summaryModel?.present ?? "0"}',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const Gap(5),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  context.color.warning,
                                            ),
                                            const Gap(5),
                                            Text(
                                              'Absent ${state.summaryModel?.absent ?? "0"}',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const Gap(5),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  context.color.late,
                                            ),
                                            const Gap(5),
                                            Text(
                                              'Late ${state.summaryModel?.late ?? "0"}',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const Gap(5),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  context.color.wfh,
                                            ),
                                            const Gap(5),
                                            Text(
                                              'WFH ${state.summaryModel?.wfh ?? "0"}',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Container(
                            width: ScreenUtil().screenWidth,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                color: context.color.whiteBlack,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 146, 146, 146)
                                            .withOpacity(0.2), // Shadow color
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: const Offset(0,
                                        -4), // Adjust the offset to control the shadow direction
                                  ),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Gap(20),
                                Text(
                                  "Pending Approvals",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                const Divider(
                                  height: 0.5,
                                  thickness: 0.5,
                                ),
                                BlocBuilder<AdmHomeBloc, AdmHomeState>(
                                  builder: (context, state) {
                                    if (state.status == Status.loading) {
                                      return Expanded(
                                        child: SizedBox(
                                            height: 200.h,
                                            child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      context.color.primary),
                                            ))),
                                      );
                                    }

                                    if (state.requestsList.isNotEmpty) {
                                      log(state.requestsList[0]
                                          .toJson()
                                          .toString());
                                      return Expanded(
                                          child: ListView.builder(
                                        // physics:
                                        //     const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state.requestsList.length,
                                        itemBuilder: (context, i) {
                                          return PendingApprovalsCustomWidget(
                                            attendanceModel:
                                                state.requestsList[i],
                                            surfix: CustomPopupMenu(
                                              onSelected: (index) {
                                                // print("Selected index: $index");

                                                if (index == 0) {
                                                  // Approve
                                                  context
                                                      .read<AdmHomeBloc>()
                                                      .add(
                                                        RejectOrApproveReqEvent(
                                                          employeeID: state
                                                              .requestsList[i]
                                                              .employeeId
                                                              .toString(),
                                                          transID: state
                                                              .requestsList[i]
                                                              .attendanceTransactionId
                                                              .toString(),
                                                          employerID:
                                                              user!.employerId,
                                                          approvalStatus: true,
                                                        ),
                                                      );
                                                } else if (index == 1) {
                                                  // Reject
                                                  context
                                                      .read<AdmHomeBloc>()
                                                      .add(
                                                        RejectOrApproveReqEvent(
                                                          employeeID: state
                                                              .requestsList[i]
                                                              .employeeId
                                                              .toString(),
                                                          transID: state
                                                              .requestsList[i]
                                                              .attendanceTransactionId
                                                              .toString(),
                                                          employerID:
                                                              user!.employerId,
                                                          approvalStatus: false,
                                                        ),
                                                      );
                                                } else if (index == 2) {
                                                  // Map
                                                  router.push(
                                                    AttendenceDetailLocationRoute(
                                                      attendanceModel:
                                                          state.requestsList[i],
                                                    ),
                                                  );
                                                } else {
                                                  showToast(
                                                      msg:
                                                          'Invalid Option Selected');
                                                }
                                              },
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem<int>(
                                                    height: 28,
                                                    value: 0,
                                                    child: CustomPopItem(
                                                      icon: Assets
                                                          .icons.checkOutline,
                                                      title: "Approve",
                                                    ),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    height: 28,
                                                    value: 1,
                                                    child: CustomPopItem(
                                                      icon: Assets
                                                          .icons.closeOutline,
                                                      title: "Reject",
                                                    ),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    height: 28,
                                                    value: 2,
                                                    child: CustomPopItem(
                                                      icon: Assets.icons
                                                          .locationPlaceOutline,
                                                      title: "Map",
                                                    ),
                                                  ),
                                                ];
                                              },
                                            ),
                                          );
                                        },
                                      ));
                                    }

                                    return const Expanded(
                                      child: Center(child: Text('No Requests')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
