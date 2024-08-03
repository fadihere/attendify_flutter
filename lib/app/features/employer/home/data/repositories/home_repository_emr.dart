import 'dart:io';

import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/app/features/employer/home/data/models/attendance_summary_model.dart';
import 'package:attendify_lite/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/network/network_info.dart';
import '../datasource/remote_db.dart';

//22 step

abstract class HomeRepoEmr {
  Future<Either<Failure, AttendanceSummaryModel>> fetchAttendanceSummary(
      {required String employerID, String? startDate, String? endDate});
  Future<Either<Failure, List>> fetchRequests(
      {required String employerID,
      required String startDate,
      required String endDate});
  Future<Either<Failure, List>> fetchAttendanceRecord({
    required String employerID,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<Either<Failure, bool>> requestApprovalAPI({
    required String transId,
    required bool request,
  });
  Future<Either<Failure, UserEmpModel>> fetchEmployeeDetail({
    required String employeeID,
  });
}

class HomeRepoEmrImpl extends HomeRepoEmr {
  final HomeRemoteEmrDBImpl homeDB;
  final NetworkInfoImpl networkInfo;

  HomeRepoEmrImpl({
    required this.homeDB,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AttendanceSummaryModel>> fetchAttendanceSummary(
      {required String employerID, String? startDate, String? endDate}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await homeDB.fetchAttendanceSummaryAPI(
        employerID: employerID,
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
  Future<Either<Failure, List>> fetchRequests(
      {required String employerID,
      required String startDate,
      required String endDate}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await homeDB.fetchRequests(
        employerID: employerID,
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
  Future<Either<Failure, bool>> requestApprovalAPI(
      {required String transId, required bool request}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res =
          await homeDB.requestApprovalAPI(transId: transId, request: request);
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
  Future<Either<Failure, List>> fetchAttendanceRecord({
    required String employerID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await homeDB.fetchAttendanceRecored(
        employerID: employerID,
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
    } on Exception catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEmpModel>> fetchEmployeeDetail(
      {required String employeeID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await homeDB.fetchUserDetail(employeeID: employeeID);
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on Exception catch (_) {
      return Left(UnknownFailure());
    }
  }
}
