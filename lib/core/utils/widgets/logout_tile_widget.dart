import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  const LogoutTileWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            top: 10.0,
          ),
          child: Text(
            "Log Out",
            style: TextStyle(
              color: context.color.warning,
              fontSize: 16.r,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
