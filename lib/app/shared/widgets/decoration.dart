import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/widgets.dart';

Decoration dropShadowDecoration(BuildContext context, [double radius = 20]) {
  return BoxDecoration(
    color: context.color.container,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: boxShadow(context),
  );
}

List<BoxShadow> boxShadow(BuildContext context) {
  return [
    BoxShadow(
      color: context.color.dropShadow.withOpacity(0.09),
      blurRadius: 10,
      spreadRadius: 2,
    )
  ];
}
