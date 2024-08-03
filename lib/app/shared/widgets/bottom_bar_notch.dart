import 'package:flutter/cupertino.dart';

class RectangleCircularNotched extends NotchedShape {
  final double radius;
  //comment
  RectangleCircularNotched({required this.radius});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null) {
      return Path()..addRect(host);
    }

    final double notchRadius = radius;
    // const double s1 = 15.0;
    // const double s2 = 1.0;

    // final double r = notchRadius + s1;
    // final double a = -1.0 * notchRadius - s2;
    // final double b = host.width - guest.left - notchRadius - s2;

    final double notchCenterX = guest.left + guest.width / 2.0;
    // final double notchCenterY = guest.top + guest.height / 2.0;

    final double p1X = notchCenterX - notchRadius;
    // final double p1Y = notchCenterY;
    final double p2X = notchCenterX + notchRadius;
    // final double p2Y = notchCenterY;

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p1X, host.top)
      ..arcToPoint(Offset(p2X, host.top),
          radius: Radius.circular(notchRadius), clockwise: false)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
