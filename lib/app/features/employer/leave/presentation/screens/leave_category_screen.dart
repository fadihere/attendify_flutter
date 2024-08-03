import 'dart:developer';

import 'package:attendify_lite/app/features/employer/leave/data/models/leave_policy_model.dart';
import 'package:attendify_lite/app/features/employer/leave/presentation/bloc/leave_emr_bloc.dart';
import 'package:attendify_lite/app/features/employer/leave/presentation/widgets/custom_dropdown.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dart_date/dart_date.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/enums/status.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class LeaveCategoryPage extends StatefulWidget {
  final bool isUpdate;
  final LeavePolicyModel? leavePolicyModel;
  const LeaveCategoryPage({
    super.key,
    required this.isUpdate,
    this.leavePolicyModel,
  });

  @override
  State<LeaveCategoryPage> createState() => _LeaveCategoryPageState();
}

class _LeaveCategoryPageState extends State<LeaveCategoryPage> {
  late TextEditingController categoryController;
  late TextEditingController allowanceController;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  String fromDate = '';
  DateTime? localFromDate;
  DateTime? localToDate;
  String toDate = '';

  @override
  void initState() {
    if (widget.isUpdate) {
      log(widget.leavePolicyModel!.toMap().toString());
      categoryController = TextEditingController(
          text: widget.leavePolicyModel?.categoryName ?? '');
      allowanceController = TextEditingController(
          text: widget.leavePolicyModel?.allowance.toString() ?? '');
      fromDateController = TextEditingController(
          text: widget.leavePolicyModel!.fromDate?.format('yMMMd') ??
              DateTime.now().format('yMMMd'));
      toDateController = TextEditingController(
          text: widget.leavePolicyModel!.toDate?.format('yMMMd') ??
              DateTime.now().nextYear.format('yMMMd'));
      fromDate = widget.leavePolicyModel!.fromDate != null
          ? widget.leavePolicyModel!.fromDate!
              .toIso8601String()
              .split('.')
              .first
          : DateTime.now().nextYear.toIso8601String().split('.').first;
      toDate = widget.leavePolicyModel!.toDate != null
          ? widget.leavePolicyModel!.toDate!.toIso8601String().split('.').first
          : DateTime.now().nextYear.toIso8601String().split('.').first;

      return;
    }
    categoryController = TextEditingController();
    allowanceController = TextEditingController();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
    fromDate = DateTime.now().toIso8601String().split('.').first;
    toDate = DateTime.now().nextYear.toIso8601String().split('.').first;
    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();
    allowanceController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthEmrBloc>().state.user;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isUpdate ? 'Edit Leave Type' : 'Add Leave Type',
          style: const TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: BlocBuilder<LeaveEmrBloc, LeaveEmrState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: 'Leave Type',
                    labelText: 'Leave Type',
                    controller: categoryController,
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextFormField(
                    hintText: 'Number of Leaves',
                    labelText: 'Number of Leaves',
                    keyboardType: TextInputType.number,
                    controller: allowanceController,
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextFormField(
                    onTap: () {
                      _showFromDatePickerDialog(context);
                    },
                    readOnly: true,
                    isDense: true,
                    hintText: 'Start Date',
                    labelText: 'Start Date',
                    controller: fromDateController,
                    /*   prefixIcon: Assets.icons.calendarOutline.svg(
                        colorFilter: ColorFilter.mode(
                            context.color.font, BlendMode.srcIn)), */
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomTextFormField(
                    onTap: () {
                      _showToDatePickerDialog(context);
                    },
                    isDense: true,
                    readOnly: true,
                    controller: toDateController,
                    hintText: 'End Date',
                    labelText: 'End Date',
                    /*  prefixIcon: Assets.icons.calendarOutline.svg(
                      colorFilter:
                          ColorFilter.mode(context.color.font, BlendMode.srcIn),
                    ), */
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: CustDropDown<String>(
                      displayStringForItem: (item) => item,
                      items: [
                        CustDropdownMenuItem<String>(
                          value: 'Paid',
                          child: Text(
                            "Paid",
                            style: TextStyle(
                              color: context.color.font,
                              fontSize: 16.r,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        CustDropdownMenuItem(
                          value: 'Unpaid',
                          child: Text(
                            "Unpaid",
                            style: TextStyle(
                              color: context.color.font,
                              fontSize: 16.r,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                      hintText: "Select Status",
                      borderRadius: 14.r,
                      overlayWidth: 335.w,
                      onChanged: (val) {
                        context
                            .read<LeaveEmrBloc>()
                            .add(ChangeLeaveStatusEvent(leaveStatus: val!));
                      },
                    ),
                  ),
                  /*  PopupMenuButton(
                      child: const SizedBox(
                        child: CustomTextFormField(
                          hintText: 'Select Status',
                          readOnly: true,
                        ),
                      ),
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text('Paid'),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Unpaid'),
                            ),
                          ]), */
                  /*   DropdownButton(
                    hint: Text(
                      'Select Status',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    isExpanded: true,
                    value: state.leaveStatus,
                    items: const [
                      DropdownMenuItem(
                        value: 'Paid',
                        child: Text('Paid'),
                      ),
                      DropdownMenuItem(
                        value: 'Unpaid',
                        child: Text('Unpaid'),
                      ),
                    ],
                    onChanged: (value) {
                      context
                          .read<LeaveEmrBloc>()
                          .add(ChangeLeaveStatusEvent(leaveStatus: value!));
                    },
                  ),
                  */ /*  SizedBox(
                    height: 50.r,
                    child: DropdownButtonFormField(
                        hint: Text(
                          'Select Status',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(
                            maxWidth: 20.r,
                            minWidth: 20.r,
                          ),
                          prefixIcon: const SizedBox(),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(
                              color: context.color.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(
                              color: context.color.primary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(
                              color: context.color.outline,
                            ),
                          ),
                        ),
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Paid',
                            child: Text('Paid'),
                          ),
                          DropdownMenuItem(
                            value: 'Unpaid',
                            child: Text('Unpaid'),
                          ),
                        ],
                        onChanged: (value) {
                          context.read<LeaveEmrBloc>().add(
                              ChangeLeaveStatusEvent(leaveStatus: value ?? ""));
                        }),
                  ),
                   */
                  SizedBox(height: height * 0.04),
                  AppButtonWidget(
                    margin: EdgeInsets.zero,
                    isLoading: state.status == Status.loading,
                    onTap: () {
                      if (allowanceController.text.isEmpty ||
                          categoryController.text.isEmpty ||
                          fromDateController.text.isEmpty ||
                          toDateController.text.isEmpty) {
                        showToast(msg: 'All Fields Are Required');
                        return;
                      }
                      if (localFromDate!.isAtSameMomentAs(localToDate!)) {
                        showToast(
                            msg:
                                'Cannot select End Date before the Start Date');
                        return;
                      }

                      // if()
                      if (widget.isUpdate) {
                        context.read<LeaveEmrBloc>().add(UpdateLeavePolicyEvent(
                            leaveModel: widget.leavePolicyModel!,
                            categoryName: categoryController.text,
                            allowance: allowanceController.text,
                            fromDate: fromDate,
                            toDate: toDate));
                        categoryController.clear();
                        allowanceController.clear();
                        toDateController.clear();
                        fromDateController.clear();
                        return;
                      }
                      context.read<LeaveEmrBloc>().add(CreateLeavePolicyEvent(
                          employerID: user!.employerId,
                          categoryName: categoryController.text,
                          allowance: allowanceController.text,
                          fromDate: fromDate,
                          toDate: toDate));

                      categoryController.clear();
                      allowanceController.clear();
                      toDateController.clear();
                      fromDateController.clear();
                    },
                    text: widget.isUpdate ? 'UPDATE' : 'ADD LEAVE TYPE',
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _showFromDatePickerDialog(BuildContext context) async {
    final date = await showDatePickerDialog(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        context: context,
        maxDate: DateTime(2030),
        minDate: DateTime.now());
    if (date != null) {
      fromDateController.text = date.format('yMMMd');
      localFromDate = date;
      fromDate = date.toIso8601String().split('.').first;
      setState(() {});
    }
  }

  _showToDatePickerDialog(BuildContext context) async {
    final date = await showDatePickerDialog(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        context: context,
        maxDate: DateTime(2030),
        minDate: DateTime.now());
    if (localFromDate.isNull) {
      showToast(msg: 'Please select start date first');
      toDateController.clear();
      return;
    }

    if (date != null && !localFromDate!.isAfter(date)) {
      toDateController.text = date.format('yMMMd');
      toDate = date.toIso8601String().split('.').first;
      localToDate = date;
      setState(() {});
      return;
    } else {
      toDateController.clear();
      showToast(msg: 'Cannot select to date before the start date');
    }
  }
}
