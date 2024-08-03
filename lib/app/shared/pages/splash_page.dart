import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/res/export.dart';
import '../../../core/utils/fcm_helper.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    FCMHelper.initializeFcmSetup(
      context,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primary,
      body: Center(
        child: Assets.icons.logo.svg(
          width: 195.sp,
          colorFilter: const ColorFilter.mode(
            LightColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
