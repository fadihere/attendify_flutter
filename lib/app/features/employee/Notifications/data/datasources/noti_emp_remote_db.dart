import 'package:attendify_lite/app/features/employee/Notifications/data/models/noti_model.dart';
import 'package:dio/dio.dart';

abstract class NotiEmpRemoteDB {
  Future<List<NotiModel>?> fetchEmpNotificationsAPI({
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<bool> updateNotificationStatusAPI(
      {required int notificationID, required NotiModel notiModel});
}

class NotiEmpRemoteDBImpl extends NotiEmpRemoteDB {
  final Dio dio;
  NotiEmpRemoteDBImpl({required this.dio});

  @override
  Future<List<NotiModel>?> fetchEmpNotificationsAPI({
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final first = startDate.toString().replaceAll(" ", "T").substring(0, 19);
    final end = endDate.toString().replaceAll(" ", "T").substring(0, 19);

    final response = await dio.get(
      'notification/employee/$employeeID/$first/$end',
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data as List;

      return jsonData.map((json) => NotiModel.fromJson(json)).toList();
    }

    return null;
  }

  @override
  Future<bool> updateNotificationStatusAPI(
      {required int notificationID, required NotiModel notiModel}) async {
    final response =
        await dio.put('notification/$notificationID', data: notiModel.toJson());

    if (response.statusCode == 200) {
      return true;
    }
    throw 'Unknown Error Occured';
  }
}
