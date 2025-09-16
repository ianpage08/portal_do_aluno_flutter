import 'package:flutter/material.dart';

import '../app_constants/colors.dart';

ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    /*ColorScheme.fromSeed() = Gera paleta de cores baseada em uma cor
    seedColor = Cor base para gerar outras cores
    brightness = Define se é tema claro ou escuro */
    colorScheme:  ColorScheme.fromSeed(seedColor:AppColors.primary,brightness: Brightness.light,),
    
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0, // Sem sombra
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // cor do texto
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(8)), // bordas arredondadas
    )
  )
  );
}