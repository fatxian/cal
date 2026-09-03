import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.forestGreen,
      brightness: Brightness.light,
      primary: AppColors.ink,
      onPrimary: Colors.white,
      secondary: AppColors.forestGreen,
      onSecondary: Colors.white,
      tertiary: AppColors.blushPink,
      onTertiary: AppColors.ink,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          height: 1.3,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: AppColors.ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 24,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.mintTag,
        selectedColor: AppColors.forestGreen,
        disabledColor: AppColors.surfaceSoft,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        labelStyle: const TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.mintText,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 84,
        elevation: 0,
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.mintTag,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return TextStyle(
            fontSize: 12,
            height: 1.2,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.ink : AppColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return IconThemeData(
            size: 28,
            color: isSelected ? AppColors.ink : AppColors.textMuted,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          backgroundColor: AppColors.forestGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.surfaceSoft,
          disabledForegroundColor: AppColors.textMuted,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          foregroundColor: AppColors.forestGreen,
          side: const BorderSide(color: AppColors.sageGreen),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.forestGreen, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
