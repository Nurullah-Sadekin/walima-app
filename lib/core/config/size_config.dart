import 'package:flutter/material.dart';


class SizeConfig {
  static bool isMobile = true;
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? statusBarHeight;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  /// This class measures the screen height & width.
  /// Remember: Always call the init method at the start of your application or in main
  void init(BuildContext? context) {
    _mediaQueryData = MediaQuery.of(context!);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;

    _safeAreaHorizontal = (_mediaQueryData?.padding.left)! + (_mediaQueryData?.padding.right)!;
    _safeAreaVertical = (_mediaQueryData?.padding.top)!  + kToolbarHeight; //+ (_mediaQueryData?.padding.bottom)!
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!) / 100;

    statusBarHeight = _mediaQueryData!.padding.top;
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  /// mobile < 650
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  /// tablet >= 650
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;

  ///desktop >= 1100
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 650) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}