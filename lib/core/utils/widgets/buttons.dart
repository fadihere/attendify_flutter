import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class AppButtonOutlineWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback onTap;
  final Color? color;
  final String text;

  final EdgeInsetsGeometry? margin;
  final bool isDisable;
  const AppButtonOutlineWidget({
    super.key,
    this.width,
    this.height,
    required this.onTap,
    this.color = LightColors.primary,
    required this.text,
    this.margin,
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisable ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: margin ?? const EdgeInsets.only(top: 60),
        height: 50,
        width: width ?? 400.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDisable ? LightColors.disableFont : LightColors.font,
          ),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: isDisable ? LightColors.disableFont : LightColors.font,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class AppButtonWidget extends StatelessWidget {
  final double? height;
  final double? borderRadius;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final String text;
  final EdgeInsetsGeometry? margin;
  final Color outline;
  final bool isDisable;
  final bool isLoading;
  final double? width;
  final String? subText;

  const AppButtonWidget({
    super.key,
    this.height,
    required this.onTap,
    this.color = LightColors.primary,
    required this.text,
    this.margin,
    this.isDisable = false,
    this.isLoading = false,
    this.borderRadius = 30,
    this.fontSize,
    this.textColor = LightColors.white,
    this.outline = Colors.transparent,
    this.width,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.only(top: 60),
      child: GestureDetector(
        onTap: isLoading || isDisable
            ? null
            : () {
                FocusManager.instance.primaryFocus?.unfocus();
                onTap();
              },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            width: width ?? 400.r,
            decoration: BoxDecoration(
              color: color,
              //color: isLoading || isDisable ? LightColors.disable : color,
              borderRadius: BorderRadius.circular(borderRadius!),
              border: Border.all(color: outline),
            ),
            child: Center(
                child: isLoading
                    ? const Loader()
                    : RichText(
                        text: TextSpan(
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: isDisable
                                ? context.color.disabledColor
                                : textColor ?? context.color.font,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.hellix,
                            fontSize: fontSize ?? 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: subText,
                                style: TextStyle(fontSize: 19.r)),
                            TextSpan(
                              text: text.toUpperCase(),
                            ),
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  final Color color;
  const Loader({super.key, this.color = Colors.white});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        // backgroundColor: context.color.primary,
      ),
    );
  }
}
