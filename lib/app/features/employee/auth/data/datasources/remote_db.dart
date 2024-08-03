import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/core/utils/fcm_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../models/login_model.dart';

abstract class AuthRemoteDBEmp {
  Future<LoginModel> signIn(String phoneNumber, String password);
  Future<Map<String, dynamic>> resetPassword(
    String phoneNumber,
    String password,
  );
  Future<bool> changePhoneNo({
    required String newPhoneNumber,
    required String employeeID,
    required String employerID,
    required String createdBy,
  });
  Future<bool> saveToken({
    required String employeeID,
    required String employerID,
  });
  Future<bool> clearToken({
    required String employeeID,
    required String employerID,
  });

  Future<UserEmpModel> getUserData(
    String phone,
  );
  Future<LocationEmpModel> getLocationData(String locationId);
  Future<bool> uploadProfileImage(File file, String id);

  Future<String?> changePassword({
    required String phoneNumber,
    required String currentPassword,
    required String newPassword,
  });
}

class AuthRemoteDBEmpImpl implements AuthRemoteDBEmp {
  final Dio dio;
  AuthRemoteDBEmpImpl({required this.dio});

  @override
  Future<LoginModel> signIn(String phoneNumber, String password) async {
    final res = await dio.post(
      'login/',
      data: {
        "phone_number": phoneNumber,
        "password": password,
      },
    );
    if (res.statusCode == 200) {
      return LoginModel.fromMap(res.data);
    }
    throw 'something went wrong';
  }

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
  Future<bool> changePhoneNo({
    required String newPhoneNumber,
    required String employeeID,
    required String employerID,
    required String createdBy,
  }) async {
    final res = await dio.put('employee/update/${employeeID.toString()}/',
        data: FormData.fromMap({
          "employee_id": employeeID.toString(),
          'phone_number': newPhoneNumber.toString(),
          'created_by': employerID,
        }));
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<UserEmpModel> getUserData(String phone) async {
    final res = await dio.get('employee/$phone/');
    if (res.statusCode == 200) {
      return UserEmpModel.fromMap(res.data);
    }

    throw 'something went wrong';
  }

  @override
  Future<LocationEmpModel> getLocationData(String locationId) async {
    final res = await dio.patch('employee/location/$locationId/');
    if (res.statusCode == 200) {
      return res.data;
    }
    throw 'something went wrong';
  }

  @override
  Future<bool> uploadProfileImage(File file, String id) async {
    final url = 'employee/update/$id/';
    FormData formData = FormData.fromMap(
        {'image_url': await MultipartFile.fromFile(file.path)});
    final res = await dio.patch(
      url,
      data: formData,
      options: Options(
        headers: {
          // If your server requires authentication, add your token here
          // "Authorization": "Bearer $yourToken",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
    log(res.data.toString());
    return true;
  }

  @override
  Future<String?> changePassword({
    required String phoneNumber,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await dio.patch(
        'change-password/',
        data: {
          "phone_number": phoneNumber,
          "password": currentPassword,
          "new_password": newPassword,
        },
      );

      if (res.statusCode == 200) {
        return res.data['response'];
      }
      return '';
    } catch (e) {
      debugPrint('ERROR OCCURRED ======> $e');
      return '';
    }
  }

  @override
  Future<bool> saveToken({
    required String employeeID,
    required String employerID,
  }) async {
    String? token = await FCMHelper.generateFCMToken();

    log("FCM TOKEN GENERATED =====> ${token.toString()}");
    final response = await dio.put(
      'employee/update/$employeeID/',
      data: FormData.fromMap(
        {
          'employee_id': employeeID.toString(),
          'employees_id': employerID.toString(),
          'employer_id': employerID.toString(),
          'created_by': employerID.toString(),
          'token': token.toString(),
          'isActive': true.toString(),
        },
      ),
    );

    // final extractedData = response.body;
    // log(extractedData.toString());
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> clearToken(
      {required String employeeID, required String employerID}) async {
    final response = await dio.put(
      'employee/update/$employeeID/',
      data: FormData.fromMap(
        {
          'employee_id': employeeID.toString(),
          'employees_id': employerID.toString(),
          'employer_id': employerID.toString(),
          'created_by': employerID.toString(),
          'token': '',
          'isActive': true.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw UnimplementedError();
  }
}
