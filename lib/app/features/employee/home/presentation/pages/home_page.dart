// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/widgets/clock_widget.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/widgets/timer_widget.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/enums/status.dart';
import '../../../logs/presentation/bloc/logs_bloc.dart';
import '../widgets/clock_in_widget.dart';
import '../widgets/dialogs.dart';
import '../widgets/location_widget.dart';

@RoutePage()
class HomeEmpPage extends StatefulWidget {
  const HomeEmpPage({super.key});

  @override
  State<HomeEmpPage> createState() => _HomeEmpPageState();
}

class _HomeEmpPageState extends State<HomeEmpPage> with WidgetsBindingObserver {
  Location location = Location();
  int count = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state111) {
    final authBloc = context.read<AuthEmpBloc>();
    final homeBloc = context.read<HomeBloc>();

    switch (state111) {
      case AppLifecycleState.resumed:
        // if (!homeBloc.state.isLocPermissionEnabled || homeBloc.state.isMock) {
        if (count == 1) {
          homeBloc
              /*  ..add(CheckInternetEvent()) */
              .add(LocationPermissionEvent(
            locationId: authBloc.state.user!.locationId,
          ));
        }
        count = 0;
        setState(() {});

        // }

        return;

      case AppLifecycleState.inactive:
        /*  count = 1;
        setState(() {}); */
        break;
      case AppLifecycleState.paused:
        /*   count = 1;
        setState(() {}); */
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        count = 1;
        setState(() {});
        break;
      default:
        null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    final authBloc = context.read<AuthEmpBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: BlocBuilder<AuthEmpBloc, AuthEmpState>(
          builder: (context, state) {
            if (state.user != null) {
              return Text(
                state.user!.employeeName,
                style: const TextStyle(
                    fontFamily: FontFamily.hellix, fontWeight: FontWeight.w600),
              );
            }
            return const Offstage();
          },
        ),
        actions: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    homeBloc.add(const ShowNotificationEvent(status: false));
                    router.push(const NotificationsEmpRoute());
                  },
                  icon: Stack(
                    children: [
                      Assets.icons.notification.svg(
                          colorFilter: ColorFilter.mode(
                        context.color.icon,
                        BlendMode.srcIn,
                      )),
                      state.showNotification
                          ? Positioned(
                              right: 2,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: context.color.red,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ));
            },
          )
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          final authBloc = context.read<AuthEmpBloc>();
          // final locationBloc = context.read<LocationBloc>();
          final homeBloc = context.read<HomeBloc>();
          final logsBloc = context.read<LogsBloc>();

          // final locState = locationBloc.state;
          if (state is ClockedInDialogState) {
            _clockSuccessDialog(context);
          }
          if (state is ClockedOutDialogState) {
            _clockSuccessDialog(context, false);
          }
          if (state is WFHDialogState) {
            _wfhDialog(context);
          }
          if (state is FaceDialogState) {
            // log("::requestApproved::${state.lastInModel?.requestApproved}");
            // LocationData res = await location.getLocation();

            final path = await getImageFromDialog(context);
            if (!context.mounted) return;
            router.maybePop();
            if (path == null) {
              return;
            }

            log('LAST IN MODEL ${homeBloc.state.lastInModel}');
            log('RECORD IN TIME ${homeBloc.state.lastInModel?.recordedTimeIn}');
            log('RECODR OUT TIME ${homeBloc.state.lastInModel?.recordedTimeOut}');

            final isClockedIn = homeBloc.state.lastInModel != null &&
                homeBloc.state.lastInModel?.recordedTimeIn != null &&
                homeBloc.state.lastInModel?.recordedTimeOut == null;

            homeBloc.add(ClockedEvent(
              lastIn: homeBloc.state.lastInModel!,
              isClockedIn: isClockedIn,
              file: File(path),
              user: authBloc.state.user!,
              lat: homeBloc.state.currentLat,
              lon: homeBloc.state.currentLong,
              isAtOffice: homeBloc.state.isAtOffice,
              isApproved: state.lastInModel?.requestApproved == true,
            ));
          }
          logsBloc.add(FetchLogsEvent(user: authBloc.state.user!));
          if (state.status == Status.loading) {
            BotToast.showLoading();
            return;
          }
          BotToast.closeAllLoading();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            final authBloc = context.read<AuthEmpBloc>();

            context
                .read<HomeBloc>()
                /* ..add(LocationPermissionEvent(
                  locationId: authBloc.state.user!.locationId)) */
                .add(FetchLastTransactionEvent(user: authBloc.state.user!));
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    // final locationBloc = context.read<LocationBloc>();
                    final homeBloc = context.read<HomeBloc>();
                    final isClockedIn = homeBloc.state.lastInModel != null &&
                        homeBloc.state.lastInModel?.recordedTimeIn != null &&
                        homeBloc.state.lastInModel?.recordedTimeOut == null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const ClockWidget(),
                        state.isConnected
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CheckInWidget(
                                    onTap: () async {
                                      final isConnected =
                                          await checkInternetConnectivity();
                                      if (!isConnected) {
                                        showToast(
                                            msg:
                                                'Check Your Internet Connection');
                                        return;
                                      }
                                      if (state.isMock) {
                                        return;
                                      }

                                      if (state.isFetchingLocation ==
                                          Status.loading) {
                                        return;
                                      }
                                      if (isClockedIn) {
                                        _clockedOutDialog(context);
                                        return;
                                      }

                                      homeBloc.add(CheckUserOfficeorHomeEvent(
                                        isAtOffice: state.isAtOffice,
                                        isApproved:
                                            state.lastInModel?.requestApproved,
                                      ));
                                    },
                                    isClockedIn: isClockedIn,
                                  ),
                                  const Gap(20),
                                  CurrentLocationWidget(
                                    homeBloc: homeBloc,
                                    authBloc: authBloc,
                                    /* name: state.locMessage.isEmpty
                                      ? state.locMessage
                                      : state.currentLocName,
                                  onTurn: () async {
                                    homeBloc.add(FetchLocationByIDEvent(
                                      id: authBloc.state.user!.locationId,
                                    ));
                                    await Future.delayed(
                                        const Duration(seconds: 3));
                                    state.copyWith(status: Status.success);
                                  }, */
                                  ),
                                  /*   BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                /*  if (!state.) {
                                  return const Text(
                                      'Please turn on location service');
                                }

                                if (!state.isPermissionEnabled) {
                                  return const Text(
                                      'Please allow location permission');
                                }

                                final locationBloc = context.read<LocationBloc>();
                                 */

                                return CurrentLocationWidget(
                                  /* name: state.locMessage.isEmpty
                                      ? state.locMessage
                                      : state.currentLocName,
                                  onTurn: () async {
                                    homeBloc.add(FetchLocationByIDEvent(
                                      id: authBloc.state.user!.locationId,
                                    ));
                                    await Future.delayed(
                                        const Duration(seconds: 3));
                                    state.copyWith(status: Status.success);
                                  }, */
                                );
                              },
                            ),
                          */
                                ],
                              )
                            : Assets.icons.noInterner.svg(
                                width: 170.r,
                                height: 160.r,
                              ),
                        BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            // print(
                            //     "Request: ${state.lastInModel?.requestApproved?.toString() ?? 'null'}");
                            return Column(
                              children: [
                                Visibility(
                                  visible: state.lastInModel != null &&
                                      state.lastInModel?.recordedTimeOut ==
                                          null &&
                                      state.lastInModel?.attendanceStatus ==
                                          "WFH",
                                  replacement: const SizedBox(),
                                  child: ApprovelWidget(
                                    isApproved:
                                        state.lastInModel?.requestApproved,
                                  ),
                                ),
                                const Gap(25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TimerWidget(
                                      icon: Assets.icons.clockIn,
                                      title: 'Clock In',
                                      dateTime: state.checkIn,
                                    ),
                                    TimerWidget(
                                      icon: Assets.icons.clockOut,
                                      title: 'Clock out',
                                      dateTime: state.checkOut,
                                    ),
                                    TimerWidget(
                                      icon: Assets.icons.clockIn,
                                      title: 'Total Hrs',
                                      dateTime: state.totalHours,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _clockSuccessDialog(
    BuildContext context, [
    bool isClockIn = true,
  ]) async {
    // final locationBloc = context.read<LocationBloc>();
    final homeBloc = context.read<HomeBloc>();
    final authBloc = context.read<AuthEmpBloc>();
    final time = await NTP.now();
    if (!context.mounted) return;
    clockSuccessDialog(
      context,
      time,
      homeBloc.state.currentLocName,
      isClockin: isClockIn,
    );
    homeBloc.add(FetchLastTransactionEvent(user: authBloc.state.user!));
    await Future.delayed(const Duration(seconds: 2));
    router.maybePop();
  }

  void _clockedOutDialog(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ClockOutWidget(
        onClockOut: () {
          router.maybePop();
          homeBloc.add(const OpenFaceDialogEvent());
        },
      ),
    );
  }

  void _wfhDialog(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    showAdaptiveDialog(
      context: context,
      builder: (context) => WFHDialog(
        onTap: () {
          router.maybePop();
          homeBloc.add(const OpenFaceDialogEvent());
        },
      ),
    );
  }
}

class ApprovelWidget extends StatelessWidget {
  final bool? isApproved;
  const ApprovelWidget({
    super.key,
    this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    log("-----reqqqqq-->$isApproved");
    Color color = isApproved != null
        ? isApproved!
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.3)
        : context.color.primary.withOpacity(0.2);

    final text = isApproved != null
        ? isApproved!
            ? "Approved"
            : "Rejected"
        : "Approval Pending";

    return Container(
      height: 25,
      width: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: color.withOpacity(1)),
      )),
    );
  }
}
