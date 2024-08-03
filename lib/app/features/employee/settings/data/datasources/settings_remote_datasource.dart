// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:dio/dio.dart';

abstract class SettingRemoteEmpDB {
  Future<Map<String, dynamic>> resetPassword(
    String phoneNumber,
    String password,
  );
  Future<Map<String, dynamic>> changePhone(
    UserEmpModel user,
    String phoneNo,
  );
}

class SettingRemoteDBEmpImpl implements SettingRemoteEmpDB {
  final Dio dio;
  SettingRemoteDBEmpImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> resetPassword(
    String phoneNumber,
    String password,
  ) async {
    final res = await dio.patch(
      'forgot-password/',
      data: {
        'phone_number': phoneNumber,
        'password': password,
      },
    );
    if (res.statusCode == 200) {
      return res.data;
    }
    throw 'something went wrong';
  }

  @override
  Future<Map<String, dynamic>> changePhone(
    UserEmpModel user,
    String phoneNo,
  ) async {
    final url = 'employee/update/${user.employeeId}/';
    final res = await dio.patch(
      url,
      data: {
        'employee_id': user.employeeId,
        'employer_id': user.employerId,
        'phone_number': phoneNo,
        'created_by': user.employerId,
      },
    );
    if (res.statusCode == 200) {
      return res.data;
    }
    throw 'something went wrong';
  }
}
