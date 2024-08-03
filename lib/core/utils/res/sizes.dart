import 'package:flutter/material.dart';

class AppSizes {
  static Size? screenSize;

  static bool? isPhone;
  static double? width;
  static double? height;
  static double? topPadding;

  //For dynamic Sizing
  static double? widthRatio;
  static double? heightRatio;
  static double? fontRatio;

  //Dynamic Font Sizes
  static double? extraSmallFontSize;
  static double? smallFontSize;
  static double? mediumFontSize;
  static double? regularFontSize;
  static double? largeFontSize;
  static double? extraLargeFontSize;
  static double? jumboFontSize;

  //padding
  static double? smallPadding;
  static double? regularPadding;
  static double? mediumPadding;
  static double? pagePadding;
  static double? largePadding;
  static double? extraLargePadding;
  static double? largerPadding;

  //tablet specific padding
  static double? tabletInnerPadding;
  static double? tabletOuterPadding;
  static double? tabletPagePadding;
  static double? tabletLargeOuterMargin;
  static double? tabletExtraLargeOuterMargin;
  static double? tabletSocialMediaPadding;
  static double? tabletAuthCommentPadding;

  static void init(context) {
    screenSize = MediaQuery.of(context).size;
    topPadding = MediaQuery.of(context).padding.top;
    width = screenSize!.shortestSide;
    height = screenSize!.longestSide;
    isPhone = screenSize!.shortestSide < 600;
    fontRatio =
        (isPhone! && screenSize!.width <= 360) ? screenSize!.width / 360 : 1.0;
    widthRatio = isPhone! ? screenSize!.width / 360 : screenSize!.width / 900;
    heightRatio =
        isPhone! ? screenSize!.height / 720 : screenSize!.height / 1200;
    extraSmallFontSize = 11.0 * fontRatio!;
    smallFontSize = 12.0 * fontRatio!;
    regularFontSize = 14.0 * fontRatio!;
    mediumFontSize = 16.0 * fontRatio!;
    largeFontSize = 18.0 * fontRatio!;
    extraLargeFontSize = 24.0 * fontRatio!;
    jumboFontSize = 32.0 * fontRatio!;

    smallPadding = 4.0 * widthRatio!;
    regularPadding = 8.0 * widthRatio!;
    mediumPadding = 12.0 * widthRatio!;
    pagePadding = 16.0 * widthRatio!;
    largePadding = 24.0 * widthRatio!;
    extraLargePadding = 32.0 * widthRatio!;
    largerPadding = 32.0 * widthRatio!;

    tabletOuterPadding = 144.0 * widthRatio!;
    tabletInnerPadding = 76.0 * widthRatio!;
    tabletPagePadding = 48.0 * widthRatio!;
    tabletExtraLargeOuterMargin = 228.0 * widthRatio!;
    tabletLargeOuterMargin = 172.0 * widthRatio!;
    tabletSocialMediaPadding = 192.0 * widthRatio!;
    tabletAuthCommentPadding = 99.0 * widthRatio!;
  }

  void refreshSize(context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize!.width;
    height = screenSize!.height;
  }
}
