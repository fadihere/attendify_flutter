// ignore_for_file: avoid_print, unused_element, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/leave/data/models/leave_attendance_model.dart';
import 'package:attendify_lite/app/features/employer/leave/presentation/widgets/custom_dropdown.dart';
import 'package:attendify_lite/app/shared/datasource/noti_remote_db.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/fcm_helper.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../bloc/leave_bloc.dart';

@RoutePage()
class LeaveApplyEmpScreen extends StatefulWidget {
  const LeaveApplyEmpScreen({super.key});

  @override
  State<LeaveApplyEmpScreen> createState() => _LeaveApplyEmpScreenState();
}

class _LeaveApplyEmpScreenState extends State<LeaveApplyEmpScreen> {
  List<Map<String, dynamic>> data = [];
  bool loading = false;
  String? selectedValue;
  List filteredData = [];
  TextEditingController msgController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  // int? id;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    msgController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply For Leave',
          style: TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            CustomTextFormField(
              controller: dateController,
              /* labelCustomColor:
                  endTime != null ? context.color.font : context.color.hint, */
              labelText:
                  "${DateFormat('dd MMM').format(DateTime.now())}  /  ${DateFormat('dd MMM').format(DateTime.now().nextDay)}",

              readOnly: true,
              onTap: () async {
                final pickedDateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  currentDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  lastDate: DateTime(2030),
                );
                if (pickedDateRange != null) {
                  setState(() {
                    startTime = pickedDateRange.start;
                    endTime = pickedDateRange.end;
                    dateController.text =
                        "${DateFormat('dd MMM').format(startTime!)}  /  ${DateFormat('dd MMM').format(endTime!)}";
                  });
                }
                print("Datee:::##${pickedDateRange?.start ?? "empty dude!!"}");
              },
              prefixIcon: Assets.icons.logsOutline.svg(
                  colorFilter: ColorFilter.mode(
                context.color.primary,
                BlendMode.srcIn,
              )),
              //days
              suffixIcon: Text(
                '${endTime?.difference(startTime ?? DateTime.now()).inDays ?? DateTime.now().difference(startTime ?? DateTime.now()).inDays} Days',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.color.hint),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: CustDropDown<String>(
                displayStringForItem: (item) => item,
                items: filteredData.map((category) {
                  return CustDropdownMenuItem<String>(
                    value: category.toString(),
                    child: Text(
                      category,
                      style: const TextStyle(
                          fontFamily: FontFamily.hellix,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                hintText: "Select Leaves Category",
                borderRadius: 20,
                onChanged: (val) {
                  selectedValue = val;
                },
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomTextFormField(
              controller: msgController,
              maxLines: 7,
              hintText: 'Type your reason here',
              labelText: 'Type your reason here',
              minLines: 7,
            ),
            AppButtonWidget(
              margin: EdgeInsets.only(top: 20.r),
              onTap: () {
                final id = findIdByCategoryName(data, selectedValue ?? "");

                _postData(id ?? 0, context);
              },
              text: 'SUBMIT',
            )
          ],
        ),
      ),
    );
  }

  int? findIdByCategoryName(
      List<Map<String, dynamic>> dataList, String categoryName) {
    for (var data in dataList) {
      if (data['category_name'] == categoryName) {
        return data['id'];
      }
    }
    return null;
  }

  Future<void> _fetchData() async {
    final authBloc = context.read<AuthEmpBloc>();
    final employerID = authBloc.state.user!.employerId;
    setState(() {
      loading = true;
    });

    try {
      Response response = await Dio()
          .get('http://92.204.170.104:9889/leave-policies/$employerID/');
      // print("emr id :::::::::::##$employerID");

      data = List<Map<String, dynamic>>.from(response.data);
      filteredData = data.map((e) => e["category_name"]).toList();
      loading = false;

      print('Success fetching data: $data');
      print("##############empName${authBloc.state.user?.employerId}");
    } catch (e) {
      loading = false;

      print('Error fetching data: $e');
    }
    setState(() {});
  }

  Future<void> _postData(int id, BuildContext context) async {
    BotToast.showLoading();
    final authBloc = context.read<AuthEmpBloc>();
    final user = authBloc.state.user!;
    print("emr id :::::::::::##$user");

    try {
      // Create Dio instance
      Dio dio = Dio();

      // Define data to be sent in the request body
      Map<String, dynamic> data = {
        'employer_id': user.employerId,
        'employees_id': user.employeeId,
        'recorded_time_in': startTime!.toIso8601String().split('.').first,
        'transaction_date': DateTime.now().toIso8601String().split('.').first,
        'attendance_choices': 'LEV',
        'recorded_time_out': endTime!.toIso8601String().split('.').first,
        'message': msgController.text.toString(),
        'leave_policy_emp': id,
      };
      log("hellohelloo#:::${data.toString()}");

      // Send POST request

      // print(
      //     'startTime endTime data: ${startTime!.toString().substring(5, 10)} ${endTime!.toString().substring(5, 10)}');
      final response = await dio.post(
        'http://92.204.170.104:9889/attendance-transaction/',
        data: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        final model = leaveAttendanceModelFromMap(response.data);
        final String start =
            "${startTime!.toString().substring(5, 10)} / ${endTime!.toString().substring(5, 10)}";
        final String startDay = DateFormat('d MMMM y').format(startTime!);
        final String endDay = DateFormat('d MMMM y').format(endTime!);

        NotiRemoteDB.sendNotificationAPI(
            title: 'Leave request',
            subTitle:
                '${authBloc.state.user!.employeeName} requested leaves on $start',
            employeeID: authBloc.state.user!.employeeId,
            employerID: authBloc.state.user!.employerId,
            notificationType: "Leave",
            attendanceID: model.id);

        // final String start = "${startTime!.toString().substring(5, 10)} / ${endTime!.toString().substring(5, 10)}";
        // final String startDay = startTime!.toString().substring(5, 10);
        // final String endDay = endTime!.toString().substring(5, 10);
        /*  NotiRemoteDB.sendNotificationAPI(
            title: 'Leave request',
            subTitle:
                '${authBloc.state.user!.employeeName} requested leaves on $start',
            employeeID: authBloc.state.user!.employeeId,
            employerID: authBloc.state.user!.employerId); */

        if (authBloc.state.user!.employerToken.isNotEmpty) {
          FCMHelper.sendNotification(
              authBloc.state.user!.employerToken,
              'Leave request',
              '${authBloc.state.user!.employeeName} has requested for leaves from $startDay to $endDay',
              'employer');
        }
        data.clear();
        filteredData.clear;
        selectedValue = "";
        msgController.clear();
        startTime = DateTime.now();
        endTime = DateTime.now();

        BotToast.closeAllLoading();
        showToast(msg: "Leave request sent");

        context.read<LeaveBloc>().add(FetchLeaveTransactionsEvent(
            employeeID: user.employeeId, startDate: DateTime.now()));
        router.maybePop();
        return;
      }

      BotToast.closeAllLoading();
      showToast(msg: "leave request not sent");

      // NotiRemoteDB.sendNotificationAPI(
      //     title: 'Leave request',
      //     subTitle: 'Leave Ahzax',
      //     employeeID: "76_102",
      //     employerID: "76");
    } catch (e) {
      BotToast.closeAllLoading();

      print('Error sending POST request: $e');
      if (endTime == null) {
        return showToast(msg: " Date must not be empty");
      }
      if (msgController.text == "") {
        return showToast(msg: " Reason must not be empty");
      }

      if (selectedValue == null) {
        return showToast(msg: " Category must not be empty");
      }
    }
  }
}
