import 'package:flutter/material.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

abstract class AppThemes {
  /// Light theme configuration.
  static final ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryPanelaBrown,
      selectedItemColor: AppColors.textDark,
      unselectedItemColor: AppColors.textLight,
      selectedIconTheme: IconThemeData(size: 30),
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      color: AppColors.backgroundCrema,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: AppColors.backgroundCrema,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      extendedTextStyle: TextStyle(
        fontFamily: AppTypography.familyRoboto,
        fontSize: AppTypography.h3,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppRadius.small),
        ),
        backgroundColor: AppColors.primaryPanelaBrown,
        elevation: 5,
        textStyle: TextStyle(
          fontFamily: AppTypography.familyRoboto,
          fontSize: AppTypography.h3,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: AppTypography.familyRoboto,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: AppTypography.h2,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTypography.h3,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.h4,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTypography.body,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.h4,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.h5,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
