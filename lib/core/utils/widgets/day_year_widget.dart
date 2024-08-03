// ignore_for_file: must_be_immutable

import 'package:attendify_lite/app/features/employer/leave/presentation/widgets/custom_dropdown.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthPickerWidget extends StatefulWidget {
  MonthPickerWidget(
      {required this.initialYear,
      required this.startYear,
      required this.endYear,
      this.currentYear,
      required this.month,
      super.key});
  late int initialYear;
  late int startYear;
  late int endYear;
  late int? currentYear;
  late int month;
  @override
  State<MonthPickerWidget> createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  final List<String> _monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final List<String> _yearList = [];
  late int selectedMonthIndex;
  late int selectedYearIndex;
  String selectedMonth = "";
  String selectedYear = "";
  @override
  void initState() {
    for (int i = widget.startYear; i <= widget.endYear; i++) {
      _yearList.add(i.toString());
    }
    selectedMonthIndex = widget.month - 1;
    selectedYearIndex = _yearList.indexOf(
        widget.currentYear?.toString() ?? widget.initialYear.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedMonth = _monthList[selectedMonthIndex];
        selectedYear = _yearList[selectedYearIndex];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: CustDropDown(
                overlayWidth: 165.w,
                margin: 6.r,
                hintText: 'Year',
                items: _yearList
                    .map((e) => CustDropdownMenuItem(
                        value: e,
                        child: Text(e,
                            style: TextStyle(color: context.color.hintDark))))
                    .toList(),
                onChanged: (value) {},
                displayStringForItem: (value) => value),
          ),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: CustDropDown(
                overlayWidth: 165.w,
                margin: 6.r,
                hintText: 'Month',
                items: _monthList
                    .map((e) => CustDropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(color: context.color.hintDark),
                        )))
                    .toList(),
                onChanged: (value) {},
                displayStringForItem: (value) => value),
          ),
        ),
        // Container(
        //   width: 162.w,
        //   height: 44.h,
        //   decoration: ShapeDecoration(
        //     shape: RoundedRectangleBorder(
        //       side: BorderSide(color: context.color.outline),
        //       borderRadius: BorderRadius.circular(50),
        //     ),
        //   ),
        //   child: Expanded(
        //     child: DropdownButton<String>(
        //       underline: Container(),
        //       items: _yearList.map((e) {
        //         return DropdownMenuItem<String>(value: e, child: Text(e));
        //       }).toList(),
        //       value: selectedYear,
        //       onChanged: (val) {
        //         setState(() {
        //           selectedYear = val ?? "";
        //         });
        //       },
        //     ),
        //   ),
        // ),
        // Container(
        //   width: 162.w,
        //   height: 44.h,
        //   decoration: ShapeDecoration(
        //     shape: RoundedRectangleBorder(
        //       side: BorderSide(color: context.color.outline),
        //       borderRadius: BorderRadius.circular(50),
        //     ),
        //   ),
        //   child: DropdownButton<String>(
        //     underline: Container(),
        //     items: _monthList.map((e) {
        //       return DropdownMenuItem<String>(value: e, child: Text(e));
        //     }).toList(),
        //     value: selectedMonth,
        //     onChanged: (val) {
        //       setState(() {
        //         selectedMonthIndex = _monthList.indexOf(val!);
        //         selectedMonth = val ?? "";
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}
