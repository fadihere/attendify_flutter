import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onchange;
  final DateTime initialValue;
  final double? width;
  final String? format;

  const DatePickerWidget({
    super.key,
    required this.onchange,
    required this.initialValue,
    this.width,
    this.format,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePickerDialog(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      context: context,
      initialDate: start,
      daysOfTheWeekTextStyle: const TextStyle(fontSize: 11),
      minDate: DateTime(2023),
      maxDate: DateTime.now(),
    );
    if (picked != null && picked != start) {
      setState(() {
        start = picked;
        widget.onchange(start);
      });
    }
  }

  @override
  void initState() {
    start = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectStartDate(context),
      child: Container(
        width: widget.width ?? 162.w,
        height: 44.h,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: context.color.outline),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${start.day.toString().padLeft(2, "0")} - ${start.month.toString().padLeft(2, "0")} - ${start.year}",
              style: TextStyle(
                color: context.color.font,
                fontSize: 16.sp,
                fontFamily: 'Hellix',
                fontWeight: FontWeight.w500,
                height: 1.25.r,
              ),
            ),
            SizedBox(
              width: 13.r,
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24.r,
              color: context.color.hintDark,
            ),
            // Icon(
            //   Icons.calendar_month_outlined,
            //   color: context.color.primary,
            // ),
          ],
        ),
      ),
    );
  }
}
