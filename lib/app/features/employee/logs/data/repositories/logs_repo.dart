// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:attendify_lite/app/features/employee/logs/data/datasources/logs_remote_db.dart';
import 'package:attendify_lite/app/features/employee/logs/data/models/logs_model.dart';
import 'package:attendify_lite/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';

abstract class LogsRepo {
  Future<Either<Failure, List<LogsModel>?>> fetchUserLogs({
    required String employeeID,
    required String employerID,
    required startDate,
    required endDate,
  });
}

class LogsRepoImpl extends LogsRepo {
  LogsRemoteDBImpl logsRemoteDB;
  NetworkInfoImpl networkInfo;
  LogsRepoImpl({
    required this.logsRemoteDB,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LogsModel>?>> fetchUserLogs({
    required String employeeID,
    required String employerID,
    required startDate,
    required endDate,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await logsRemoteDB.fetchUserLogsAPI(
        employeeID: employeeID,
        employerID: employerID,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(res);
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }
}
