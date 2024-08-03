import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/settings/data/datasource/setting_remote_db.dart';
import 'package:attendify_lite/app/features/employer/settings/data/models/work_hrs_model.dart';
import 'package:attendify_lite/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/network/network_info.dart';

//22 step

abstract class SettingRepoEmr {
  Future<Either<Failure, WorkHrsModel>> settingUpdateOfficeHrs({
    required String employerID,
    required WorkHrsModel model,
  });
  Future<Either<Failure, WorkHrsModel>> settingPostOfficeHrs({
    required String employerID,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required TimeOfDay gracePeriod,
    required List<dynamic> workingDays,
  });
  Future<Either<Failure, WorkHrsModel>> settingFetchOfficeHrs({
    required String employerID,
  });
  Future<Either<Failure, bool>> setIntervalForAttendanceCheck(
      {required UserEmrModel user, required int interval});
  Future<Either<Failure, bool>> deleteEmployer({required String employerID});
}

class SettingRepoEmrImpl extends SettingRepoEmr {
  final SettingRemoteEmrDBImpl settingRemoteDBEmrImpl;
  final NetworkInfoImpl networkInfo;

  SettingRepoEmrImpl({
    required this.settingRemoteDBEmrImpl,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WorkHrsModel>> settingUpdateOfficeHrs({
    required String employerID,
    required WorkHrsModel model,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await settingRemoteDBEmrImpl.updateOfficeHrs(
          employerID: employerID, workHrsModel: model);
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (e) {
      log(e.response!.data!.toString());
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, WorkHrsModel>> settingFetchOfficeHrs(
      {required String employerID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res =
          await settingRemoteDBEmrImpl.fetchOfficeTime(employerID: employerID);
      return Right(res);
    } on SocketException catch (_) {
      return left(SocketFailure());
    } on DioException catch (e) {
      log(e.response!.data!.toString());
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEmployer(
      {required String employerID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await settingRemoteDBEmrImpl.deleteEmployerAPI(
          employerID: employerID);
      return Right(res);
    } on SocketException catch (_) {
      return left(SocketFailure());
    } on DioException catch (e) {
      log(e.response!.data!.toString());
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, WorkHrsModel>> settingPostOfficeHrs(
      {required String employerID,
      required TimeOfDay startTime,
      required TimeOfDay endTime,
      required TimeOfDay gracePeriod,
      required List workingDays}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await settingRemoteDBEmrImpl.postOfficeHrs(
          employerID: employerID,
          startTime: startTime,
          endTime: endTime,
          gracePeriod: gracePeriod,
          workingDays: workingDays);
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (e) {
      log(e.response!.data!.toString());
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, bool>> setIntervalForAttendanceCheck(
      {required UserEmrModel user, required int interval}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await settingRemoteDBEmrImpl.setIntervalForAttendanceCheck(
        user: user,
        interval: interval,
      );
      return Right(res);
    } on SocketException catch (_) {
      return left(SocketFailure());
    } on DioException catch (e) {
      log(e.response!.data!.toString());
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }
}
