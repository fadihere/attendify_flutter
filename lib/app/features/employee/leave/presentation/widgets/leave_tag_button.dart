import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveTagButton extends StatelessWidget {
  final String title;

  const LeaveTagButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: title == 'paid' || title == 'Paid'
              ? context.color.present.withOpacity(0.1)
              : context.color.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 10,
            color: title == 'paid' || title == 'Paid'
                ? context.color.present
                : context.color.warning,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LeaveTagTwoButton extends StatelessWidget {
  final dynamic status;

  const LeaveTagTwoButton({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: status == true
              ? context.color.present.withOpacity(0.2)
              : context.color.warning.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25)),
      child: Text(
        status == true ? 'APPROVED' : 'APPROVAL PENDING',
        style: TextStyle(
            fontSize: 10.sp,
            color: status == true ? context.color.present : context.color.red,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
