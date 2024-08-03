// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:attendify_lite/app/features/employer/reports/data/models/invoice_model.dart';
import 'package:attendify_lite/core/error/exceptions.dart';
import 'package:dio/dio.dart';

import '../models/data_response.dart';

abstract class RemoteReports {
  Future<List<InvoiceModel>> getEmployeeInvoice(
    String empId,
    DateTime start,
    DateTime end,
  );
  Future<List<InvoiceModel>> getEmployeeInvoiceByEmrID(
    String empId,
    String emrID,
    DateTime start,
    DateTime end,
  );
  Future<List<DateResponse>> getDates(
    DateTime start,
    DateTime end,
  );
}

class RemoteReportsImpl implements RemoteReports {
  final Dio dio;

  RemoteReportsImpl({required this.dio});
  @override
  Future<List<InvoiceModel>> getEmployeeInvoice(
    String emrId,
    DateTime start,
    DateTime end,
  ) async {
    final startDate = start
        .copyWith(hour: 0, minute: 0, second: 0)
        .toIso8601String()
        .split('.')
        .first;
    final endDate = end
        .copyWith(hour: 23, minute: 59, second: 59)
        .toIso8601String()
        .split('.')
        .first;
    log(startDate);
    log(endDate);

    final url =
        'EmployeeAttendanceDetailWithStartAndEndDateERPV3PDF/$emrId/$startDate/$endDate';
    final res = await dio.get(url);
    if (res.statusCode == 200) {
      log("message:::22:pdf::$emrId end $endDate");
      log("message:::${res.data}");
      final List<dynamic> data = res.data;
      log("#####res--Reportsss1::$data");

      return data.map((e) => InvoiceModel.fromJson(e)).toList();
    }
    throw UnknownExpection();
  }

  @override
  Future<List<DateResponse>> getDates(
    DateTime start,
    DateTime end,
  ) async {
    final url =
        'Between_Dates/${start.toString().substring(0, 10)}/${end.copyWith(hour: 23, minute: 59, second: 59).toString().substring(0, 10)}';
    final response = await dio.get(url);
    log("message:::22:Between_Dates::${response.data}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;
      final List<DateResponse> dateResponses =
          responseData.entries.map((entry) {
        return DateResponse.fromJson(DateTime.parse(entry.key), entry.value);
      }).toList();
      return dateResponses;
    }
    throw UnknownExpection();
  }

  @override
  Future<List<InvoiceModel>> getEmployeeInvoiceByEmrID(
    String empId,
    String emrID,
    DateTime start,
    DateTime end,
  ) async {
    final url =
        'EmployeeAttendanceDetailWithStartAndEndDateERPV3PDFSingle/$emrID/$empId/${start.toIso8601String().split('.').first}/${end.toIso8601String().split('.').first}';
    final res = await dio.get(url);
    log(res.toString());
    if (res.statusCode == 200) {
      final list = res.data as List;
      final flattenedList = list.expand((list) => list).toList();
      return flattenedList.map((e) => InvoiceModel.fromJson(e)).toList();
    }
    throw UnknownExpection();
  }
}
