import 'package:flutter/material.dart';
import 'dart:math';

class ResponsiveScale {
  static ScalingQuery of(BuildContext context) {
    return ScalingQuery(context);
  }
}
class ScalingQuery {

  ScalingQuery(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _topPadding = MediaQuery.of(context).padding.top;
    _shortDimension = width < height ? width : height;
    _longDimension = width < height ? height : width;
  }
  final _guidelineBaseWidth = 350;
  final _guidelineBaseHeight = 680;

  late num _shortDimension;
  late num _longDimension;
  late num _topPadding;

  double fontSize(double size) {
    var tempLongDimension = (16 / 9) * _shortDimension;
    return sqrt(pow(tempLongDimension, 2) + pow(_shortDimension, 2)) *
        (size / 100);
  }

  double scale(double size) {
    return _shortDimension / _guidelineBaseWidth * size;
  }

  double verticalScale(double size) {
    return _longDimension / _guidelineBaseHeight * size;
  }

  double moderateScale(double size, [double factor = 0.5]) {
    return size + (scale(size) - size) * factor;
  }

  double hp(num size) {
    return (_longDimension * size) / 100;
  }

  double fullHp() {
    return _longDimension - (_topPadding + kToolbarHeight);
  }

  double wp(num size) {
    return (_shortDimension * size) / 100;
  }
}