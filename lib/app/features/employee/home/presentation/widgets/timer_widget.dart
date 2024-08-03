import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/gen/assets.gen.dart';
import '../../../../../../core/gen/fonts.gen.dart';

class TimerWidget extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String dateTime;
  const TimerWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon.svg(
            colorFilter: ColorFilter.mode(
              context.color.primary,
              BlendMode.srcIn,
            ),
            width: 36.r,
            height: 36.r),
        const Gap(5),
        Text(
          dateTime,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: FontFamily.hellix),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: FontFamily.hellix,
            color: context.color.icon,
          ),
        ),
      ],
    );
  }
}
