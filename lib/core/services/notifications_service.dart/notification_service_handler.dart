import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:attendify_lite/app.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:attendify_lite/app/features/employer/home/presentation/bloc/adm_home_bloc.dart';
import 'package:attendify_lite/core/services/location_bg_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  static FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
  static String fcmToken = '';
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static grantNotificationPermission() async {
    NotificationSettings settings = await fcmMessage.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User Granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User Granted Provisional Permission');
    } else {
      log('User Denied Permission');
    }
    /*  await fcmMessage.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
 */
    // else if (settings.authorizationStatus !=
    //     AuthorizationStatus.provisional) {
    //   AppSettings.openAppSettings(type: AppSettingsType.notification);
    // }
/* 
      await fcmMessage.setAutoInitEnabled(true);
    }
    debugPrint('User granted permission: ${settings.authorizationStatus}'); */
  }

  static firebaseInit() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      log("NOTIFICATION INTERVAL ====> ${message.data['notificationType']}");
      if (message.notification?.title == "Clocked Out") {
        flutterBackgroundService.invoke('stopService');
      }
      log(message.data.toString());
      if (message.data["notificationType"] == 'employee') {
        routerKey.currentState?.context
            .read<HomeBloc>()
            .add(const ShowNotificationEvent(status: true));
      } else {
        routerKey.currentState?.context
            .read<AdmHomeBloc>()
            .add(const AdmShowNotificationEvent(status: true));
      }

      if (Platform.isIOS) {
        foregroundMessage();
      }
      if (Platform.isAndroid) {
        showNotification(message);
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log("Handling a background message: ${message.notification?.title}");
    showNotification(message);
  }

  static Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  static initLocalNotification() async {
    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) => {},
    );
  }

  static Future<void> showNotification(RemoteMessage message) async {
    final notificationChannel = AndroidNotificationChannel(
        math.Random.secure().nextInt(1000).toString(),
        'High Importance Notification',
        importance: Importance.high,
        description: "Channel Description");
    final androidNotificationDetail = AndroidNotificationDetails(
        notificationChannel.id, notificationChannel.name,
        importance: notificationChannel.importance,
        channelDescription: notificationChannel.description,
        priority: Priority.high,
        ticker: 'ticker');

    const iosNotificationDetail = DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    final notifictionDetails = NotificationDetails(
        iOS: iosNotificationDetail, android: androidNotificationDetail);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notifictionDetails,
      );
    });
  }
}

class FireBaseMessageType {
  static const String empNotification = "receiveRequest";
  static const String emrNotification = "acceptRequest";
}
