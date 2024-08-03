// ignore_for_file: unused_local_variable, empty_catches
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/features/employee/auth/data/models/user_emp_model.dart';
import '../../app/features/employee/home/data/datasources/home_remote_emp_db.dart';
import '../../app/shared/datasource/noti_remote_db.dart';
import '../constants/app_constants.dart';
import '../utils/fcm_helper.dart';
import '../utils/functions/functions.dart';

final flutterBackgroundService = FlutterBackgroundService();
/* UserEmpModel? _user;
double homeLat = 0.0;
double homeLong = 0.0; */

Future<void> initializeBackgroundService() async {
  /// OPTIONAL, using custom notification channel id
  /* _user = user;
  homeLat = lat;
  homeLong = long; */
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterBackgroundService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Attendify',
      initialNotificationContent: 'Fetching...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,

      /// background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  UserEmpModel? user;
  double homeLat = 0.0;
  double homeLong = 0.0;

  /// OPTIONAL when use custom notification
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    // flutterLocalNotificationsPlugin.cancelAll();

    service.stopSelf();
  });
  service.on('data').listen((event) async {
    // flutterLocalNotificationsPlugin.cancelAll();

    // log(event?['userModel']);
    if (event != null) {
      user = UserEmpModel.fromJson(event['userModel']);
      homeLat = event['homeLat'];
      homeLong = event['homeLong'];
      log(user!.toJson().toString());
      if (user != null) {
        final homeRepo = HomeRemoteDBEmpImpl(
            dio: Dio(BaseOptions(baseUrl: AppConst.baseurl)));
        final lastTransaction = await homeRepo.empLastInAPI(
          employeeID: user!.employeeId,
          employerID: user!.employerId,
        );

        log(lastTransaction.toString());
        if (lastTransaction.attendanceStatus == 'WFH' &&
            lastTransaction.recordedTimeOut == null) {
          Timer.periodic(const Duration(minutes: 2), (timer) async {
            if (service is AndroidServiceInstance) {
              if (await service.isForegroundService()) {
                /// OPTIONAL for use custom notification
                /// the notification id must be equals with AndroidConfiguration when you call configure() method.

                // if you don't using custom notification, uncomment this
                // service.setForegroundNotificationInfo(
                //   title: "D-iD Connect",
                //   content: "Sync....",
                // );
              }
            }

            final position = await Geolocator.getCurrentPosition();
            log("CHECKING LOCATION IS MOCK  ${position.isMocked.toString()}");

            if (position.isMocked) {
              return;
            }

            final currentLat = position.latitude;
            final currentLong = position.longitude;

            // final assignedLat = double.parse(assignedLoc.latitude!);
            // final assignedLong = double.parse(assignedLoc.longitude!);

            final distance =
                calculateDistance(currentLat, currentLong, homeLat, homeLong);
            //  if()

            if ((distance * 1000) > 2) {
              NotiRemoteDB.sendNotificationAPI(
                title: "${user!.employeeName} Not In Radius",
                subTitle:
                    "${user!.employeeName} is currently not present at the designated clocked-in radius",
                employeeID: user?.employeeId,
                employerID: user?.employerId,
                attendanceID: lastTransaction.attendanceTransactionId,
                currentLat: currentLat,
                currentLong: currentLong,
                notificationType: "Not At Location",
              );
              FCMHelper.sendNotification(
                  user!.employerToken,
                  "${user!.employeeName} Not In Radius",
                  '${user!.employeeName} is currently not present at the designated clocked-in radius',
                  'employer');
            }

            /// you can see this log in logcat
            if (kDebugMode) {
              print('FLUTTER BACKGROUND SERVICE WORKING 1: ${DateTime.now()}');
            }

            //

            final deviceInfo = DeviceInfoPlugin();
            String? device;
            if (Platform.isAndroid) {
              final androidInfo = await deviceInfo.androidInfo;
              device = androidInfo.model;
            }

            if (Platform.isIOS) {
              final iosInfo = await deviceInfo.iosInfo;
              device = iosInfo.model;
            }
//
            service.invoke(
              'update',
              {
                "current_date": DateTime.now().toIso8601String(),
                "device": device,
              },
            );
          });
        }
      }
    }
  });

  // bring to foreground

  /*  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.

        // if you don't using custom notification, uncomment this
        // service.setForegroundNotificationInfo(
        //   title: "D-iD Connect",
        //   content: "Sync....",
        // );
      }
    }

    /// you can see this log in logcat
    if (kDebugMode) {
      print('FLUTTER BACKGROUND SERVICE WORKING: ${DateTime.now()}');
    }
    //

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke('stop');
  });
 */
}
