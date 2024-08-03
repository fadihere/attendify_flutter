// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendify_lite/app/features/employer/reports/data/models/invoice_model.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/pages/AdmPdfMonthlyReport.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/pages/pdf_export.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m7_livelyness_detection/index.dart';
import 'package:printing/printing.dart';

@RoutePage()
class AdmPdfPreviewPage extends StatelessWidget {
  final List<InvoiceModel> invoice;
  final String? logo;
  final String? startDt;
  final String? endDt;
  final int? custom1Monthly2;

  const AdmPdfPreviewPage({
    super.key,
    required this.invoice,
    this.logo,
    this.startDt,
    this.endDt,
    required this.custom1Monthly2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance Report",
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: PdfPreview(
        allowSharing: false,
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        previewPageMargin: const EdgeInsets.all(15.0),
        build: (context) {
          return custom1Monthly2 == 1
              ? makePdf(invoice, logo, startDt, endDt)
              : makeMonthlyPdf(invoice, logo, startDt, endDt);
        },
      ),
    );
  }
}

//MemoryImage(File(logoImage).readAsBytesSync()))
