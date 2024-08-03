import 'package:attendify_lite/app/features/employer/leave/presentation/bloc/leave_emr_bloc.dart';
import 'package:attendify_lite/app/shared/widgets/pop_up_menu.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/res/export.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../employee/leave/presentation/widgets/leave_tag_button.dart';
import '../../../auth/data/models/user_emr_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/leave_policy_model.dart';

@RoutePage()
class LeavePeriodScreen extends StatefulWidget {
  const LeavePeriodScreen({super.key});

  @override
  State<LeavePeriodScreen> createState() => _LeavePeriodScreenState();
}

class _LeavePeriodScreenState extends State<LeavePeriodScreen> {
  // late TextEditingController fromDateController;
  // late TextEditingController toDateController;
  // String fromDate = '';
  // String toDate = '';
  @override
  void initState() {
    /*   final list = context.read<LeaveEmrBloc>().state.leaveList;
    if (list.isNotEmpty) {
      fromDateController = TextEditingController(
          text: list.last.fromDate?.format('yMMMd') ??
              DateTime.now().format('yMMMd'));
      toDateController = TextEditingController(
          text: list.last.toDate?.format('yMMMd') ??
              DateTime.now().nextYear.format('yMMMd'));
      return;
    } else {
      fromDateController = TextEditingController();
      toDateController = TextEditingController();
    } */
    super.initState();
  }

  @override
  void dispose() {
    // fromDateController.dispose();
    // toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.sizeOf(context).width;
    final user = context.read<AuthEmrBloc>().state.user;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.leavePeriod,style:  TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: BlocBuilder<LeaveEmrBloc, LeaveEmrState>(
        builder: (context, state) {
          return Padding(
            padding: AppSize.overallPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*   CustomTextFormField(
                  onTap: _showFromDatePickerDialog,
                  readOnly: true,
                  isDense: true,
                  hintText: 'From Date',
                  controller: fromDateController,
                  prefixIcon: Assets.icons.calendarOutline.svg(),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomTextFormField(
                  onTap: _showToDatePickerDialog,
                  isDense: true,
                  readOnly: true,
                  controller: toDateController,
                  hintText: 'To Date',
                  prefixIcon: Assets.icons.calendarOutline.svg(),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                AppButtonWidget(
                  isLoading: state.status == Status.loading,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    if (state.leaveList.isEmpty) {
                      showToast(
                          msg:
                              'There should be atleast one policy in order to update');
                      return;
                    }
                    if (fromDateController.text.isEmpty ||
                        toDateController.text.isEmpty) {
                      showToast(msg: 'Both dates are required');
                      return;
                    }
            
                    context.read<LeaveEmrBloc>().add(UpdateLeavePolicyPeriodEvent(
                        employerID: user!.employerId,
                        fromDate: fromDate.isNotEmpty
                            ? fromDate
                            : DateTime.now().toIso8601String().split('.').first,
                        toDate: toDate.isNotEmpty
                            ? toDate
                            : DateTime.now()
                                .nextYear
                                .toIso8601String()
                                .split('.')
                                .first));
                  },
                  text: 'SET DURATION',
                ),
                SizedBox(
                  height: height * 0.04,
                ), 
                Divider(
                  color: Colors.grey.shade300,
                  height: 0.08,
                ),*/
                state.leaveList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.leaveList.length,
                          separatorBuilder: (_, index) {
                            return Divider(
                              color: Colors.grey.shade300,
                              height: 0.1,
                            );
                          },
                          itemBuilder: (context, index) {
                            return LeavePolicyWidget(
                              height: height,
                              index: index,
                              leaveList: state.leaveList,
                              user: user!,
                            );
                          },
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text('Haven\'t added any leave policy'),
                        ),
                      ),
                const Gap(10),
                AppButtonWidget(
                  onTap: () {
                    router.push(LeaveCategoryRoute(isUpdate: false));
                  },
                  text: 'Add new leave type',
                  margin: EdgeInsets.only(bottom: 30.h),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class LeavePolicyWidget extends StatelessWidget {
  final List<LeavePolicyModel> leaveList;
  final int index;
  final UserEmrModel user;
  const LeavePolicyWidget(
      {super.key,
      required this.height,
      required this.index,
      required this.leaveList,
      required this.user});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border(
              bottom: index == leaveList.length
                  ? BorderSide(color: Colors.grey.shade300, width: 1)
                  : BorderSide.none)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    leaveList[index].categoryName ?? 'Sick',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const Gap(15),
                  LeaveTagButton(title: leaveList[index].status!)
                ],
              ),
              SizedBox(
                height: height * 0.008,
              ),
              Text(
                'Total ${leaveList[index].allowance.toString()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          CustomPopupMenu(onSelected: (i) {
            switch (i) {
              case 0:
                router.push(LeaveCategoryRoute(
                  isUpdate: true,
                  leavePolicyModel: leaveList[index],
                ));
                break;
              case 1:
                context.read<LeaveEmrBloc>().add(DeleteLeavePolicyEvent(
                    employerID: user.employerId,
                    policyID: leaveList[index].id!));
                break;
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                height: 40.r,
                value: 0,
                child: CustomPopItem(
                  icon: Assets.icons.edit,
                  title: "Edit",
                ),
              ),
              PopupMenuItem<int>(
                height: 40.r,
                value: 1,
                child: CustomPopItem(
                  icon: Assets.icons.deleteOutline,
                  title: "Delete",
                ),
              )
            ];
          }),
        ],
      ),
    );
  }
}
