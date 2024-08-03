import 'dart:io';

import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/config/routes/app_router.dart';

class ImageDialogWidget extends StatelessWidget {
  final void Function() onPressed;
  final File image;
  const ImageDialogWidget({
    super.key,
    required this.onPressed,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSize.sidePadding,
      backgroundColor: context.color.scaffoldBackgroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: AppSize.sidePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change Profile Picture",
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.cancel,
                    color: context.color.icon,
                  ),
                  onPressed: () => router.maybePop(),
                ),
              ],
            ),
            const Gap(5),
            Container(
              height: 300.sp,
              width: 297.sp,
              decoration: BoxDecoration(
                color: context.color.outline,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppButtonWidget(
              margin: const EdgeInsets.only(top: 15),
              onTap: () {
                onPressed();
                router.maybePop();
              },
              text: "SAVE",
            ),
            const Gap(15),
          ],
        ),
      ),
    );
  }
}
