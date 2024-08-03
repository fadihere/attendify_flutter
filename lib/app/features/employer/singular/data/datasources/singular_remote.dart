// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendify_lite/app/features/employee/auth/data/models/user_emp_model.dart';
import 'package:attendify_lite/core/constants/app_constants.dart';
import 'package:attendify_lite/core/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class SingularRemote {
  Future<String> getEmployeeId(String img, String emrId);
  Future<UserEmpModel> getEmployeeData(String empId);
}

class SingularRemoteImpl implements SingularRemote {
  final Dio dio;

  SingularRemoteImpl({
    required this.dio,
  });
  @override
  Future<String> getEmployeeId(String img, String emrId) async {
    final file = await MultipartFile.fromFile(img);
    final res = await dio.post(
      '${AppConst.baseUrlFace}compareV2/',
      queryParameters: {
        'yolo': 0,
        'specific_code': emrId,
      },
      data: FormData.fromMap({'file': file}),
    );
    if (res.statusCode == 200) {
      return res.data['data'].first;
    }
    throw UnknownExpection();
  }

  @override
  Future<UserEmpModel> getEmployeeData(String empId) async {
    final res = await dio.get('employee/update/$empId/');
    if (res.statusCode == 200) {
      return UserEmpModel.fromMap(res.data);
    }
    throw UnknownExpection();
  }
}
