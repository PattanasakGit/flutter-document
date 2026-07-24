import 'package:ai_first_flutter_starter/app/theme/app_colors.dart';
import 'package:ai_first_flutter_starter/app/theme/app_radius.dart';
import 'package:ai_first_flutter_starter/app/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.signalBlue,
      secondary: AppColors.mint,
      onSecondary: AppColors.paper,
      error: AppColors.coral,
      onSurface: AppColors.ink,
      outline: AppColors.line,
    );
    return _build(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldColor: AppColors.cloud,
      textColor: AppColors.ink,
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF8EA6FF),
      onPrimary: AppColors.night,
      secondary: Color(0xFF73D9B4),
      onSecondary: AppColors.night,
      error: Color(0xFFFFB4AB),
      onError: AppColors.night,
      surface: AppColors.nightSurface,
      onSurface: AppColors.nightText,
      outline: AppColors.nightLine,
    );
    return _build(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldColor: AppColors.night,
      textColor: AppColors.nightText,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldColor,
    required Color textColor,
  }) {
    final textTheme = AppTypography.textTheme(textColor);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        labelStyle: textTheme.bodyMedium,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      visualDensity: VisualDensity.standard,
    );
  }
}
