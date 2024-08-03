import 'dart:developer';

import 'package:attendify_lite/app.dart';
import 'package:attendify_lite/app/features/employee/Notifications/presentation/bloc/notifications_emp_bloc.dart';
import 'package:attendify_lite/app/features/employee/base/presentation/bloc/base_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/bloc/camera_bloc/camera_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:attendify_lite/app/features/employee/leave/presentation/bloc/leave_bloc.dart';
import 'package:attendify_lite/app/features/employee/logs/presentation/bloc/logs_bloc.dart';
import 'package:attendify_lite/app/features/employer/home/presentation/bloc/adm_home_bloc.dart';
import 'package:attendify_lite/app/features/employer/leave/presentation/bloc/leave_emr_bloc.dart';
import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/bloc/report_whole_bloc.dart';
import 'package:attendify_lite/app/features/employer/singular/presentation/bloc/singular_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/report_bloc/report_bloc.dart';
import 'package:attendify_lite/core/bloc/location_bloc/location_bloc.dart';
import 'package:attendify_lite/core/bloc/theme_cubit/theme_cubit.dart';
import 'package:attendify_lite/core/bloc/time_cubit/time_cubit.dart';
import 'package:attendify_lite/core/bloc/user_cubit/user_cubit.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/services/notifications_service.dart/notification_service_handler.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:attendify_lite/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;

import 'app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'app/features/employer/notifications/presentation/blocs/noti_emr_bloc.dart';
import 'app/features/employer/settings/presentation/bloc/settings_bloc.dart';
import 'app/features/employer/team/presentation/bloc/team_bloc/team_bloc.dart';
import 'app/features/employer/team/presentation/bloc/work_time_bloc/work_time_bloc.dart';
import 'core/config/routes/app_router.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

getLacationPermission() async {
  final location = loc.Location.instance;

  final locServiceStatus = await location.serviceEnabled();
  final locPermisisonStatus = await location.hasPermission();
  if (!locServiceStatus) {
    final serviceStatus = await location.requestService();
    if (!serviceStatus) {
      showToast(msg: "Enable Location Service", toastLength: Toast.LENGTH_LONG);
      return;
    }
    final permStatus = await location.requestPermission();
    if (permStatus == loc.PermissionStatus.denied ||
        permStatus == loc.PermissionStatus.deniedForever) {
      showToast(
          msg: 'Location Permission Is Required, Enable It',
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    log("LOCATION SERVICE IS ENABLED");
    return;
  }
  if (locPermisisonStatus == loc.PermissionStatus.denied) {
    final permStatus = await location.requestPermission();
    if (permStatus == loc.PermissionStatus.denied ||
        permStatus == loc.PermissionStatus.deniedForever) {
      showToast(
          msg: 'Location Permission Is Required, Enable It',
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    log("LOCATION PERMISSION IS GRANTED");

    return;
  }
}

extension StringExtension on String {
  static String displayTimeAgoFromTimestamp(DateTime timestamp) {
    final year = timestamp.year;
    final month = timestamp.month;
    final day = timestamp.day;
    final hour = timestamp.hour;
    final minute = timestamp.minute;

    final DateTime videoDate = DateTime(year, month, day, hour, minute);
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (diffInHours < 1) {
      final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
      timeValue = diffInMinutes;
      timeUnit = 'min';
    } else if (diffInHours < 24) {
      timeValue = diffInHours;
      timeUnit = 'hr';
    } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
      timeValue = (diffInHours / 24).floor();
      timeUnit = 'day';
    } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
      timeValue = (diffInHours / (24 * 7)).floor();
      timeUnit = 'week';
    } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
      timeValue = (diffInHours / (24 * 30)).floor();
      timeUnit = 'month';
    } else {
      timeValue = (diffInHours / (24 * 365)).floor();
      timeUnit = 'year';
    }

    timeAgo = '$timeValue $timeUnit';
    timeAgo += timeValue > 1 ? 's' : '';

    return '$timeAgo ago';
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Geolocator.requestPermission();
  // await locationServiceEnable();
  await getLacationPermission();

  NotificationProvider.grantNotificationPermission();
  NotificationProvider.firebaseInit();
  NotificationProvider.initLocalNotification();

  NotificationProvider.foregroundMessage();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await di.init();
  // await initializeBackgroundService();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<UserCubit>()),
          BlocProvider(create: (_) => sl<AuthEmpBloc>()),
          BlocProvider(create: (_) => sl<AuthEmrBloc>()),
          BlocProvider(create: (_) => sl<ThemeCubit>()),
          BlocProvider(create: (_) => sl<LocationBloc>()),
          BlocProvider(create: (_) => sl<BaseEmpBloc>()),
          BlocProvider(create: (c) => HomeBloc(remoteRepo: sl())),
          BlocProvider(create: (_) => sl<LogsBloc>()),
          BlocProvider(create: (_) => sl<CameraBloc>()),
          BlocProvider(create: (_) => sl<TimeCubit>()..init()),
          BlocProvider(create: (_) => sl<LeaveBloc>()),
          BlocProvider(create: (_) => sl<AdmHomeBloc>()),
          BlocProvider(
              create: (c) => TeamBloc(
                    teamRepo: sl(),
                    user: c.read<AuthEmrBloc>().state.user!,
                  )),
          BlocProvider(create: (_) => sl<PickLocationBloc>()),
          BlocProvider(create: (_) => sl<NotificationsEmpBloc>()),
          BlocProvider(create: (_) => sl<ReportBloc>()),
          BlocProvider(create: (_) => sl<NotiEmrBloc>()),
          BlocProvider(create: (_) => sl<WorkTimeBloc>()),
          BlocProvider(create: (_) => sl<LeaveEmrBloc>()),
          BlocProvider(create: (_) => sl<ReportWholeBloc>()),
          BlocProvider(
            create: (c) => SingularBloc(
              singularRepo: sl(),
              homeRepo: sl(),
              locationBloc: c.read<LocationBloc>(),
            ),
          ),
          BlocProvider(
            create: (c) => SettingsEmrBloc(
              settingRepoEmr: sl(),
            ),
          ),
        ],
        child: BlocListener<UserCubit, UserState>(
          listener: (context, state) async {
            if (state is EmpLoggedIn) {
              context.read<AuthEmpBloc>().init();
            }
            if (state is EmrLoggedIn) {
              context.read<AuthEmrBloc>().init();
            }
            if (state is UserNotLoggedIn) {
              router.replaceAll([const UserSelectionRoute()]);
            }

            // if (state is! MockLocation) {
            //   log("hyestate::::--->::${state.toString()}");

            //   if (state is EmpLoggedIn) {
            //     context.read<AuthEmpBloc>().init();
            //   }
            //   if (state is EmrLoggedIn) {
            //     context.read<AuthEmrBloc>().init();
            //   }
            //   if (state is UserNotLoggedIn) {
            //     router.replaceAll([const UserSelectionRoute()]);
            //   }
            //   return;
            // } else {
            //   log("hyestateChk1::::--->::${state.toString()}");
            //   showToast(
            //       msg: "Mock location is not alllowed!",
            //       toastLength: Toast.LENGTH_LONG);
            //   return;
            // }
          },
          child: const AttendifyLite(),
        ),
      ),
    );
  }
}
