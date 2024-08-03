import 'dart:developer';
import 'dart:io';

import 'package:attendify_lite/core/utils/fcm_helper.dart';
import 'package:dio/dio.dart';

import '../models/user_emr_model.dart';

abstract class AuthRemoteEmrDB {
  Future<UserEmrModel?> signIn({required String email});
  Future<String> sendOTPToEmail({required String email, required String code});
  Future<int> getLastEmployerID();
  Future<bool> uploadProfileImage(File file, UserEmrModel user);
  Future<UserEmrModel> createNewEmployer(
      {required String employerID,
      required String name,
      required String email,
      required File file});
  Future<bool> deleteEmployer(UserEmrModel user);
  Future<bool> changeEmailAPI(String newEmail, String employerID);
  Future<bool> saveToken({required String employerID});
  Future<bool> resetToken({required String employerID});
}

class AuthRemoteDBEmrImpl implements AuthRemoteEmrDB {
  final Dio dio;
  AuthRemoteDBEmrImpl({required this.dio});

  @override
  Future<bool> uploadProfileImage(File file, UserEmrModel user) async {
    final url = 'employer/${user.employerId}/';
    log(MultipartFile.fromFile(file.path).toString());
    log("oyeeeeee${user.employerId}");
    FormData data = FormData.fromMap({
      'image_url': await MultipartFile.fromFile(file.path),
    });
    final res = await dio.patch(
      url,
      data: data,
    );
    log(res.toString());
    return true;
  }

  @override
  Future<UserEmrModel> signIn({required String email}) async {
    final res = await dio.get('employer/$email/');
    if (res.statusCode == 200) {
      return UserEmrModel.fromMap(res.data);
    }
    throw "Something went wrong";
  }

  @override
  Future<String> sendOTPToEmail(
      {required String email, required String code}) async {
    final url =
        'https://attendifyapi.swatitech.com/api/Employers/SendOTP?Email=$email&Number=$code';

    final response = await Dio().get(url, queryParameters: {
      'Email': email,
    });

    if (response.statusCode == 200) {
      return response.data.toString();
    }
    return '';
  }

  @override
  Future<int> getLastEmployerID() async {
    final response = await dio.get('GetMaxEmployer/max-count/');
    if (response.statusCode == 200) {
      return int.parse(response.data);
    }
    throw 'Something Went Wrong';
  }

  @override
  Future<UserEmrModel> createNewEmployer(
      {required String employerID,
      required String name,
      required String email,
      required File? file}) async {
    MultipartFile? fileUrl;

    if (file != null) {
      String fileName = file.path.split('/').last;
      fileUrl = await MultipartFile.fromFile(file.path, filename: fileName);
    }

    FormData formData = FormData.fromMap({
      "image_url": fileUrl,
      'employer_id': employerID,
      'organization_name': name,
      'email_address': email,
      'is_active': true,
      'is_deleted': false,
    });
    final res = await dio.post("employer/", data: formData);
    if (res.statusCode == 201) {
      return UserEmrModel.fromMap(res.data);
    }

    throw 'Something Went Wrong';
  }

  @override
  Future<bool> deleteEmployer(UserEmrModel user) async {
    final res = await dio.delete('employer/delete/');
    if (res.statusCode == 200) true;
    throw 'Something went wrong';
  }

  @override
  Future<bool> changeEmailAPI(String newEmail, String employerID) async {
    final res = await dio.patch('employer/$employerID',
        data: FormData.fromMap({'email_address': newEmail}));
    if (res.statusCode == 200) {
      return true;
    }
    if (res.statusCode == 400) {
      throw res.data['email_address'][0];
    }
    throw 'Something went wrong';
  }

  @override
  Future<bool> saveToken({required String employerID}) async {
    final url = 'employer/$employerID';

    String? token = await FCMHelper.generateFCMToken();

    final request =
        await dio.patch(url, data: FormData.fromMap({"token": token}));

    if (request.statusCode == 200) {
      return true;
    }
    throw 'Unknown error occured';
  }

  @override
  Future<bool> resetToken({required String employerID}) async {
    final url = 'employer/$employerID';

    final request = await dio.patch(url, data: FormData.fromMap({"token": ''}));

    if (request.statusCode == 200) {
      return true;
    }
    throw 'Unknown error occured';
  }
}
