import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PasswordChangedWidget extends StatelessWidget {
  const PasswordChangedWidget({super.key});

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
              Assets.icons.passwordChanged.svg(
                colorFilter: ColorFilter.mode(
                  context.color.primary,
                  BlendMode.srcIn,
                ),
              ),
              Gap(36.sp),
              const Text(
                "Password Changed\nSuccessfully!",
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

class PhoneChangedWidget extends StatelessWidget {
  const PhoneChangedWidget({super.key});

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
              Assets.icons.phone.svg(
                height: 50.r,
                colorFilter: ColorFilter.mode(
                  context.color.primary,
                  BlendMode.srcIn,
                ),
              ),
              Gap(36.sp),
              const Text(
                "Phone Number Changed\nSuccessfully!",
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
