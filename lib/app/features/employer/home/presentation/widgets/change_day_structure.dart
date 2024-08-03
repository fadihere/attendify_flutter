import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeDayStructure extends StatelessWidget {
  final void Function(DateTime)? onDateChange;
  const ChangeDayStructure({
    super.key,
    this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      disabledDates: const [],
      onDateChange: onDateChange,
      activeColor: context.color.font,
      headerProps: EasyHeaderProps(
        showSelectedDate: false,
        selectedDateStyle: TextStyle(
            color: context.color.font,
            fontWeight: FontWeight.w500,
            fontFamily: FontFamily.hellix),
        monthStyle: TextStyle(
            color: context.color.font,
            fontWeight: FontWeight.w500,
            fontFamily: FontFamily.hellix),
      ),
      dayProps: EasyDayProps(
          dayStructure: DayStructure.dayNumDayStr,
          height: 56.r,
          width: 56.r,
          todayStyle: DayStyle(
            dayNumStyle: TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF629DFF),
                fontFamily: FontFamily.hellix),
            dayStrStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF629DFF),
                fontFamily: FontFamily.hellix),
          ),
          activeDayStyle: DayStyle(
              dayNumStyle: TextStyle(
                  fontSize: 18.r,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF629DFF),
                  fontFamily: FontFamily.hellix),
              dayStrStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF629DFF),
                  fontFamily: FontFamily.hellix),
              decoration: BoxDecoration(
                border: Border.all(color: context.color.primary, width: 1.5.r),
                borderRadius: BorderRadius.circular(10),
                color: context.color.whiteBlack,
              )),
          inactiveDayStyle: DayStyle(
            dayNumStyle: TextStyle(
              fontSize: 18.r,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.hellix,
            ),
            dayStrStyle: TextStyle(
                fontSize: 10.r,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.hellix,
                color: Colors.grey.shade500),
          )),
    );
  }
}
