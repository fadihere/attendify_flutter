import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final SvgGenImage icon;
  final bool disableDivider;
  final double top;
  final double bottom;
  final BorderRadius? borderRadius;
  final Widget surfix;
  const TileWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.disableDivider = false,
    this.top = 5,
    this.bottom = 5,
    this.borderRadius,
    this.surfix = const Offstage(),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.r,
                right: 20.r,
                top: top.r,
                bottom: bottom.r,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 20.r),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: icon.svg(
                        colorFilter: ColorFilter.mode(
                          context.color.icon,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontFamily.hellix),
                              textAlign: TextAlign.left,
                            ),
                            surfix,
                          ],
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: disableDivider ? Colors.transparent : context.color.divider,
          height: 0,
          endIndent: 20,
          indent: 50,
        ),
      ],
    );
  }
}
