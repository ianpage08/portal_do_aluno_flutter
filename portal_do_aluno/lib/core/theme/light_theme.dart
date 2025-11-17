import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBar,
      foregroundColor: AppColors.lightTextPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 1,
    ),
    cardTheme: const CardThemeData(color: AppColors.lightCard, elevation: 1),
    focusColor: AppColors.lightSecondary,

    iconTheme: const IconThemeData(color: AppColors.lightIcon),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: const Color.fromARGB(36, 172, 160, 228),
        foregroundColor: const Color.fromARGB(255, 41, 41, 41),
        side: const BorderSide(color: AppColors.lightIcon),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(137, 43, 72, 201),
        foregroundColor: AppColors.lightTextPrimary,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.lighThint),
      labelStyle: TextStyle(color: AppColors.lighThint),
      filled: true,
      fillColor: Color.fromARGB(255, 172, 160, 228),
      iconColor: AppColors.lightIcon,
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightBorder, width: 2),
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
        color: AppColors.lightTextPrimary,
      ),
      titleMedium: TextStyle(fontSize: 16, color: AppColors.lightTextPrimary),
      titleSmall: TextStyle(fontSize: 14, color: AppColors.lightTextPrimary),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(162, 170, 170, 170),

      secondary: AppColors.student,
      tertiary: AppColors.teacher,
    ),
  );
}
