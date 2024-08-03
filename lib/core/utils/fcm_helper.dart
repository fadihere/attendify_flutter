import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FCMHelper {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();
  //
  //   print("Handling a background message: ${message.messageId}");
  // }
  //
  // Future<void> main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  //   FlutterAppBadger.removeBadge();
  //
  //   runApp(MyApp());
  // }

  static Future<String?> generateFCMToken() async {
    try {
      String? token = await messaging.getToken();

      return token;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  static Future<String?> sendNotification(
      String token, String title, String body, String notiType) async {
    try {
      // Ensure that messaging is initialized
      // if (messaging == null) {
      //   print("FirebaseMessaging is not initialized");
      //   return null;
      // }
      //
      // // Ensure that the token is not null
      // if (token == null) {
      //   print("Token is null");
      //   return null;
      // }
      //
      // await FirebaseMessaging.instance.sendMessage(to: token, data: {
      //   "title": title,
      //   "body": body,
      // });

      Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAN9KL-C0:APA91bEC10oBDA-xjtJayk12DyG6-xeJZ4swyLc-yduyOQduvkE0eowqZEtr0keX6gkZXqpbALj5X7IJbc44U6cKLV5oDrP8eoqxzpMV2QS1wpKaRNpnGqVsS190arcHriU6ridAXtjM",
      };

      Map<String, dynamic> notification = {
        "to": token,
        "priority": "high",
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "notificationType": notiType,
        }
      };

      final res = await http.post(url,
          headers: headers, body: jsonEncode(notification));
      log(res.body.toString());
      // print(token.toString());
      return token;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  static Future<void> sendNotificationToAllEmployee(
      String title, String body, String notiType) async {
    try {
      // Ensure that messaging is initialized
      // if (messaging == null) {
      //   print("FirebaseMessaging is not initialized");
      //   return null;
      // }
      //
      // // Ensure that the token is not null
      // if (token == null) {
      //   print("Token is null");
      //   return null;
      // }
      //
      // await FirebaseMessaging.instance.sendMessage(to: token, data: {
      //   "title": title,
      //   "body": body,
      // });

      Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAN9KL-C0:APA91bEC10oBDA-xjtJayk12DyG6-xeJZ4swyLc-yduyOQduvkE0eowqZEtr0keX6gkZXqpbALj5X7IJbc44U6cKLV5oDrP8eoqxzpMV2QS1wpKaRNpnGqVsS190arcHriU6ridAXtjM",
      };

      Map<String, dynamic> notification = {
        "to": '',
        "priority": "high",
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "notificationType": notiType,
        }
      };

      final res = await http.post(url,
          headers: headers, body: jsonEncode(notification));
      log(res.body.toString());
      // print(token.toString());
      return;
    } catch (e) {
      log("ERROR NOTIFCATION ${e.toString()}");
      return;
    }
  }

  static initializeFcmSetup(
    context,
  ) async {
    // FlutterAppBadger.removeBadge();

    await _getPermissions();

    messaging.getInitialMessage().then((RemoteMessage? message) {
      // print(message);
      if (message != null) {
        // _handleNotification(message, context, callBack,contactId,userId);
      }
    });

    // when app is open
    _foregroundMessages(context, () {}, "contactId", "userId");
    _openFromBackgroundMessages(context, () {}, "contactId", "userId");
  }

  static Future<void> _getPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');
  }

  static _foregroundMessages(
      context, Function callBack, String contactId, String userId) {
    //when app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message, context, callBack, contactId, userId);
    });
  }

  static _openFromBackgroundMessages(
      context, Function callBack, String contactId, String userId) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message, context, callBack, contactId, userId);
    });
  }

  static _handleNotification(RemoteMessage message, context, Function callBack,
      String contactId, String userId) {
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //   builder: (context) => const AdminSideRoute(),
    // ),(Route<dynamic> route) => false);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const AdminNotificationView())
    // );

    // String? imgUrl = message.notification!.android == null
    //     ? message.notification!.apple == null
    //     ? null
    //     : message.notification!.apple!.imageUrl
    //     : message.notification!.android!.imageUrl;
    //
    // CustomDialogues.notificationDialog(message.notification!.body ?? "",
    //     message.notification!.title ?? "", context,
    //     imageUrl: imgUrl, callBack,contactId,userId);
  }
}
