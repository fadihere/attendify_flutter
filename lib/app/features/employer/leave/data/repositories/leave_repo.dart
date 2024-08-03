import 'dart:io';

import 'package:attendify_lite/app/features/employer/leave/data/models/leave_policy_model.dart';
import 'package:attendify_lite/app/features/employer/leave/data/network_services/remote_db.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../models/leave_policy.dart';

abstract class LeaveRepo {
  Future<Either<Failure, List<LeavePolicyModel>>> fetchLeavesPolicy(
      {required String employerID});
  Future<Either<Failure, LeavePolicyModel>> createLeavePolicy(
      {required LeavePolicy leavePolicy});
  Future<Either<Failure, bool>> updateLeavePolicy(
      {required LeavePolicy leavePolicy, required String policyID});
  Future<Either<Failure, bool>> deleteLeavePolicy({required int policyID});
  Future<Either<Failure, bool>> updateLeavePolicyPeriod(
      {required String fromDate,
      required String toDate,
      required String employerID});
}

class LeaveRepoImpl extends LeaveRepo {
  final LeaveRemoteDBImpl leaveDB;
  final NetworkInfoImpl networkInfo;

  LeaveRepoImpl({
    required this.leaveDB,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<LeavePolicyModel>>> fetchLeavesPolicy(
      {required String employerID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await leaveDB.fetchLeavePoliciesAPI(
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
  Future<Either<Failure, LeavePolicyModel>> createLeavePolicy(
      {required LeavePolicy leavePolicy}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await leaveDB.createLeavePolicy(
        leavePolicy: leavePolicy,
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
  Future<Either<Failure, bool>> updateLeavePolicy(
      {required LeavePolicy leavePolicy, required String policyID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await leaveDB.updateLeavePolicy(
        leavePolicy: leavePolicy,
        policyID: policyID,
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
  Future<Either<Failure, bool>> deleteLeavePolicy(
      {required int policyID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await leaveDB.deleteLeavePolicy(
        policyID: policyID,
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
  Future<Either<Failure, bool>> updateLeavePolicyPeriod({
    required String fromDate,
    required String toDate,
    required String employerID,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await leaveDB.updateLeavePolicyPeriod(
        fromDate: fromDate,
        toDate: toDate,
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
}
