import 'package:attendify_lite/app/features/employee/auth/presentation/widgets/others.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/res/constants.dart';
import '../../../../core/utils/widgets/buttons.dart';

@RoutePage()
class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppSize.overallPadding,
        child: Column(
          children: [
            const Gap(20),
            const AppLogoWidget(),
            const Gap(50),
            const Center(
              child: Text(
                AppConstants.letStart,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap(5),
            Text(
              AppConstants.identity,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: context.color.hint,
              ),
            ),
            AppButtonWidget(
              onTap: () {
                router.push(const SigninEmrRoute());
              },
              borderRadius: 30,
              textColor: context.color.primary,
              text: AppConstants.employer.toUpperCase(),
              margin: EdgeInsets.only(top: 25.sp),
              color: context.color.primary.withOpacity(0.2),
              // outline: context.color.primary,
            ),
            AppButtonWidget(
              onTap: () {
                router.push(const SigninEmpRoute());
              },
              borderRadius: 30,
              text: AppConstants.employee.toUpperCase(),
              margin: EdgeInsets.only(top: 15.sp),
            )
          ],
        ),
      ),
    );
  }
}
