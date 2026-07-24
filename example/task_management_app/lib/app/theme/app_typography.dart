import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      displaySmall: TextStyle(
        color: textColor,
        fontFamily: 'monospace',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.08,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      labelMedium: TextStyle(
        color: textColor,
        fontFamily: 'monospace',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0.7,
      ),
    );
  }
}
