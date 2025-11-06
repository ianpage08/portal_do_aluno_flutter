import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6A1B9A), // Roxo vibrante para destaque
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
    ),

    cardTheme: const CardThemeData(color: Color(0xFFF4F2FB), elevation: 0),

    focusColor: AppColors.primary,

    iconTheme: const IconThemeData(color: Color.fromARGB(255, 149, 134, 167)),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: const Color(0xFF7E57C2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF1EAFD), // lilás bem suave
      iconColor: Color(0xFF4A148C),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFB39DDB), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF7E57C2), width: 2),
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
        color: Color(0xFF2E1A47),
      ),
      titleMedium: TextStyle(fontSize: 16, color: Color(0xFF3E2A59)),
      titleSmall: TextStyle(fontSize: 14, color: Color(0xFF4B3A6B)),
    ),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6A1B9A), // Roxo principal
      secondary: AppColors.student,
      tertiary: AppColors.teacher,
    ),
  );
}
