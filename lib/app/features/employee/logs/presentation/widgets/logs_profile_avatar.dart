import 'dart:io';

import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LogsProfileAvatar extends StatelessWidget {
  final File? file;

  final String name;
  final String description;
  final String imageUrl;
  const LogsProfileAvatar({
    super.key,
    required this.name,
    required this.description,
    this.file,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: CircleAvatar(
            radius: 40.r,
            backgroundColor: context.color.outline,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: file != null
                  ? Image.file(file!, fit: BoxFit.cover)
                  : imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
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
        ),
        const Gap(27),
        Text(
          name,
          style: TextStyle(
            color: context.color.font,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 0.06,
          ),
        ),
        const Gap(13),
        Text(
          textAlign: TextAlign.center,
          description,
          style: TextStyle(
            color: context.color.hint,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
