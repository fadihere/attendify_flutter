import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/singular/presentation/bloc/singular_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ntp/ntp.dart';

import '../../../../../../core/bloc/location_bloc/location_bloc.dart';
import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../../../../employee/home/presentation/widgets/clock_widget.dart';
import '../../../../employee/home/presentation/widgets/dialogs.dart';

@RoutePage()
class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  void initState() {
    context.read<LocationBloc>().add(ReqLocationServiceEvent());
    context.read<LocationBloc>().add(ReqEmrLocPermissionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => router.push(SetupPin3Route(title: "Enter PIN")),
              icon: const Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: context.color.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClockWidget(
              color: context.color.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<SingularBloc>().add(OpenFaceDialogEvent());
            },
            child: Center(
              child: Container(
                width: 170.spMax,
                height: 170.spMax,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.color.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.color.white.withOpacity(0.2),
                    width: 8,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: BlocListener<SingularBloc, SingularState>(
                  listener: (context, state) async {
                    final singular = context.read<SingularBloc>();
                    final auth = context.read<AuthEmrBloc>();
                    if (state is FaceDialogState) {
                      final path = await getImageFromDialog(context);
                      if (path == null) return;
                      if (!context.mounted) return;
                      singular.add(CheckUserAndClock(
                        emrId: auth.state.user!.employerId,
                        file: File(path),
                      ));
                    }
                    if (state is ClockedInDialogState) {
                      _clockSuccessDialog(context);
                    }
                    if (state is ClockedOutDialogState) {
                      _clockSuccessDialog(context, false);
                    }
                    if (state.status == Status.loading) {
                      BotToast.showLoading();
                      return;
                    }
                    BotToast.closeAllLoading();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Check In',
                        style: TextStyle(
                            color: context.color.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 80.r,
                        child: Divider(
                          color: context.color.primary,
                        ),
                      ),
                      Text(
                        'Check Out',
                        style: TextStyle(
                            color: context.color.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Assets.icons.logoDark.svg(
                colorFilter:
                    ColorFilter.mode(context.color.white, BlendMode.srcIn)),
          ),
          const Offstage(),
        ],
      ),
    );
  }

  void _clockSuccessDialog(
    BuildContext context, [
    bool isClockIn = true,
    String locationName = "",
  ]) async {
    final time = await NTP.now();
    if (!context.mounted) return;
    clockSuccessDialog(
      context,
      time,
      locationName,
      isClockin: isClockIn,
    );
    await Future.delayed(const Duration(seconds: 1));
    router.maybePop();
  }
}
