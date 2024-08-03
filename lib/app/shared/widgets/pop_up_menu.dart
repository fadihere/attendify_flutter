// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/gen/assets.gen.dart';

class CustomPopupMenu extends StatelessWidget {
  final Function(int)? onSelected;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final List<PopupMenuEntry<int>> Function(BuildContext) itemBuilder;
  const CustomPopupMenu({
    super.key,
    this.onSelected,
    this.padding,
    this.color,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: color ?? context.color.container,
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(minWidth: 162.r),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: context.color.outline),
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: context.color.whiteBlack,
      // splashRadius: 60.0,s
      offset: Offset(0, 11.r),
      itemBuilder: itemBuilder,
      child: Container(
        padding: padding,
        child: Icon(
          Icons.more_vert_rounded,
          size: 22.r,
        ),
      ),
    );
  }
}

class CustomPopItem extends StatelessWidget {
  final String title;
  final SvgGenImage icon;
  final Color? color;

  const CustomPopItem({
    super.key,
    required this.title,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 6.r),
        icon.svg(
          width: 15.r,
          colorFilter: ColorFilter.mode(
            color ?? context.color.icon,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.r),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.r,
            fontWeight: FontWeight.w500,
            color: color ?? context.color.font,
          ),
        ),
      ],
    );
  }
}
