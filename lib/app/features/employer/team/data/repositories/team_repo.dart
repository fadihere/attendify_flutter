import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/logs/data/models/logs_model.dart';
import 'package:attendify_lite/app/features/employer/settings/data/models/work_hrs_model.dart';
import 'package:attendify_lite/app/features/employer/team/data/datasources/team_remote.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../../../../employee/auth/data/models/user_emp_model.dart';
import '../../../auth/data/models/user_emr_model.dart';

abstract class TeamRepo {
  Future<Either<Failure, List<TeamModel>>> getmyTeams(UserEmrModel user);
  Future<Either<Failure, bool>> achiveTeam(
    UserEmrModel user,
    TeamModel team,
    bool action,
  );
  Future<Either<Failure, List<UserEmpModel>>> getUserAttendanceData(
    TeamModel user,
  );
  Future<Either<Failure, WorkHrsModel>> fetchEmployeeWorkHours(
    TeamModel user,
  );
  Future<Either<Failure, WorkHrsModel>> updateEmployeeWorkHours({
    required TeamModel user,
    required WorkHrsModel workHrs,
  });
  Future<Either<Failure, WorkHrsModel>> postEmployeeWorkHours({
    required TeamModel user,
    required WorkHrsModel workHrs,
  });
  Future<Either<Failure, TeamModel>> createEmployee(
    TeamModel user,
    File? image,
    String password,
  );

  Future<Either<Failure, int>> getEmployeeId(int id);
  Future<Either<Failure, bool>> registerEmployeeFace(
    File image,
    String empId,
  );
  Future<Either<Failure, bool>> deleteEmployee(TeamModel team);
  Future<Either<Failure, bool>> updateEmployeePhone(
    TeamModel team,
    String phone,
    UserEmrModel user,
  );

  Future<Either<Failure, List<LogsModel>>> fetchEmployeeAttendanceLogs({
    required String employerID,
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class TeamRepoImpl implements TeamRepo {
  final TeamRemoteDBImpl teamDB;
  final NetworkInfoImpl networkInfo;

  TeamRepoImpl({
    required this.teamDB,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TeamModel>>> getmyTeams(UserEmrModel user) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.getTeams(user);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(response: e.response?.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserEmpModel>>> getUserAttendanceData(
      TeamModel user) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.getUserAttendanceData(user);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(response: e.response?.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> achiveTeam(
    UserEmrModel user,
    TeamModel team,
    bool action,
  ) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.archiveTeam(user, team, action);
      return Right(res);
    } on DioException catch (_) {
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, TeamModel>> createEmployee(
    TeamModel user,
    File? image,
    String password,
  ) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.createEmployee(user, image, password);
      // await teamDB.addEmployeeLocation(user);
      return Right(res);
    } on DioException catch (e) {
      log(e.response!.data.toString());
      return Left(ServerFailure(response: e.response?.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getEmployeeId(int id) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.getEmployeeId(id);
      return Right(res);
    } on DioException catch (_) {
      return Left(UnknownFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEmployee(TeamModel team) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.deleteEmployee(team);
      log(res.toString());
      return Right(res);
    } on DioException catch (e) {
      log('${e.response?.data}');
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on Exception catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateEmployeePhone(
      TeamModel team, String phone, UserEmrModel user) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.updateEmployeePhone(team, phone, user);
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(response: e.response?.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> registerEmployeeFace(
    File image,
    String empId,
  ) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.registerEmployeeFace(image, empId);
      return Right(res);
    } on DioException catch (e) {
      log(e.response!.data.toString());
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, List<LogsModel>>> fetchEmployeeAttendanceLogs({
    required String employerID,
    required String employeeID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.fetchEmployeeAttendanceLogs(
          employerID: employerID,
          employeeID: employeeID,
          startDate: startDate,
          endDate: endDate);
      return Right(res);
    } on DioException catch (e) {
      log(e.response!.data.toString());
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, WorkHrsModel>> fetchEmployeeWorkHours(
      TeamModel team) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.fetchEmployeeWorkHours(team: team);
      return Right(res);
    } on DioException catch (e) {
      log(e.response!.data.toString());
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, WorkHrsModel>> updateEmployeeWorkHours(
      {required TeamModel user, required WorkHrsModel workHrs}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.updateEmpWorkHrs(team: user, workHrs: workHrs);
      return Right(res);
    } on DioException catch (e) {
      log(e.response!.data.toString());
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, WorkHrsModel>> postEmployeeWorkHours(
      {required TeamModel user, required WorkHrsModel workHrs}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await teamDB.postEmpWorkHrs(team: user, workHrs: workHrs);
      return Right(res);
    } on DioException catch (e) {
      log(e.response!.data.toString());
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }
}
