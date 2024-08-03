import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AttendanceRecordTypeLocalWidget extends StatelessWidget {
  const AttendanceRecordTypeLocalWidget({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.attendaceType,
    required this.totalRecord,
  });

  final double height;
  final double width;
  final Color color;
  final String attendaceType;
  final int totalRecord;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.07,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.whiteBlack,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 22,
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.09),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              height: double.infinity,
              width: width * 0.015,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: ColoredBox(
                  color: color,
                ),
              ),
            ),
            SizedBox(
              width: width * 0.036,
            ),
            Text(
              attendaceType,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Text(
              totalRecord.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: width * 0.046,
            ),
          ],
        ),
      ),
    );
  }
}
