import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldTagWidget extends StatelessWidget {
  final String tag;
  const TextFieldTagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10.r),
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
          color: context.color.primary,
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        tag.toUpperCase(),
        style: TextStyle(
          color: context.color.white,
          fontSize: 9.r,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
