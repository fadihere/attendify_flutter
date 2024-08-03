import 'dart:async';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/home/data/datasources/home_remote_emp_db.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/check_in_model.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/last_in_res.dart';
import 'package:attendify_lite/app/features/employee/home/data/models/wfh_attendance_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../models/check_out_model.dart';
import '../models/location_model.dart';

abstract class HomeRepoEmp {
  Future<Either<Failure, LastInModel?>> lastCheckIn({
    required String employeeID,
    required String employerID,
  });
  Future<Either<Failure, LocationModel?>> fetchLocationByID({
    required int locationID,
  });
  Future<Either<Failure, bool>> clockIn({
    required CheckInModel checkInModel,
  });
  Future<Either<Failure, bool>> clockOut({
    required CheckOutModel checkout,
    required LastInModel lastIn,
  });
  Future<Either<Failure, WfhAttendanceModel>> requestWFH({
    required CheckInModel checkInModel,
  });
  Future<Either<Failure, Map<String, dynamic>>> verifyFaceScan({
    required String id,
    required File file,
  });
}

class HomeRepoEmpImpl extends HomeRepoEmp {
  final HomeRemoteDBEmpImpl empHomeRemoteDB;
  final NetworkInfoImpl networkInfo;

  HomeRepoEmpImpl({
    required this.empHomeRemoteDB,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LastInModel>> lastCheckIn({
    required String employeeID,
    required String employerID,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await empHomeRemoteDB
          .empLastInAPI(
            employeeID: employeeID,
            employerID: employerID,
          )
          .timeout(const Duration(seconds: 15));
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on TimeoutException catch (_) {
      return const Left(
          TimeoutFailure(errorMessage: "Request Timed Out. Try Again Later"));
    }
  }

  @override
  Future<Either<Failure, LocationModel>> fetchLocationByID({
    required int locationID,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await empHomeRemoteDB
          .getLocationData(
            locationID: locationID,
          )
          .timeout(const Duration(seconds: 15));
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on TimeoutException catch (_) {
      return const Left(
          TimeoutFailure(errorMessage: "Request Timed Out. Try Again Later"));
    }
  }

  @override
  Future<Either<Failure, bool>> clockIn({
    required CheckInModel checkInModel,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await empHomeRemoteDB
          .clockIn(checkInModel: checkInModel)
          .timeout(const Duration(seconds: 15));
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on TimeoutException catch (_) {
      return const Left(
          TimeoutFailure(errorMessage: "Request Timed Out. Try Again Later"));
    }
  }

  @override
  Future<Either<Failure, WfhAttendanceModel>> requestWFH({
    required CheckInModel checkInModel,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await empHomeRemoteDB
          .requestWFH(checkInModel: checkInModel)
          .timeout(const Duration(seconds: 15));
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on TimeoutException catch (_) {
      return const Left(
          TimeoutFailure(errorMessage: "Request Timed Out. Try Again Later"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyFaceScan({
    required String id,
    required File file,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await empHomeRemoteDB.verifyFaceScan(id: id, file: file);
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (e) {
      return Left(ServerFailure(response: e.response!.data!));
    } on TimeoutException catch (_) {
      return const Left(
          TimeoutFailure(errorMessage: "Request Timed Out. Try Again Later"));
    }
  }

  @override
  Future<Either<Failure, bool>> clockOut({
    required CheckOutModel checkout,
    required LastInModel lastIn,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await empHomeRemoteDB
          .clockOut(
            checkout: checkout,
            lastIn: lastIn,
          )
          .timeout(const Duration(seconds: 15));
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on TimeoutException catch (_) {
      return const Left(
          TimeoutFailure(errorMessage: "Request Timed Out. Try Again Later"));
    }
  }
}
