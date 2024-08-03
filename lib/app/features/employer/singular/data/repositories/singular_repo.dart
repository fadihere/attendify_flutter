// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../employee/auth/data/models/user_emp_model.dart';
import '../datasources/singular_local.dart';
import '../datasources/singular_remote.dart';

abstract class SingularRepo {
  Future<Either<Failure, bool>> setPin(String pin);
  Future<String> getPin();
  Future<Either<Failure, bool>> clearPin();
  Future<Either<Failure, UserEmpModel>> getEmployee(String img, String emrId);
}

class SingularRepoImpl implements SingularRepo {
  final SingularLocalImpl local;
  final SingularRemoteImpl remote;

  SingularRepoImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<Either<Failure, bool>> clearPin() async {
    try {
      final res = await local.clearPin();
      return Right(res);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<String> getPin() async {
    final res = local.getPin();
    return res;
  }

  @override
  Future<Either<Failure, bool>> setPin(String pin) async {
    try {
      final res = await local.setPin(pin);
      return Right(res);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEmpModel>> getEmployee(
    String img,
    String emrId,
  ) async {
    try {
      final id = await remote.getEmployeeId(img, emrId);
      final res = await remote.getEmployeeData(id);
      return Right(res);
    } on DioException catch (_) {
      return const Left(ServerFailure());
    }
  }
}
