import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/auth/data/datasources/local_db.dart';
import 'package:attendify_lite/app/features/employee/auth/data/datasources/remote_db.dart';
import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/network/network_info.dart';
import '../models/login_model.dart';

abstract class AuthRepoEmp {
  Future<Either<Failure, LoginModel>> signIn(
    String phoneNumber,
    String password,
  );
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
    String phoneNumber,
    String password,
  );
  Future<Either<Failure, bool>> saveToken({
    required String employeeID,
    required String employerID,
  });
  Future<Either<Failure, bool>> clearToken({
    required String employeeID,
    required String employerID,
  });

  Future<Either<Failure, UserEmpModel>> getUserDataPhone(String phone);
  Future<Either<Failure, UserEmpModel>> getCurrentUserData();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> uploadProfileImage(File file, String id);
  Future<Either<Failure, bool>> changePhone({
    required String employeeID,
    required String newPhone,
    required String employerID,
    required String createdBy,
  });
  Future<Either<Failure, String?>> changePassword({
    required String phoneNumber,
    required String currentPassword,
    required String newPassword,
  });
}

class AuthRepoEmpImpl implements AuthRepoEmp {
  final AuthRemoteDBEmpImpl authRemote;
  final AuthLocalDBEmpImpl authLocal;
  final NetworkInfoImpl networkInfo;

  AuthRepoEmpImpl({
    required this.authRemote,
    required this.networkInfo,
    required this.authLocal,
  });

  @override
  Future<Either<Failure, LoginModel>> signIn(
    String phoneNumber,
    String password,
  ) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.signIn(phoneNumber, password);
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
    String phoneNumber,
    String password,
  ) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.resetPassword(phoneNumber, password);
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, UserEmpModel>> getUserDataPhone(String phone) async {
    try {
      if (await networkInfo.isNotConnected) {
        try {
          final user = authLocal.getCurrentUser();
          return Right(user);
        } on CacheException {
          return Left(CacheFailure());
        }
      }

      final user = await authRemote.getUserData(phone);
      authLocal.setCurrentUser(user);
      return Right(user);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, UserEmpModel>> getCurrentUserData() async {
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
      final user = await authRemote.getUserData(localUser.phoneNumber);
      authLocal.setCurrentUser(user);
      return Right(user);
    } on SocketException catch (_) {
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
  Future<Either<Failure, bool>> uploadProfileImage(File file, String id) async {
    try {
      final isSucess = await authRemote.uploadProfileImage(file, id);
      return Right(isSucess);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, bool>> changePhone({
    required String employeeID,
    required String newPhone,
    required String employerID,
    required String createdBy,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.changePhoneNo(
        newPhoneNumber: newPhone,
        employeeID: employeeID,
        createdBy: createdBy,
        employerID: employerID,
      );
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on DioException catch (e) {
      log(e.message.toString());
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, String?>> changePassword({
    required String phoneNumber,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.changePassword(
        phoneNumber: phoneNumber,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return Right(res);
    } on SocketException catch (_) {
      return Left(SocketFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(response: e.response));
    }
  }

  @override
  Future<Either<Failure, bool>> saveToken(
      {required String employeeID, required String employerID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.saveToken(
        employeeID: employeeID,
        employerID: employerID,
      );
      return Right(res);
    } on DioException catch (e) {
      log('${e.response?.data}');
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> clearToken(
      {required String employeeID, required String employerID}) async {
    try {
      if (await networkInfo.isNotConnected) return Left(NetworkFailure());
      final res = await authRemote.clearToken(
        employeeID: employeeID,
        employerID: employerID,
      );
      return Right(res);
    } on DioException catch (e) {
      log('${e.response?.data}');
      return const Left(ServerFailure());
    } on SocketException catch (_) {
      return Left(SocketFailure());
    }
  }
}
