// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendify_lite/core/services/database/object_box.dart';
import 'package:attendify_lite/core/services/database/objectbox.g.dart';

import '../../../../../../core/error/exceptions.dart';
import '../models/user_emp_model.dart';

abstract class AuthLocalDBEmp {
  bool setCurrentUser(UserEmpModel user);
  UserEmpModel getCurrentUser();
  bool clearCurrentUser();
}

class AuthLocalDBEmpImpl implements AuthLocalDBEmp {
  final ObjectBox box;

  AuthLocalDBEmpImpl({required this.box});

  @override
  UserEmpModel getCurrentUser() {
    final users = box.userEmp.getAll();
    if (users.isNotEmpty) {
      return users.first;
    }
    throw CacheException();
  }

  @override
  bool setCurrentUser(UserEmpModel user) {
    final userModel = UserEmpModel(
        employersId: user.employersId,
        employeeId: user.employeeId,
        employeesId: user.employeesId,
        password: user.password,
        primKey: user.primKey,
        employeeName: user.employeeName,
        jobDesignation: user.jobDesignation,
        phoneNumber: user.phoneNumber,
        multipleLocations: user.multipleLocations,
        passwordCount: user.passwordCount,
        imageUrl: user.imageUrl,
        isActive: user.isActive,
        createdBy: user.createdBy,
        createdOn: user.createdOn,
        updatedOn: user.updatedOn,
        token: user.token,
        organizationName: user.organizationName,
        employerId: user.employerId,
        locationId: user.locationId,
        employerToken: user.employerToken);
    Query<UserEmpModel> query = box.userEmp
        .query(UserEmpModel_.employeeId.equals(user.employeeId))
        .build();
    List<UserEmpModel> returnList = query.find();
    if (returnList.isNotEmpty) {
      returnList.first.phoneNumber = user.phoneNumber;

      final value = box.userEmp.put(returnList[0]);
      if (value != 0) {
        return true;
      }
      throw CacheException();
    }
    final value = box.userEmp.put(userModel);
    if (value != 0) {
      return true;
    }
    throw CacheException();
  }

  @override
  bool clearCurrentUser() {
    final value = box.userEmp.removeAll();
    if (value != 0) {
      return true;
    }
    throw CacheException();
  }
}
