import 'dart:io';
import 'dart:math';

import 'package:attendify_lite/app/features/employee/auth/data/models/country_code_model.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:attendify_lite/injection_container.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../constants/app_colors.dart';

String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(
        rnd.nextInt(chars.length),
      ),
    ),
  );
}

List<String> sortWeekDays(List<String> list) {
  const weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final positions = weekDays.asMap().map((ind, day) => MapEntry(day, ind));

  list.sort((first, second) {
    final firstPos = positions[first] ?? 8;
    final secondPos = positions[second] ?? 8;
    return firstPos.compareTo(secondPos);
  });
  return list;
}

String getTotalHours({DateTime? inTime, DateTime? outTime}) {
  if (outTime == null && inTime == null) {
    return "00:00";
  }
  final currentTime =
      DateTime.parse(DateTime.now().toString().substring(0, 19));
  final inTimeRef = DateTime.parse(inTime.toString().substring(0, 19));
  if (outTime != null && inTime != null) {
    final hrDiff = outTime.differenceInHours(inTime);
    final minDiff = outTime.differenceInMinutes(inTime).remainder(60);
    return '${hrDiff.toString().padLeft(2, '0')} : ${minDiff.toString().padLeft(2, '0')}';
  }

  final hrDiff = currentTime.differenceInHours(inTimeRef);
  final minDiff = currentTime.differenceInMinutes(inTimeRef).remainder(60);

  return '${hrDiff.toString().padLeft(2, '0')} : ${minDiff.toString().padLeft(2, '0')}';
}

Future<void> locationServiceEnable() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}

int getRandomInt() {
  var rnd = Random();
  var next = rnd.nextDouble() * 1000000;
  while (next < 100000) {
    next *= 10;
  }
  return next.toInt();
}

DateTime convertStringToDateTime(String timeString) {
  // Split the string to get hours and minutes
  if (timeString.isNotEmpty) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Get current date
    DateTime now = DateTime.now();

    // Create a DateTime object with today's date and the provided time
    return DateTime(now.year, now.month, now.day, hours, minutes);
  }
  return DateTime.now();
}

String to12Hrs(String? time24hr) {
  if (time24hr == null) {
    return "--:--";
  }
  List<String> parts = time24hr.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  String period = hours < 12 ? 'AM' : 'PM';

  // Convert hours to 12-hour format
  if (hours == 0) {
    hours = 12;
  } else if (hours > 12) {
    hours -= 12;
  }

  // Format the time in 12-hour format

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}" ==
          "00:00"
      ? "--"
      : '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
}

String getTotalHoursReport(String? value) {
  if (value == null) {
    return '00hrs : 00mins';
  }
  double totalSecondsDouble = double.parse(value);

  // Convert double to an integer (truncate the decimal part)
  int totalSeconds = totalSecondsDouble.toInt();

  // Calculate hours
  int hours = totalSeconds ~/ 3600;

  // Calculate minutes
  int minutes = (totalSeconds % 3600) ~/ 60;

  // Format the result as a string in HH:MM format
  String formattedTime =
      '${hours.toString().padLeft(2, '0')}hrs : ${minutes.toString().padLeft(2, '0')}mins';

  return formattedTime;
}

String to12HrsEmpty(String? time24hr) {
  if (time24hr == null) {
    return "--:--";
  }
  List<String> parts = time24hr.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  String period = hours < 12 ? 'AM' : 'PM';

  // Convert hours to 12-hour format
  if (hours == 0) {
    hours = 00;
  } else if (hours > 12) {
    hours -= 12;
  }

  // Format the time in 12-hour format

  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}" ==
          "00:00"
      ? "00:00"
      : '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
}

Future<String> getCountryCode() async {
  try {
    final dio = sl<Dio>();
    final res = await dio.post('http://ip-api.com/json');
    final countryCode = CountryCodeModel.fromMap(res.data);
    return "+${CountryParser.parseCountryCode(countryCode.countryCode).phoneCode}";
  } catch (_) {
    return '+92';
  }
}

showToast({required String? msg, Toast? toastLength}) {
  if (msg == null || msg.isEmpty) return;
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength ?? Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

String getDayName(int day) {
  switch (day) {
    case 1:
      return "MON";
    case 2:
      return "TUE";
    case 3:
      return "WED";
    case 4:
      return "THU";
    case 5:
      return "FRI";
    case 6:
      return "SAT";
    case 7:
      return "SUN";
    default:
      return "";
  }
}

getTextColorByStatus(
  String status,
) {
  switch (status) {
    case "PRS":
      return LightColors.primary;
    case "ABS":
      return const Color(0xffEA4335);
    case "LTL":
      return Colors.amber;
    case "WFH":
      return const Color.fromARGB(255, 105, 121, 151);
    case "HOL":
      return Colors.grey;
    case "LEV":
      return const Color(0xff34A853);
    default:
      return Colors.transparent;
  }
}

Future<bool> checkInternetConnectivity() async {
  final List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  }
  try {
    final List<InternetAddress> result =
        await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}

String? findWorkingHours({
  required DateTime? timeIn,
  required DateTime? timeOut,
}) {
  try {
    Duration duration;
    timeOut != null
        ? duration = timeOut.difference(timeIn!)
        : duration = DateTime.now().difference(timeIn!);

    return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  } catch (e) {
    // print(e);
    return null;
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "";
  }
}

String? mapAttendanceStatus(String? status) {
  switch (status) {
    case 'ABS':
      return 'Absent';
    case 'PRS':
      return 'Present';
    case 'LTL':
      return 'Late';
    case 'WFH':
      return 'Work From Home';
    case 'SKL':
      return 'Sick Leave';
    default:
      return 'Unknown';
  }
}

moveToNextOrprevFocus({
  required BuildContext context,
  required FocusNode currentFocus,
  FocusNode? nextOrPrevFocus,
}) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(
    nextOrPrevFocus,
  );
}

Future<bool> sendTwilioOTPSMS({
  required String phoneNumber,
  required int otp,
}) async {
  final twilio = TwilioFlutter(
    accountSid: AppConst.accountSid,
    authToken: AppConst.authToken,
    twilioNumber: AppConst.twilioNumber,
  );
  debugPrint("otp $otp");
  try {
    int res = await twilio.sendSMS(
        toNumber: phoneNumber,
        messageBody:
            '''Greetings from swatitech. Your Attendify verification code is:

$otp

Your account can be accessed using this code, please do not share.
\n
Download from Playstore: 
https://play.google.com/store/apps/details?id=com.swatiTech.attendify
\n
Download from Appstore: 
https://apps.apple.com/ua/app/attendify-lite/id6449732891
Website Link:
https://swatitech.com/
''');
    if (res == 201) {
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

String timeAgo(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inDays > 365) {
    int years = (difference.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '$years years ago';
  } else if (difference.inDays >= 30) {
    int months = (difference.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '$months months ago';
  } else if (difference.inDays >= 1) {
    return difference.inDays == 1
        ? '1 day ago'
        : '${difference.inDays} days ago';
  } else if (difference.inHours >= 1) {
    return difference.inHours == 1
        ? '1 hour ago'
        : '${difference.inHours} hours ago';
  } else if (difference.inMinutes >= 1) {
    return difference.inMinutes == 1
        ? '1 minute ago'
        : '${difference.inMinutes} minutes ago';
  } else {
    return 'just now';
  }
}
