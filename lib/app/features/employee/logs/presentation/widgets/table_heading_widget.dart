import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/gen/assets.gen.dart';

class LogTableHeadingWidget extends StatelessWidget {
  const LogTableHeadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.hellix),
            ),
          ),
          const Expanded(
            flex: 4,
            child: Text(
              'Status',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.hellix),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'In',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: FontFamily.hellix,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Assets.icons.locationFill.svg(
                colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            )),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Out',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.hellix),
            ),
          ),
          Expanded(
            flex: 4,
            child: Assets.icons.locationFill.svg(
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
