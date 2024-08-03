// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:attendify_lite/app/features/employer/reports/data/models/invoice_model.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

Future<Uint8List> makePdf(
  List<InvoiceModel> invoice,
  String? logo,
  String? startDt,
  String? endDt,
) async {
  DateFormat dayFormat = DateFormat('EEE');
  DateFormat monthDayYearFormat = DateFormat('MMM dd, yyyy');
  DateFormat dayMonthYearFormat = DateFormat('dd MMM, yy');
  DateFormat dayMonthYearDashFormat = DateFormat('dd-MMM-yyyy');

  var font1 = await PdfGoogleFonts.poppinsRegular();
  var font2 = await PdfGoogleFonts.poppinsSemiBold();

  final pdf = Document();
  int index = 0;
  Image? img;
  if (logo != null) {
    final (netImage) = await networkImage(logo);
    img = Image(netImage, fit: BoxFit.cover);
  }

  final ByteData image = await rootBundle.load('assets/images/calender.png');

  Uint8List imageData = (image).buffer.asUint8List();

  final prs = _getPercent(invoice, "PRS");
  final late = _getPercent(invoice, "LTL");
  final abs = _getPercent(invoice, "ABS");
  final wfh = _getPercent(invoice, "WFH");
  final avgCheckIn =
      calculateAverageDateTime(invoice.map((e) => e.date).toList());
  final avgCheckOut =
      calculateAverageDateTime(invoice.map((e) => e.dateOut).toList());
  log("message::-->${invoice.map((e) => e.dateOut).toList()}");

  var format = DateFormat(DateFormat.HOUR_MINUTE);
  pdf.addPage(MultiPage(
    maxPages: 1000,
    margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
    pageFormat: PdfPageFormat.a4,
    orientation: PageOrientation.landscape,
    header: (context) => Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              height: 40.r,
              width: 50.r,
              color: PdfColor.fromHex('#000000'),

              child: img,
              // child: ,
              // child: PdfImage.file(pdfDocument, bytes: logoImage),
            ),
            SizedBox(width: 20.r),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Attendance History",
                      style: TextStyle(
                        fontSize: 16.r,
                      )),
                  SizedBox(height: 5.r),
                  Text(
                      "Today ${dayFormat.format(DateTime.now())}, ${monthDayYearFormat.format(DateTime.now())}",
                      style: TextStyle(
                          color: PdfColor.fromHex("#807e7e"), fontSize: 11.r))
                ]),
          ]),
          Row(children: [
            Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: PdfColor.fromHex("#E8EBEF"),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  Container(
                      width: 18.r,
                      height: 18.r,
                      child: Image(MemoryImage(imageData))),
                  Container(width: 10.r),
                  Text(
                      "${dayMonthYearFormat.format(DateTime.parse(startDt ?? ""))} - ${dayMonthYearFormat.format(DateTime.parse(endDt ?? ""))}",
                      style: TextStyle(fontSize: 12.r))
                ]))
          ])
        ],
      ),
      Container(height: 10.r),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 406.r,
          child: Divider(
              height: 1.r, thickness: 2.r, color: PdfColor.fromHex("#E8EBEF")),
        ),
      ),
      Container(height: 11.5.r),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 7.r),
            decoration: BoxDecoration(
                border:
                    Border.all(width: 2.r, color: PdfColor.fromHex("#E8EBEF")),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 7.r,
                height: 7.r,
                child: Circle(fillColor: PdfColors.green400, strokeWidth: 4),
              ),
              SizedBox(width: 5.r),
              Text(
                "On Time",
                style: TextStyle(
                  color: const PdfColor.fromInt(0xFF0A1830),
                  fontSize: 12.r,
                  fontWeight: FontWeight.normal,
                  height: 0.10.r,
                ),
              ),
              SizedBox(width: 6.r),
              Text(
                '$prs%',
                style: TextStyle(
                  color: PdfColors.grey700,
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 7.r),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: PdfColor.fromHex("#E8EBEF")),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 7.r,
                height: 7.r,
                child: Circle(
                    fillColor: PdfColor.fromHex("FFC545"), strokeWidth: 4),
              ),
              SizedBox(width: 5.r),
              Text(
                "Late",
                style: TextStyle(
                  color: const PdfColor.fromInt(0xFF0A1830),
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '$late%',
                style: TextStyle(
                  color: PdfColors.grey700,
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 7.r),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: PdfColor.fromHex("#E8EBEF")),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 7.r,
                height: 7.r,
                child: Circle(
                    fillColor: PdfColor.fromHex("EA4335"), strokeWidth: 4),
              ),
              SizedBox(width: 5.r),
              Text(
                "Absent",
                style: TextStyle(
                  color: const PdfColor.fromInt(0xFF0A1830),
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
              SizedBox(width: 6.r),
              Text(
                '$abs%',
                style: TextStyle(
                  color: PdfColors.grey700,
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 7.r),
            decoration: BoxDecoration(
                border:
                    Border.all(width: 2, color: PdfColor.fromHex("#E8EBEF")),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 7.r,
                height: 7.r,
                child: Circle(
                    fillColor: PdfColor.fromHex("7E857E"), strokeWidth: 4),
              ),
              SizedBox(width: 5.r),
              Text(
                "Work From Home",
                style: TextStyle(
                  color: const PdfColor.fromInt(0xFF0A1830),
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
              SizedBox(width: 6.r),
              Text(
                '$wfh%',
                style: TextStyle(
                  color: PdfColors.grey700,
                  fontSize: 12.r,
                  height: 0.10.r,
                ),
              ),
            ]),
          ),
        ]),
        Row(children: [
          Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Avg Check in",
                    style: const TextStyle(
                        color: PdfColors.grey800, fontSize: 10)),
                SizedBox(height: 4.r),
                Text(avgCheckIn != null ? format.format(avgCheckIn) : "-- : --",
                    style: TextStyle(
                        color: PdfColors.black,
                        fontSize: 16.r,
                        fontWeight: FontWeight.normal))
              ])),
          SizedBox(width: 1.sw / 6.5),
          Container(
              padding: const EdgeInsets.only(right: 4),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Avg Check Out",
                        style: const TextStyle(
                            color: PdfColors.grey800, fontSize: 10)),
                    SizedBox(height: 4.r),
                    Text(
                        avgCheckOut != null
                            ? format.format(avgCheckOut)
                            : "-- : --",
                        style: TextStyle(
                            color: PdfColors.black,
                            fontSize: 16.r,
                            fontWeight: FontWeight.normal)),
                  ]))
        ]),
      ]),
      SizedBox(height: 20),
    ]),
    build: (context) => [
      Table(
          border: TableBorder.all(
              width: 2, color: PdfColors.grey300, style: BorderStyle.solid),
          tableWidth: TableWidth.max,
          children: [
            TableRow(children: [
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Sr #',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        font: font2,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.r,
                      ),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Employee Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Company Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Clock In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Clock Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Work Hours',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
              SizedBox(
                  height: 27,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      'Remarks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          font: font2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.r),
                    ),
                  )),
            ]),
            // if (invoice != null)

            for (index; index < invoice.length; index++)
              TableRow(
                decoration: BoxDecoration(
                  border: TableBorder.all(
                      width: 1.6, color: PdfColor.fromHex("#a8a8a8")),
                ),
                children: [
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          invoice[index].id,
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                            color: PdfColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                      height: 29,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          invoice[index].name,
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          dayMonthYearDashFormat.format(invoice[index].date),
                          // trimAfterSpace(
                          //     "${invoice[index].date}"), //dateee
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          "swati tech",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          invoice[index].status == "ABS"
                              ? "Absent"
                              : invoice[index].status == "LTL"
                                  ? "Late"
                                  : invoice[index].status == "WFH"
                                      ? "WFH"
                                      : "Present",
                          style: invoice[index].status == "ABS"
                              ? TextStyle(
                                  font: font1,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  height: 0.14,
                                  color: PdfColor.fromHex("EA4335")) //red
                              : invoice[index].status == "LTL"
                                  ? TextStyle(
                                      font: font1,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      height: 0.14,
                                      color:
                                          PdfColor.fromHex("FFB904")) //yellow
                                  : invoice[index].status == "WFH"
                                      ? TextStyle(
                                          font: font1,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 0.14,
                                          color: PdfColors.blue800) //blue
                                      : TextStyle(
                                          font: font1,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          height: 0.14,
                                          color: PdfColors.green700), //green

                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          to12HrsEmpty(
                            invoice[index].date.toString().substring(10, 16),
                          ),
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          to12HrsEmpty(invoice[index]
                              .dateOut
                              .toString()
                              .substring(10, 16)),
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          getTotalHoursReport(invoice[index].workingTime),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                        ),
                      )),
                  SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            font: font1,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            height: 0.14,
                          ),
                        ),
                      )),
                ],
              )
          ]),
    ],
  ));
  final Uint8List pdfBytes = await pdf.save();
  // Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //   String? path;
  //
  //   if (Platform.isAndroid) {
  //     final Directory? directory =
  //     await path_provider.getExternalStorageDirectory();
  //     if (directory != null) {
  //       path = directory.path;
  //     }
  //   } else if (Platform.isIOS || Platform.isLinux || Platform.isWindows) {
  //     final Directory directory =
  //     await path_provider.getApplicationSupportDirectory();
  //     path = directory.path;
  //   } else {
  //     // Handle other platforms here
  //     return; // Return if platform is not supported
  //   }
  //
  //   final String fileLocation =
  //   Platform.isWindows ? '$path\\$fileName' : '$path/$fileName';
  //   String? result = await FilePicker.platform.getDirectoryPath();
  //
  //   if (result != null) {
  //     Directory selectedDir = Directory(result);
  //     // Get the current date
  //     DateTime now = DateTime.now();
  //
  //     // Format the current date to get the month name
  //     String monthName = DateFormat('MMMM').format(now);
  //     final pdfPath = '${selectedDir.path}/Attendance_Report_$monthName.pdf';
  //     final pdfFile = File(pdfPath);
  //     pdfFile.writeAsBytes(pdfBytes);
  //
  //     if (Platform.isAndroid || Platform.isIOS) {
  //       await OpenFile.open(pdfPath);
  //     } else if (Platform.isWindows) {
  //       await Process.run('start', <String>[fileLocation], runInShell: true);
  //     } else if (Platform.isMacOS) {
  //       await Process.run('open', <String>[fileLocation], runInShell: true);
  //     } else if (Platform.isLinux) {
  //       await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
  //     }
  //   }
  // }
  //
  // await saveAndLaunchFile(pdfBytes, "Attendance_Report.pdf");
  // String? result = await FilePicker.platform.getDirectoryPath();
  //
  // if (result != null) {
  //   Directory selectedDir = Directory(result);
  //   final pdfPath = '${selectedDir.path}/Attendance_Report.pdf';
  //   final pdfFile = File(pdfPath);
  //   await pdfFile.writeAsBytes(pdfBytes);
  //
  //
  //
  //   try {
  //     await Permission.storage.request(); // Request storage permission
  //     await OpenFile.open(pdfPath);
  //   } on PlatformException catch (e) {
  //     print("Error requesting permission: ${e.message}");
  //   }
  // }
  return pdfBytes;
}

int _getPercent(List<InvoiceModel> invoice, String status) {
  try {
    return (invoice.where((e) => e.status == status).toList().length /
            invoice.length *
            100)
        .round();
  } catch (e) {
    return 0;
  }
}

Widget paddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );

DateTime? calculateAverageDateTime(List<DateTime> dateTimeList) {
  try {
    log(dateTimeList.toString());
    if (dateTimeList.isEmpty) {
      // Return null or throw an exception depending on your requirement
      return null;
    }

    // Remove any '00:00:00' entries as they might skew the average
    dateTimeList.removeWhere((dateTime) =>
        dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0);

    // Filter out check-in times before 9:00 AM
    dateTimeList =
        dateTimeList.where((dateTime) => dateTime.hour >= 9).toList();

    if (dateTimeList.isEmpty) {
      // Return null if there are no check-in times after 9:00 AM
      return null;
    }

    // Calculate the total duration represented by all DateTime objects
    Duration totalDuration = Duration.zero;
    for (int i = 0; i < dateTimeList.length - 1; i++) {
      totalDuration += dateTimeList[i + 1].difference(dateTimeList[i]);
    }

    // Divide the total duration by the number of differences
    Duration averageDuration = totalDuration ~/ (dateTimeList.length - 1);

    // Add the average duration to the first DateTime object
    DateTime averageDateTime = dateTimeList.first.add(averageDuration);

    return averageDateTime;
  } catch (e) {
    return null;
  }
}
