import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/leave/presentation/pages/leave_apply_page.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../bloc/leave_bloc.dart';
import '../widgets/leave_list_item.dart';

@RoutePage()
class LeaveDashboardPage extends StatefulWidget {
  const LeaveDashboardPage({super.key});

  @override
  State<LeaveDashboardPage> createState() => _LeaveDashboardPageState();
}

class _LeaveDashboardPageState extends State<LeaveDashboardPage> {
  @override
  void initState() {
    final user = context.read<AuthEmpBloc>().state.user;
    context.read<LeaveBloc>().add(FetchLeaveCountsEvent(
          employerID: user!.employerId,
          employeeID: user.employeeId,
        ));

    context.read<LeaveBloc>().add(FetchLeaveTransactionsEvent(
        employeeID: user.employeeId, startDate: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Leaves',
          style: TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: BlocBuilder<LeaveBloc, LeaveState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final total = state.leaveCount?.totalAllowanceCount?.toInt() ?? 0;

          final taken = state.leaveCount?.leaveTaken?.toInt() ?? 0;
          final pending = total - taken;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 98.r,
                          width: 144.r,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: dropShadowDecoration(context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.leaveCount?.totalAllowanceCount
                                        .toString() ??
                                    '0',
                                style: TextStyle(
                                    color: context.color.primary,
                                    fontSize: 34.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Total Leaves',
                                style: TextStyle(
                                    color: context.color.font,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 98.r,
                          width: 144.r,
                          alignment: Alignment.center,
                          decoration: dropShadowDecoration(context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                pending.toString(),
                                style: TextStyle(
                                    color: context.color.hint,
                                    fontSize: 34.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Pending Leaves',
                                style: TextStyle(
                                    color: context.color.font,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(10.h),
                  BlocBuilder<LeaveBloc, LeaveState>(
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: AppSize.sidePadding,
                        width: 327.r,
                        decoration: dropShadowDecoration(context),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              width: 237.r,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: context.color.outline),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTabBarWidget(
                                      title: "Approved",
                                      isSelected: state.currentIndex == 0,
                                      onTap: () {
                                        context.read<LeaveBloc>().add(
                                            const ChangeTabEvent(index: 0));
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTabBarWidget(
                                      title: "Pending",
                                      isSelected: state.currentIndex == 1,
                                      onTap: () {
                                        context.read<LeaveBloc>().add(
                                            const ChangeTabEvent(index: 1));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(10.h),
                            const Divider(),
                            Gap(5.h),

                            state.currentIndex == 0
                                ? state.approvedLeaveList.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        // physics:
                                        //     const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            state.approvedLeaveList.length,
                                        itemBuilder: (context, index) {
                                          return LeaveListItem(
                                            transactionModel:
                                                state.approvedLeaveList[index],
                                          );
                                        },
                                      )
                                    : SizedBox(
                                        height: height * 0.2,
                                        child: const Center(
                                          child: Text('No request to show'),
                                        ),
                                      )
                                : state.pendingLeaveList.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        // physics:
                                        //     const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            state.pendingLeaveList.length,
                                        itemBuilder: (context, index) {
                                          return LeaveListItem(
                                            transactionModel:
                                                state.pendingLeaveList[index],
                                          );
                                        },
                                      )
                                    : SizedBox(
                                        height: height * 0.2,
                                        child: const Center(
                                          child: Text('No request to show'),
                                        ),
                                      ),
                            // TabBar(
                            //   controller: controller,
                            //   onTap: (index) => context
                            //       .read<LeaveBloc>()
                            //       .add(ChangeTabEvent(currentIndex: index)),
                            //   indicatorSize: TabBarIndicatorSize.tab,
                            //   dividerColor: Colors.transparent,
                            //   indicator: BoxDecoration(
                            //       color: context.color.primary,
                            //       borderRadius: BorderRadius.circular(30)),
                            //   labelStyle: const TextStyle(color: Colors.white),
                            //   unselectedLabelColor: Colors.grey.shade600,
                            //   tabs: tabsList,
                            // ),
                            // Divider(height: 0.5, color: Colors.grey.shade400),
                            // state.currentIndex == 0
                            //     ? ListView.separated(
                            //         shrinkWrap: true,
                            //         physics: const NeverScrollableScrollPhysics(),
                            //         separatorBuilder: (context, index) {
                            //           return Divider(
                            //             color: Colors.grey.shade400,
                            //             height: 0.5,
                            //           );
                            //         },
                            //         itemCount: 8,
                            //         itemBuilder: (context, index) {
                            //           return LeaveListItem(index: index);
                            //         },
                            //       )
                            //     : const SizedBox(
                            //         height: 40,
                            //         child: Center(child: Text('No Data To Show')),
                            //       )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Gap(10),
              AppButtonWidget(
                margin:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LeaveApplyEmpScreen(),
                    ),
                  );
                },
                text: 'APPLY LEAVES',
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomTabBarWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  const CustomTabBarWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? context.color.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.sp),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
                color: isSelected
                    ? context.color.scaffoldBackgroundColor
                    : context.color.font,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
