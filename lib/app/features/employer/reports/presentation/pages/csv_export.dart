import 'dart:io';

import 'package:attendify_lite/app/features/employer/reports/data/models/invoice_model.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void writeExcel(List<InvoiceModel> data) async {
  final excel = Excel.createExcel();

  excel.updateCell('Sheet1', CellIndex.indexByString('A1'), 'Employee ID',
      cellStyle: CellStyle(
          backgroundColorHex: "#3d3d3d",
          fontColorHex: 'ffffff',
          bold: true,
          verticalAlign: VerticalAlign.Center));

  excel.updateCell('Sheet1', CellIndex.indexByString('B1'), 'Employee Name',
      cellStyle: CellStyle(
          backgroundColorHex: "#3d3d3d",
          fontColorHex: 'ffffff',
          bold: true,
          verticalAlign: VerticalAlign.Center));
  excel.updateCell('Sheet1', CellIndex.indexByString('C1'), 'Present',
      cellStyle: CellStyle(
          backgroundColorHex: "#3d3d3d",
          fontColorHex: 'ffffff',
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center));
  excel.updateCell('Sheet1', CellIndex.indexByString('D1'), 'Absent',
      cellStyle: CellStyle(
          backgroundColorHex: "#3d3d3d",
          fontColorHex: 'ffffff',
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center));
  excel.updateCell('Sheet1', CellIndex.indexByString('E1'), 'Work From Home',
      cellStyle: CellStyle(
          backgroundColorHex: "#3d3d3d",
          fontColorHex: 'ffffff',
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center));
  excel.updateCell(
      'Sheet1', CellIndex.indexByString('F1'), 'Total Working Days',
      cellStyle: CellStyle(
          backgroundColorHex: "#3d3d3d",
          fontColorHex: 'ffffff',
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center));

  final sheet = excel['Sheet1'];
  excel.insertColumn('Sheet1', 7);

  // Adding data
  try {
    for (final item in data) {
      sheet.appendRow([
        item.id.toString().split("_").last,
        item.name,
        data
            .where((element) => element.status == "PRS")
            .toList()
            .length
            .toString(),
        data.where((element) => element.status == "ABS").toList().length,
        data
            .where((element) => element.status == "WFH")
            .toList()
            .length
            .toString(),
        data.where((element) => element.status == "PRS").toList().length +
            data.where((element) => element.status == "WFH").toList().length
      ]);
    }

    DateTime now = DateTime.now();
    String monthName = DateFormat('MMMM').format(now);
    final Directory documentsDirectory = await getTemporaryDirectory();
    final String path =
        '${documentsDirectory.path}/Attendance_Report_$monthName.xlsx';

    final fileBytes = excel.encode();
    final File file = File(path);
    await file.writeAsBytes(fileBytes!);
    debugPrint("Status: $file");
    final result = await OpenFile.open(file.path);

    if (result.type == ResultType.noAppToOpen) {
      showToast(msg: result.message.toString());
    }
  } catch (e) {
    debugPrint('_MyExcelSheetState.writeExcel: $e');
  }
}
