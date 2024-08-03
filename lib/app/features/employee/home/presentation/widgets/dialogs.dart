import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../injection_container.dart';
import '../bloc/home_bloc/home_bloc.dart';
import 'face_scanner_widget.dart';

Future<String?> getImageFromDialog(BuildContext context) async {
  return await showAdaptiveDialog<String?>(
    context: context,
    barrierDismissible: true,
    useSafeArea: true,
    builder: (_) => Dialog(
      backgroundColor: context.color.dialogBackgroundColor,
      insetPadding: AppSize.sidePadding,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: BlocProvider(
        create: (_) => sl<HomeBloc>()..add(InitLivelynessDetectionEvent()),
        child: const FaceScannerWidget(),
      ),
    ),
  );
}

Future<String?> clockSuccessDialog(
  BuildContext context,
  DateTime time,
  String location, {
  bool isClockin = true,
}) async {
  await showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (context) => Dialog(
        backgroundColor: context.color.dialogBackgroundColor,
        insetPadding: AppSize.sidePadding,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          width: 327.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(50),
              Assets.icons.clockSucess.svg(
                width: 66.r,
                colorFilter: ColorFilter.mode(
                  context.color.primary,
                  BlendMode.srcIn,
                ),
              ),
              const Gap(25),
              Text(
                DateFormat.jm().format(time),
                style: TextStyle(
                  fontSize: 30,
                  color: context.color.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(11),
              Text(
                isClockin ? "Clock In Successful" : "Clock Out Successful",
                style: TextStyle(
                  color: context.color.font,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(11),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.locationFill.svg(
                    width: 15,
                    height: 15,
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      const Text(
                        'Location:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      const Gap(5),
                      Text(location)
                    ],
                  ),
                ],
              ),
              const Gap(50),
            ],
          ),
        )),
  );
  return null;
}

class ClockOutWidget extends StatelessWidget {
  final VoidCallback onClockOut;

  const ClockOutWidget({
    super.key,
    required this.onClockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(24),
          const Text(
            "Clock Out",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(9),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Are you sure you want to clock out?",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(25),
          AppButtonWidget(
            margin: AppSize.sidePadding,
            onTap: () => router.maybePop(),
            text: "CANCEL",
            textColor: context.color.primary,
            color: context.color.primary.withOpacity(0.3),
          ),
          const Gap(10),
          AppButtonWidget(
            margin: AppSize.sidePadding,
            onTap: onClockOut,
            text: "YES, CLOCK OUT",
            color: context.color.warning,
          ),
          const Gap(36),
        ],
      ),
    );
  }
}

class WFHDialog extends StatelessWidget {
  final VoidCallback onTap;
  const WFHDialog({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSize.sidePadding,
      child: SizedBox(
        width: 327.r,
        height: 347.sp,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(30),
            Text(
              "You don't seem to be at your workplace",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: context.color.font,
              ),
            ),
            const Gap(25),
            Container(
              height: 170.r,
              width: 197.r,
              decoration: BoxDecoration(
                color: context.color.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.color.primary.withOpacity(0.3),
                  width: 8,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: GestureDetector(
                onTap: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.workFromHome.svg(
                      width: 70.sp,
                      colorFilter: ColorFilter.mode(
                        context.color.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(13),
                    Text(
                      "Request Work From Home",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.color.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
