import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceDetailTileWidget extends StatelessWidget {
  final String date;
  final String time;
  final String workinghrs;
  final VoidCallback onPressed;

  const AttendanceDetailTileWidget({
    super.key,
    required this.date,
    required this.time,
    required this.workinghrs,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: AppSize.sidePadding,
      width: 327.r,
      height: 104.r,
      decoration: dropShadowDecoration(context, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: context.color.font,
                  fontSize: 18.r,
                  fontFamily: 'Hellix',
                  fontWeight: FontWeight.w600,
                  height: 0.07.r,
                ),
              ),
              InkWell(
                onTap: onPressed,
                child: Container(
                  width: 95.r,
                  height: 26.r,
                  decoration: ShapeDecoration(
                    color: context.color.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'VIEW LOCATION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.r,
                        fontFamily: 'Hellix',
                        fontWeight: FontWeight.w600,
                        height: 0.17.r,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const Gap(18),
          Text(
            time,
            style: TextStyle(
              color: context.color.font,
              fontSize: 16.r,
              fontFamily: 'Hellix',
              fontWeight: FontWeight.w400,
              height: 0.08.r,
            ),
          ),
          const Gap(28),
          Text(
            'Working Hours: $workinghrs',
            style: TextStyle(
              color: context.color.font,
              fontSize: 16.r,
              fontFamily: 'Hellix',
              fontWeight: FontWeight.w400,
              height: 0.08.r,
            ),
          ),
        ],
      ),
    );
  }
}
