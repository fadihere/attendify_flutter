import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../datasources/emr_local_db.dart';
import '../datasources/emr_remote_db.dart';

abstract class AuthRepoEmr {
  Future<Either<Failure, UserEmrModel>> signIn({required String email});
  Future<Either<Failure, bool>> saveToken({required String employerID});
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, String>> sendOTP(
      {required String email, required String code});
  Future<Either<Failure, int>> getLastEmrID();
  Future<Either<Failure, UserEmrModel>> getCurrentUser();
  Future<Either<Failure, bool>> uploadProfileImage(
    File file,
    UserEmrModel user,
  );
  Future<Either<Failure, bool>> deleteEmployer(UserEmrModel user);
  Future<Either<Failure, bool>> updateEmail(String newEmail, String employerID);
  Future<Either<Failure, UserEmrModel>> createNewEmployer(
      {required String employerID,
      required String name,
      required String email,
      required File file});
}

class AuthRepoEmrImpl implements AuthRepoEmr {
  final AuthRemoteDBEmrImpl authRemote;
  final AuthLocalDBEmrImpl authLocal;
  final NetworkInfoImpl networkInfo;

  AuthRepoEmrImpl({
    required this.authRemote,
    required this.authLocal,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, UserEmrModel>> signIn({required String email}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final tempRes = await authRemote.signIn(email: email);
      await authRemote.saveToken(employerID: tempRes.employerId);
      final res = await authRemote.signIn(email: email);

      authLocal.setCurrentUser(res);
      return Right(res);
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendOTP({
    required String email,
    required String code,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.sendOTPToEmail(email: email, code: code);
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
  Future<Either<Failure, UserEmrModel>> createNewEmployer(
      {required String employerID,
      required String name,
      required String email,
      required File? file}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.createNewEmployer(
        employerID: employerID,
        name: name,
        email: email,
        file: file,
      );
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(response: e.response!.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, int>> getLastEmrID() async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.getLastEmployerID();
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, UserEmrModel>> getCurrentUser() async {
    try {
      if (await networkInfo.isNotConnected) {
        try {
          final localUser = authLocal.getCurrentUser();
          return Right(localUser);
        } on CacheException {
          return Left(CacheFailure());
        }
      }
      final localUser = authLocal.getCurrentUser();
      final user = await authRemote.signIn(email: localUser.emailAddress);
      authLocal.setCurrentUser(user);
      return Right(user);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    } on CacheException catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final isSucess = authLocal.clearCurrentUser();
      return Right(isSucess);
    } on CacheException catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> uploadProfileImage(
      File file, UserEmrModel user) async {
    try {
      final isSucess = await authRemote.uploadProfileImage(file, user);
      return Right(isSucess);
    } on DioException catch (e) {
      debugPrint(e.response!.data.toString());
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEmployer(UserEmrModel user) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.deleteEmployer(user);
      return Right(res);
    } on DioException catch (e) {
      log('${e.response?.data}');
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateEmail(
      String newEmail, String employerID) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.changeEmailAPI(newEmail, employerID);
      return Right(res);
    } on DioException catch (e) {
      log('${e.response?.data}');
      return Left(ServerFailure(response: e.response?.data));
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveToken({required String employerID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.saveToken(employerID: employerID);
      return Right(res);
    } on DioException catch (_) {
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }
}
