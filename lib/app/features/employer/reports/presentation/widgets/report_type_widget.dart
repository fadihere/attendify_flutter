import 'package:attendify_lite/app/features/employer/leave/presentation/widgets/custom_dropdown.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/bloc/report_whole_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportTypeWidget extends StatefulWidget {
  // final List<String> items;
  // final String hint;

  const ReportTypeWidget({super.key});

  @override
  _ReportTypeWidgetState createState() => _ReportTypeWidgetState();
}

class _ReportTypeWidgetState extends State<ReportTypeWidget> {
  // String _selectedValue = "Daily Report";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustDropDown<String>(
        displayStringForItem: (item) => item,
        items: [
          CustDropdownMenuItem<String>(
            value: 'Daily Report',
            child: Text(
              "Daily Report",
              style: TextStyle(
                color: context.color.font,
                fontSize: 16.r,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustDropdownMenuItem<String>(
            value: 'Monthly Report',
            child: Text(
              "Monthly Report",
              style: TextStyle(
                color: context.color.font,
                fontSize: 16.r,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustDropdownMenuItem(
            value: 'Custom Report',
            child: Text(
              "Custom Report",
              style: TextStyle(
                color: context.color.font,
                fontSize: 16.r,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
        hintText: "Select Status",
        borderRadius: 14.r,
        overlayWidth: 335.w,
        onChanged: (val) {
          context
              .read<ReportWholeBloc>()
              .add(SelectReportEvent(selectedReport: val ?? "Custom Report"));
        },
      ),
    );

    // Container(
    //   width: double.infinity,
    //   padding: EdgeInsets.symmetric(horizontal: 18.r, vertical: 4.0),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(50),
    //     border: Border.all(color: context.color.outline),
    //   ),
    //   child:
    //    DropdownButtonHideUnderline(
    //     child: DropdownButton<String>(
    //       hint: Text(widget.hint),
    //       value: _selectedValue,
    //       style: TextStyle(
    //           color: context.color.hint, fontFamily: 'Hellix', fontSize: 16.sp),
    //       onChanged: (String? newValue) {
    //         setState(() {
    //           _selectedValue = newValue ?? "Daily Report";
    //         });
    //       },
    //       items: widget.items.map<DropdownMenuItem<String>>((String value) {
    //         return DropdownMenuItem<String>(
    //           value: value,
    //           child: Text(value),
    //         );
    //       }).toList(),
    //       isExpanded: true, // Ensures 100% width
    //     ),
    //   ),
    // );
  }
}
