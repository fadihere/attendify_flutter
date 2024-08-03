// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:attendify_lite/app/features/employee/leave/data/models/leave_transaction_model.dart';
import 'package:attendify_lite/core/error/failures.dart';
import 'package:attendify_lite/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../datasources/leave_remote_emp_db.dart';
import '../models/leave_count_model.dart';

abstract class LeaveRepoEmp {
  Future<Either<Failure, LeaveCountModel>> fetchTotalLeavesCount({
    required String employerID,
    required String employeeID,
  });
  Future<Either<Failure, List<LeaveTransactionModel>>> fetchLeaveTransactions({
    required String employeeID,
    required DateTime startDate,
  });
}

class LeaveRepoEmpImpl extends LeaveRepoEmp {
  final NetworkInfoImpl networkInfo;
  final LeaveRemoteDBEmpImpl remoteDB;
  LeaveRepoEmpImpl({
    required this.networkInfo,
    required this.remoteDB,
  });
  @override
  Future<Either<Failure, LeaveCountModel>> fetchTotalLeavesCount(
      {required String employerID, required String employeeID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await remoteDB.fetchTotalLeavesCount(
          employerID: employerID, employeeID: employeeID);
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
  Future<Either<Failure, List<LeaveTransactionModel>>> fetchLeaveTransactions(
      {required String employeeID, required DateTime startDate}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await remoteDB.fetchEmpLeaveRequest(
        employeeID: employeeID,
        startDate: startDate,
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
