import 'package:flutter/material.dart';

/// Centralized app colors
/// Access colors throughout the app using AppColors
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFFFD297B);
  static const Color primaryShade300 = Color(0xFFFFCAE3);
  static const Color primaryShade200 = Color(0xFFFEE5F0);
  static const Color primaryVariant = Color(0xFFFEF1F7);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);

  //Disable Colors
  static const Color disableBackground = Color(0xFFF7F7F7);
  static const Color disableText = Color(0xFFD1D1D1);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF171717);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color hintTextColor = Color(0xFFA3A3A3);
  static const Color textSecondaryLight = Color(0xFF5C5C5C);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Semantic Colors
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFEBEBEB);
  static const Color greyDark = Color(0xFF424242);

  // Transparent
  static const Color transparent = Colors.transparent;

  // Divider
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);

  static const Color inputBorder = Color(0xFFE6E6E9);
  static const Color errorBorderColor = Color(0xFFF75555);
  static const Color competeBorderColor = Color(0xFFFD297B);
  static const Color inputBorderColor = Color(0xFFE6E6E9);
  static const Color inActiveBorderColor = Color(0xFF818092);
  static const Color textSub600 = Color(0xFF5C5C5C);

  static LinearGradient get customBackgroundGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFDF2F8),
      Color(0xFFFFFFFF),
      Color(0xFFFAF5FF),
    ],
    stops: [0.0, 0.5, 1.0],
  );

}
