import 'package:flutter/cupertino.dart';

class ThemeColors {
  static const white = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.white,
  );

  static const black = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.black,
  );

  static const primary = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(7, 153, 98, 1),
    darkColor: Color.fromRGBO(7, 153, 98, 1),
  );

  static const secondary = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(244, 188, 81, 1),
    darkColor: Color.fromRGBO(244, 188, 81, 1),
  );

  static const danger = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.systemRed,
    darkColor: CupertinoColors.systemRed,
  );

  static const text = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );

  static const subtleText = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.75),
    darkColor: Color.fromRGBO(255, 255, 255, 0.75),
  );

  static const background = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  );

  static const touchable = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(50, 50, 50, 1),
    darkColor: Color.fromRGBO(255, 255, 255, 0.8),
  );

  static const uiBackground = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.extraLightBackgroundGray,
    darkColor: CupertinoColors.black,
  );

  static const surfaceText = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(50, 50, 50, 1),
    darkColor: CupertinoColors.black,
  );

  static const surfaceSubtle = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(225, 225, 225, 1),
    darkColor: Color.fromRGBO(50, 50, 50, 1),
  );

  static const surfaceBackground = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );

  static const border = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.systemGrey5,
    darkColor: Color.fromRGBO(50, 50, 50, 1),
  );

  static const subtle = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.05),
    darkColor: Color.fromRGBO(255, 255, 255, 0.1),
  );

  static const subtleEmphasis = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    darkColor: Color.fromRGBO(255, 255, 255, 0.15),
  );

  static const transparent = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0),
    darkColor: Color.fromRGBO(255, 255, 255, 0),
  );
}
