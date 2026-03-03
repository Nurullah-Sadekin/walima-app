import 'package:flutter/material.dart';

import 'app_colors.dart';

class InputBorderStyle {
  static InputBorder errorBorder(double? radius) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius ?? 60),
    gapPadding: 1,
    borderSide: const BorderSide(width: 1, color: AppColors.errorBorderColor),
  );

  static InputBorder focusedBorder(double? radius) => OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(radius ?? 60),
    borderSide: const BorderSide(width: 2, color: AppColors.competeBorderColor),
  );

  static InputBorder focusedErrorBorder(double? radius) => OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(radius ?? 60),
    borderSide: const BorderSide(width: 1, color: AppColors.errorBorderColor),
  );

  static InputBorder disabledBorder(double? radius) => OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(radius ?? 60),
    borderSide: const BorderSide(width: 1, color: Colors.black12),
  );

  static InputBorder enabledBorder(double? radius) => OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(radius ?? 60),
    borderSide: const BorderSide(width: 2, color: AppColors.inputBorderColor),
  );

  static InputBorder border(double? radius, {Color? borderColor}) => OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.all(Radius.circular(radius ?? 60)),
    borderSide: BorderSide(color: borderColor ?? AppColors.inputBorderColor, width: 2),
  );

  static InputBorder validBorder(double? radius, {Color? borderColor}) => OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(radius ?? 60),
    borderSide: BorderSide(width: 2, color: borderColor ??  AppColors.competeBorderColor),
  );
}