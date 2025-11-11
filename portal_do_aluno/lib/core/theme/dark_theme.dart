import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkSecondary,
    scaffoldBackgroundColor: AppColors.darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCard,
      foregroundColor: AppColors.darkTextPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(color: AppColors.darkCard, elevation: 0),
    focusColor: AppColors.darkSecondary,

    iconTheme: const IconThemeData(color: AppColors.darkIcon),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: const Color.fromARGB(255, 245, 241, 212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkTextPrimary,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 172, 160, 228),
      iconColor: AppColors.darkIcon,
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 176, 170, 204),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 138, 145, 248),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 252, 251, 226),
      ),
      titleSmall: TextStyle(fontSize: 14, color: AppColors.darkTextPrimary),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(162, 170, 170, 170),
      secondary: AppColors.student,
      tertiary: AppColors.teacher,
    ),
  );
}
