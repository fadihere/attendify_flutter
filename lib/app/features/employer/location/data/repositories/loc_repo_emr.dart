import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employer/location/data/datasources/loc_remote_db.dart';
import 'package:attendify_lite/app/features/employer/location/data/models/loc_emr_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../place_picker/entities/location_result.dart';
import '../../../team/data/models/team_model.dart';

abstract class LocRepoEmr {
  Future<Either<Failure, List<LocEmrModel>>> fetchAllLocations(
      {required String employerID});
  Future<Either<Failure, bool>> deleteLocationByID({required int locationID});
  Future<Either<Failure, LocEmrModel>> saveLocation({
    required String employerID,
    required LocationResult locationResult,
    required double radius,
    required String locationName,
  });
  Future<Either<Failure, bool>> updateEmployeeLocation(
    TeamModel user,
  );
}

class LocRepoEmrImpl extends LocRepoEmr {
  final LocRemoteDBImpl locDB;
  final NetworkInfoImpl networkInfo;

  LocRepoEmrImpl({
    required this.locDB,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<LocEmrModel>>> fetchAllLocations({
    required String employerID,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await locDB.fetchAllLocationsAPI(
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
  Future<Either<Failure, bool>> deleteLocationByID(
      {required int locationID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await locDB.deleteLocationAPI(
        locationID: locationID,
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
  Future<Either<Failure, LocEmrModel>> saveLocation({
    required String employerID,
    required String locationName,
    required LocationResult locationResult,
    required double radius,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await locDB.saveLocationAPI(
          employerID: employerID,
          locationResult: locationResult,
          locationName: locationName,
          radius: radius);
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
  Future<Either<Failure, bool>> updateEmployeeLocation(TeamModel user) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await locDB.updateEmployeeLocation(user);
      return Right(res);
    } on DioException catch (e) {
      log('${e.response?.data}');
      return Left(ServerFailure(response: e.response?.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }
}
