import 'dart:io';

import 'package:attendify_lite/app/features/employee/Notifications/data/models/noti_model.dart';
import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../../employee/home/data/models/check_out_model.dart';
import '../datasources/noti_remote_db.dart';
import '../models/attendance_res.dart';

abstract class NotiRepo {
  Future<List<NotiModel>> fetchEmrNotifications({
    required String employerID,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, AttendanceRes>> fetchAttendanceDetailByID(
      {required int attendanceID});
  Future<Either<Failure, UserEmpModel>> fetchEmployeeDataByID(
      {required String employeeID});
  Future<Either<Failure, bool>> updateNotificationStatus(
      {required int notificationID, required NotiModel notiModel});
  Future<Either<Failure, bool>> clockOutEmployee(
      {required CheckOutModel attendanceRes, required int attendanceID});
}

class NotiRepoImpl extends NotiRepo {
  NotiRemoteEmrDBImpl db;
  NetworkInfoImpl networkInfo;
  NotiRepoImpl({
    required this.db,
    required this.networkInfo,
  });

  @override
  Future<List<NotiModel>> fetchEmrNotifications(
      {required String employerID,
      required DateTime startDate,
      required DateTime endDate}) async {
    try {
      if (await networkInfo.isNotConnected) return [];
      final res = await db.fetchEmrNotificationsAPI(
        employerID: employerID,
        startDate: startDate,
        endDate: endDate,
      );
      return res;
    } on SocketException catch (_) {
      return [];
    } on DioException catch (_) {
      return [];
    } on ServerException catch (_) {
      return [];
    }
  }

  @override
  Future<Either<Failure, AttendanceRes>> fetchAttendanceDetailByID(
      {required int attendanceID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await db.fetchAttendanceDetailByID(
        attendanceID: attendanceID,
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
      final res = await db.updateNotificationStatusAPI(
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

  @override
  Future<Either<Failure, bool>> clockOutEmployee(
      {required CheckOutModel attendanceRes, required int attendanceID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await db.clockOutEmployee(
          res: attendanceRes, attendanceID: attendanceID);
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
  Future<Either<Failure, UserEmpModel>> fetchEmployeeDataByID(
      {required String employeeID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await db.fetchEmployeeDataByID(
        employeeID: employeeID,
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
