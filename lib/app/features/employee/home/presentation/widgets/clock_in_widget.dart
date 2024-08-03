import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/gen/assets.gen.dart';

class CheckInWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool isClockedIn;
  final bool? isApproved;
  const CheckInWidget({
    super.key,
    this.isClockedIn = false,
    required this.onTap,
    this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170.r,
        height: 160.r,
        decoration: BoxDecoration(
            color: context.color.primary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.color.primary.withOpacity(0.3),
              width: 8,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            //isClockedIn == true && isApproved == true
            gradient: isClockedIn == true || isApproved == true
                ? const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFFC34961),
                      Color(0xFF639EFF),
                    ],
                  )
                : null),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              //!isClockedIn && isApproved == null || isApproved == false
              isClockedIn == false || isApproved != null || isApproved == false
                  ? Assets.icons.clockIn.path
                  : Assets.icons.clockOut.path,
              width: 60.r,
              height: 60.r,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const Gap(10),
            Text(
              //!isClockedIn && isApproved == null || isApproved == false
              !isClockedIn || isApproved != null || isApproved == false
                  ? 'Clock In'
                  : 'Clock Out',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
