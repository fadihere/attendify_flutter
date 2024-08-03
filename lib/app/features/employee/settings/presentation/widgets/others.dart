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
          padding: const EdgeInsets.symmetric(vertical: 23),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Log Out",
                  style: TextStyle(
                    color: context.color.warning,
                    fontSize: 16.r,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileAvatarWidget extends StatelessWidget {
  final VoidCallback onTap;
  const ProfileAvatarWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 80.r,
            width: 80.r,
            decoration: ShapeDecoration(
              color: context.color.font.withOpacity(0.1),
              shape: const OvalBorder(),
            ),
            child: Icon(
              Icons.person,
              size: 63.r,
              color: context.color.font.withOpacity(0.2),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 6.r,
            child: Container(
              height: 18.r,
              width: 18.r,
              decoration: ShapeDecoration(
                color: context.color.primary,
                shape: const OvalBorder(),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 13.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
