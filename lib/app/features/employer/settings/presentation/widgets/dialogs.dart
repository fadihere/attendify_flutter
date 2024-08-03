import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/gen/assets.gen.dart';

class EmailChangedWidget extends StatelessWidget {
  const EmailChangedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 305.sp,
        width: 327.sp,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(54),
              Assets.icons.emailOutline.svg(
                width: 50,
                height: 50,
                colorFilter: ColorFilter.mode(
                  context.color.primary,
                  BlendMode.srcIn,
                ),
              ),
              Gap(36.sp),
              const Text(
                "Email Changed\nSuccessfully!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(55.sp),
            ],
          ),
        ),
      ),
    );
  }
}
