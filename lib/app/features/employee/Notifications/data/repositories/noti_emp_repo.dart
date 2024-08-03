import 'dart:io';

import 'package:attendify_lite/app/features/employee/Notifications/data/datasources/noti_emp_remote_db.dart';
import 'package:attendify_lite/app/features/employee/Notifications/data/models/noti_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';

abstract class NotficationEmpRepo {
  Future<Either<Failure, List<NotiModel>?>> fetchEmpNotifications({
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<Either<Failure, bool>> updateNotificationStatus(
      {required int notificationID, required NotiModel notiModel});
}

class NotficationEmpRepoImpl extends NotficationEmpRepo {
  NotiEmpRemoteDBImpl notificationDB;
  NetworkInfoImpl networkInfo;
  NotficationEmpRepoImpl({
    required this.notificationDB,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NotiModel>?>> fetchEmpNotifications({
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await notificationDB.fetchEmpNotificationsAPI(
        employeeID: employeeID,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNotificationStatus(
      {required int notificationID, required NotiModel notiModel}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await notificationDB.updateNotificationStatusAPI(
        notificationID: notificationID,
        notiModel: notiModel,
      );
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }
}
