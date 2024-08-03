import 'dart:io';

import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final String name;
  final String description;
  final String imageUrl;
  final String? employeeID;
  const ProfileAvatarWidget({
    super.key,
    required this.onTap,
    required this.name,
    required this.description,
    this.file,
    required this.imageUrl,
    this.employeeID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              AvatarWidget(file: file, imageUrl: imageUrl),
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
        ),
        const Gap(22),
        Text(
          name,
          style: TextStyle(
            color: context.color.font,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.hellix,
            height: 0.06,
          ),
        ),
        const Gap(13),
        SizedBox(
          width: 250.r,
          child: Text(
            description,
            style: TextStyle(
              color: context.color.hint,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.hellix,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ),
        employeeID != null
            ? Text(
                employeeID ?? '',
                style: TextStyle(
                  color: context.color.hint,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.hellix,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              )
            : const SizedBox(),
      ],
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.file,
    required this.imageUrl,
  });

  final File? file;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.r),
      child: CircleAvatar(
        backgroundColor: context.color.outline,
        radius: 40.r,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: file != null
              ? Image.file(file!, fit: BoxFit.cover)
              : imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholder: (context, url) {
                        return Icon(
                          Icons.person,
                          size: 63.r,
                          color: context.color.font.withOpacity(0.2),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Icon(
                          Icons.person,
                          size: 63.r,
                          color: context.color.font.withOpacity(0.2),
                        );
                      },
                    )
                  : Icon(
                      Icons.person,
                      size: 63.r,
                      color: context.color.font.withOpacity(0.2),
                    ),
        ),
      ),
    );
  }
}
