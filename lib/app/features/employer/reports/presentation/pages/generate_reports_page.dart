import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/reports/data/datasources/remote_reports.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/pages/csv_export.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/widgets/report_type_widget.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/widgets/date_picker_widget.dart';
import 'package:attendify_lite/core/utils/widgets/day_year_widget.dart';
import 'package:attendify_lite/injection_container.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/config/routes/app_router.gr.dart';
import '../bloc/report_whole_bloc.dart';

@RoutePage()
class AdmReportPage extends StatefulWidget {
  final UserEmrModel user;
  const AdmReportPage({super.key, required this.user});

  @override
  State<AdmReportPage> createState() => _AdmReportPageState();
}

class _AdmReportPageState extends State<AdmReportPage> {
  DateTime start = DateTime.now().previousDay;
  DateTime end = DateTime.now();
  bool loading = false;
  bool loadingExcel = false;
  String reportType = "";

  void _getExcelData(
      String employerId, String startDate, String endDate) async {
    final remote = RemoteReportsImpl(dio: sl());
    final data = await remote.getEmployeeInvoice(
      employerId,
      start,
      end,
    );
    writeExcel(data);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    setState(() {
      loadingExcel = false;
    });
  }

  DateTime currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Generate Report",
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: Padding(
        padding: AppSize.overallPadding,
        child: Column(
          children: [
            const ReportTypeWidget(),
            const Gap(20),
            BlocBuilder<ReportWholeBloc, ReportState>(
              builder: (context, state) {
                if (state.reportType == "Monthly Report") {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MonthPickerWidget(
                          initialYear: currentDate.year,
                          startYear: 2000,
                          endYear: currentDate.year,
                          month: currentDate.month),
                      const Gap(15),
                      const Text(
                        "Monthly report is available for download as an \n Excel sheet or a PDF",
                        textAlign: TextAlign.center,
                      ),
                      const Gap(15),
                      BlocBuilder<AuthEmrBloc, AuthEmrState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  final remote = RemoteReportsImpl(dio: sl());
                                  final data = await remote.getEmployeeInvoice(
                                    widget.user.employerId,
                                    start,
                                    end,
                                  );

                                  if (data.isNotEmpty) {
                                    router.push(AdmPdfPreviewRoute(
                                      invoice: data,
                                      logo: state.user!.imageUrl,
                                      startDt:
                                          start.toString().substring(0, 10),
                                      endDt: end.toString().substring(0, 10),
                                      custom1Monthly2: 1,
                                    ));
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Container(
                                  decoration: dropShadowDecoration(context),
                                  child: loading
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : ListTile(
                                          title: Text(
                                            "PDF",
                                            style: TextStyle(
                                                fontSize: 16.r,
                                                color: context.color.font,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: loading
                                              ? null
                                              : Text(
                                                  "Monthly Attendance Report",
                                                  style: TextStyle(
                                                      fontSize: 16.r,
                                                      color: context.color.font,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                        ),
                                ),
                              ),
                              const Gap(15),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loadingExcel = true;
                                  });
                                  _getExcelData(
                                      widget.user.employerId,
                                      start.toString().substring(0, 10),
                                      end.toString().substring(0, 10));
                                  setState(() {
                                    loadingExcel = false;
                                  });
                                },
                                child: Container(
                                  decoration: dropShadowDecoration(context),
                                  child: loadingExcel
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : ListTile(
                                          title: Text(
                                            "CSV",
                                            style: TextStyle(
                                                fontSize: 16.r,
                                                color: context.color.font,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: loadingExcel
                                              ? null
                                              : Text(
                                                  "Monthly Attendance Report",
                                                  style: TextStyle(
                                                      fontSize: 16.r,
                                                      color: context.color.font,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                        ),
                                ),
                              ),
                              const Gap(15),
                              // const Divider(),
                              // const Gap(15),
                              // GestureDetector(
                              //   onTap: () async {
                              //     final remote = RemoteReportsImpl(dio: sl());
                              //     final data = await remote.getEmployeeInvoice(
                              //       widget.user.employerId,
                              //       start,
                              //       end,
                              //     );

                              //     router.push(AdmPdfPreviewRoute(
                              //         invoice: data, custom1Monthly2: 2));
                              //   },
                              //   child: Container(
                              //     decoration: dropShadowDecoration(context),
                              //     child: loadingExcel
                              //         ? const CircularProgressIndicator.adaptive()
                              //         : ListTile(
                              //             title: Text(
                              //               "Monthly Pdf Report",
                              //               style: TextStyle(
                              //                   fontSize: 16.r,
                              //                   color: context.color.font,
                              //                   fontWeight: FontWeight.w600),
                              //             ),
                              //             subtitle: loadingExcel
                              //                 ? null
                              //                 : Text(
                              //                     "Monthly Pdf Report",
                              //                     style: TextStyle(
                              //                         fontSize: 16.r,
                              //                         color: context.color.font,
                              //                         fontWeight: FontWeight.w400),
                              //                   ),
                              //           ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                      )
                    ],
                  );
                }
                if (state.reportType == "Custom Report") {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DatePickerWidget(
                            initialValue: start,
                            onchange: (date) {
                              setState(() => start = date);
                            },
                          ),
                          DatePickerWidget(
                            initialValue: end,
                            onchange: (date) {
                              setState(() => end = date);
                            },
                          ),
                        ],
                      ),
                      const Gap(15),
                      const Text(
                        "Custom report is available for download as an \nExcel sheet or a PDF",
                        textAlign: TextAlign.center,
                      ),
                      const Gap(15),
                      BlocBuilder<AuthEmrBloc, AuthEmrState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  final remote = RemoteReportsImpl(dio: sl());
                                  final data = await remote.getEmployeeInvoice(
                                    widget.user.employerId,
                                    start,
                                    end,
                                  );

                                  if (data.isNotEmpty) {
                                    router.push(AdmPdfPreviewRoute(
                                      invoice: data,
                                      logo: state.user!.imageUrl,
                                      startDt:
                                          start.toString().substring(0, 10),
                                      endDt: end.toString().substring(0, 10),
                                      custom1Monthly2: 1,
                                    ));
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Container(
                                  decoration: dropShadowDecoration(context),
                                  child: loading
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : ListTile(
                                          title: Text(
                                            "PDF",
                                            style: TextStyle(
                                                fontSize: 16.r,
                                                color: context.color.font,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: loading
                                              ? null
                                              : Text(
                                                  "Custom Attendance Report",
                                                  style: TextStyle(
                                                      fontSize: 16.r,
                                                      color: context.color.font,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                        ),
                                ),
                              ),
                              const Gap(15),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loadingExcel = true;
                                  });
                                  _getExcelData(
                                      widget.user.employerId,
                                      start.toString().substring(0, 10),
                                      end.toString().substring(0, 10));
                                  setState(() {
                                    loadingExcel = false;
                                  });
                                },
                                child: Container(
                                  decoration: dropShadowDecoration(context),
                                  child: loadingExcel
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : ListTile(
                                          title: Text(
                                            "CSV",
                                            style: TextStyle(
                                                fontSize: 16.r,
                                                color: context.color.font,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: loadingExcel
                                              ? null
                                              : Text(
                                                  "Custom Attendance Report",
                                                  style: TextStyle(
                                                      fontSize: 16.r,
                                                      color: context.color.font,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                        ),
                                ),
                              ),
                              const Gap(15),
                              // const Divider(),
                              // const Gap(15),
                              // GestureDetector(
                              //   onTap: () async {
                              //     final remote = RemoteReportsImpl(dio: sl());
                              //     final data = await remote.getEmployeeInvoice(
                              //       widget.user.employerId,
                              //       start,
                              //       end,
                              //     );

                              //     router.push(AdmPdfPreviewRoute(
                              //         invoice: data, custom1Monthly2: 2));
                              //   },
                              //   child: Container(
                              //     decoration: dropShadowDecoration(context),
                              //     child: loadingExcel
                              //         ? const CircularProgressIndicator.adaptive()
                              //         : ListTile(
                              //             title: Text(
                              //               "Monthly Pdf Report",
                              //               style: TextStyle(
                              //                   fontSize: 16.r,
                              //                   color: context.color.font,
                              //                   fontWeight: FontWeight.w600),
                              //             ),
                              //             subtitle: loadingExcel
                              //                 ? null
                              //                 : Text(
                              //                     "Monthly Pdf Report",
                              //                     style: TextStyle(
                              //                         fontSize: 16.r,
                              //                         color: context.color.font,
                              //                         fontWeight: FontWeight.w400),
                              //                   ),
                              //           ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                      )
                    ],
                  );
                }
                if (state.reportType == "Daily Report") {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Daily report is available for download as an \nExcel sheet or a PDF",
                        textAlign: TextAlign.center,
                      ),
                      const Gap(15),
                      BlocBuilder<AuthEmrBloc, AuthEmrState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  final remote = RemoteReportsImpl(dio: sl());
                                  final data = await remote.getEmployeeInvoice(
                                    widget.user.employerId,
                                    start,
                                    end,
                                  );

                                  if (data.isNotEmpty) {
                                    router.push(AdmPdfPreviewRoute(
                                      invoice: data,
                                      logo: state.user!.imageUrl,
                                      startDt:
                                          start.toString().substring(0, 10),
                                      endDt: end.toString().substring(0, 10),
                                      custom1Monthly2: 1,
                                    ));
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Container(
                                  decoration: dropShadowDecoration(context),
                                  child: loading
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : ListTile(
                                          title: Text(
                                            "PDF",
                                            style: TextStyle(
                                                fontSize: 16.r,
                                                color: context.color.font,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: loading
                                              ? null
                                              : Text(
                                                  "Daily Attendance Report",
                                                  style: TextStyle(
                                                      fontSize: 16.r,
                                                      color: context.color.font,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                        ),
                                ),
                              ),
                              const Gap(15),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loadingExcel = true;
                                  });
                                  _getExcelData(
                                      widget.user.employerId,
                                      start.toString().substring(0, 10),
                                      end.toString().substring(0, 10));
                                  setState(() {
                                    loadingExcel = false;
                                  });
                                },
                                child: Container(
                                  decoration: dropShadowDecoration(context),
                                  child: loadingExcel
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : ListTile(
                                          title: Text(
                                            "CSV",
                                            style: TextStyle(
                                                fontSize: 16.r,
                                                color: context.color.font,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: loadingExcel
                                              ? null
                                              : Text(
                                                  "Daily Attendance Report",
                                                  style: TextStyle(
                                                      fontSize: 16.r,
                                                      color: context.color.font,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                        ),
                                ),
                              ),
                              const Gap(15),
                              // const Divider(),
                              // const Gap(15),
                              // GestureDetector(
                              //   onTap: () async {
                              //     final remote = RemoteReportsImpl(dio: sl());
                              //     final data = await remote.getEmployeeInvoice(
                              //       widget.user.employerId,
                              //       start,
                              //       end,
                              //     );

                              //     router.push(AdmPdfPreviewRoute(
                              //         invoice: data, custom1Monthly2: 2));
                              //   },
                              //   child: Container(
                              //     decoration: dropShadowDecoration(context),
                              //     child: loadingExcel
                              //         ? const CircularProgressIndicator.adaptive()
                              //         : ListTile(
                              //             title: Text(
                              //               "Monthly Pdf Report",
                              //               style: TextStyle(
                              //                   fontSize: 16.r,
                              //                   color: context.color.font,
                              //                   fontWeight: FontWeight.w600),
                              //             ),
                              //             subtitle: loadingExcel
                              //                 ? null
                              //                 : Text(
                              //                     "Monthly Pdf Report",
                              //                     style: TextStyle(
                              //                         fontSize: 16.r,
                              //                         color: context.color.font,
                              //                         fontWeight: FontWeight.w400),
                              //                   ),
                              //           ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                      )
                    ],
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DatePickerWidget(
                          initialValue: start,
                          onchange: (date) {
                            setState(() => start = date);
                          },
                        ),
                        DatePickerWidget(
                          initialValue: end,
                          onchange: (date) {
                            setState(() => end = date);
                          },
                        ),
                      ],
                    ),
                    const Gap(15),
                    const Text(
                      "Custom report is available for download as an \nExcel sheet or a PDF",
                      textAlign: TextAlign.center,
                    ),
                    const Gap(15),
                    BlocBuilder<AuthEmrBloc, AuthEmrState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                final remote = RemoteReportsImpl(dio: sl());
                                final data = await remote.getEmployeeInvoice(
                                  widget.user.employerId,
                                  start,
                                  end,
                                );

                                if (data.isNotEmpty) {
                                  router.push(AdmPdfPreviewRoute(
                                    invoice: data,
                                    logo: state.user!.imageUrl,
                                    startDt: start.toString().substring(0, 10),
                                    endDt: end.toString().substring(0, 10),
                                    custom1Monthly2: 1,
                                  ));
                                }
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Container(
                                decoration: dropShadowDecoration(context),
                                child: loading
                                    ? const CircularProgressIndicator.adaptive()
                                    : ListTile(
                                        title: Text(
                                          "PDF",
                                          style: TextStyle(
                                              fontSize: 16.r,
                                              color: context.color.font,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: loading
                                            ? null
                                            : Text(
                                                "Custom Attendance Report",
                                                style: TextStyle(
                                                    fontSize: 16.r,
                                                    color: context.color.font,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                      ),
                              ),
                            ),
                            const Gap(15),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  loadingExcel = true;
                                });
                                _getExcelData(
                                    widget.user.employerId,
                                    start.toString().substring(0, 10),
                                    end.toString().substring(0, 10));
                                setState(() {
                                  loadingExcel = false;
                                });
                              },
                              child: Container(
                                decoration: dropShadowDecoration(context),
                                child: loadingExcel
                                    ? const CircularProgressIndicator.adaptive()
                                    : ListTile(
                                        title: Text(
                                          "CSV",
                                          style: TextStyle(
                                              fontSize: 16.r,
                                              color: context.color.font,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: loadingExcel
                                            ? null
                                            : Text(
                                                "Custom Attendance Report",
                                                style: TextStyle(
                                                    fontSize: 16.r,
                                                    color: context.color.font,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                      ),
                              ),
                            ),
                            const Gap(15),
                            // const Divider(),
                            // const Gap(15),
                            // GestureDetector(
                            //   onTap: () async {
                            //     final remote = RemoteReportsImpl(dio: sl());
                            //     final data = await remote.getEmployeeInvoice(
                            //       widget.user.employerId,
                            //       start,
                            //       end,
                            //     );

                            //     router.push(AdmPdfPreviewRoute(
                            //         invoice: data, custom1Monthly2: 2));
                            //   },
                            //   child: Container(
                            //     decoration: dropShadowDecoration(context),
                            //     child: loadingExcel
                            //         ? const CircularProgressIndicator.adaptive()
                            //         : ListTile(
                            //             title: Text(
                            //               "Monthly Pdf Report",
                            //               style: TextStyle(
                            //                   fontSize: 16.r,
                            //                   color: context.color.font,
                            //                   fontWeight: FontWeight.w600),
                            //             ),
                            //             subtitle: loadingExcel
                            //                 ? null
                            //                 : Text(
                            //                     "Monthly Pdf Report",
                            //                     style: TextStyle(
                            //                         fontSize: 16.r,
                            //                         color: context.color.font,
                            //                         fontWeight: FontWeight.w400),
                            //                   ),
                            //           ),
                            //   ),
                            // ),
                          ],
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
